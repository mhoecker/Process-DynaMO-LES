function SalBudg(adcpnc,dagnc,outdir)
% Salinity Flux Profiles
 abrev = "SalBudg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,abrev);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = DAGsfcflux(dagnc,(trange-t0sim)*24*3600);
 # Extract simulation data
 [DAGSal] = DAGSalprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 #Mixed Layer Depth
 [MLD,MLI]=getMLD(Savgdag,Tavgdag,zdag);
 # convert to yearday
 DAGSal.Yday = t0sim+DAGSal.time/(24*3600);
 # time derivative matricies
 ddt = ddz(DAGSal.time);
 # Convert depth to negavite definite
 DAGSal.zzw = -DAGSal.zzw;
 DAGSal.zzu = -DAGSal.zzu;
 # vertical derivative matricies
 ddzw = ddz(DAGSal.zzw);
 ddzu = ddz(DAGSal.zzu);
 zzu2w = ddzinterp(DAGSal.zzu,DAGSal.zzw,3);
 # Define salinity range
 DAGSal.srange = max(max(DAGSal.s_ave))-min(min(DAGSal.s_ave));
 #
 DAGSal.rain = DAGSal.rain./mean(diff(DAGSal.time));
 DAGSal.sf_ave = DAGSal.sf_ave;
 DAGSal.ws_ave = DAGSal.ws_ave;
 DAGSal.dSdt_ave = ddt*DAGSal.s_ave;
 DAGSal.dwsdz_ave = -DAGSal.ws_ave*ddzw';
 %DAGSal.dsfdz_ave = -DAGSal.sf_ave*ddzw';
 DAGSal.dsfdz_ave = DAGSal.dSdt_ave*zzu2w'-DAGSal.dwsdz_ave;
 DAGSal.S_dSdz_ave = sqrt(DAGSal.s2_ave)./abs(DAGSal.s_ave*ddzu');
 #
 #
 MLws = 0*MLD;
 for i=1:length(DAGSal.time)
  MLws(i) = DAGSal.ws_ave(i,MLI(i));
 end%for
 #
 if(useoctplot==1)
  subplot(3,1,1)
  [Ydayw,zzw2] = meshgrid(DAGSal.Yday,DAGSal.zzw);
  pcolor(Ydayw',-zzw2',DAGSal.sf_ave); shading flat;
  subplot(3,1,2)
  pcolor(Ydayw',-zzw2',DAGSal.ws_ave); shading flat;
  subplot(3,1,3)
  [Ydayu,zzu2] = meshgrid(DAGSal.Yday,DAGSal.zzu);
  pcolor(Ydayu',-zzu2',log(DAGSal.d2_ave)); shading flat;
 else
  binarray(DAGSal.Yday',[p.*DAGSal.s_ave(:,end)*(1e-3/3600),MLws]',[outdir '/dat/' abrev "SFC_ML_flx.dat"]);
  binarray(DAGSal.Yday',[MLD,MLws]',[outdir '/dat/' abrev "ML.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.sf_ave',[outdir '/dat/' abrev "sf.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.ws_ave',[outdir '/dat/' abrev "ws.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.s2_ave',[outdir '/dat/' abrev "Ssq.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.s_ave' ,[outdir '/dat/' abrev "S.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.dsfdz_ave',[outdir '/dat/' abrev "dsfdz.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.dwsdz_ave',[outdir '/dat/' abrev "dwsdz.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.dSdt_ave' ,[outdir '/dat/' abrev "dSdt.dat"]);
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.S_dSdz_ave' ,[outdir '/dat/' abrev "S_dSdz.dat"]);
  % invoke gnuplot
  unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
 end%if
end%function
