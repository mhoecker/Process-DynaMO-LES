function LESSalBudg(outdir,dagnc)
% Salinity Flux Profiles
 abrev = "LESSalBudg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,tfsim]
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 sfflx = SurfFlx(dagnc,(trange-t0sim)*24*3600);
 # [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet]
 # Extract simulation data
 [DAGSal] = DAGSalprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 #Mixed Layer Depth
 [MLD,MLI]=getMLD(Savgdag,Tavgdag,zdag);
 [MLD2,MLI2]=getMLD(Savgdag,Tavgdag,zdag,.1);
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
 MLws2 = 0*MLD;
 for i=1:length(DAGSal.time)
  MLws(i) = DAGSal.ws_ave(i,MLI(i));
  MLws2(i) = DAGSal.ws_ave(i,MLI2(i));
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
  datprfx = cstrcat(dir.dat,abrev);
  MLD0 = 0.*DAGSal.Yday;
  MLws0 = sfflx.Salflx;
  binarray(DAGSal.Yday',[MLD0,MLws0]',cstrcat(datprfx,"SFC.dat"))
  binarray(DAGSal.Yday',[MLD ,MLws ]',cstrcat(datprfx,"ML.dat"));
  binarray(DAGSal.Yday',[MLD2,MLws2]',cstrcat(datprfx,"ML2.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.sf_ave',cstrcat(datprfx,"sf.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.ws_ave',cstrcat(datprfx,"ws.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.s2_ave',cstrcat(datprfx,"Ssq.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.s_ave' ,cstrcat(datprfx,"S.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.dsfdz_ave',cstrcat(datprfx,"dsfdz.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzw',DAGSal.dwsdz_ave',cstrcat(datprfx,"dwsdz.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.dSdt_ave' ,cstrcat(datprfx,"dSdt.dat"));
  binmatrix(DAGSal.Yday',DAGSal.zzu',DAGSal.S_dSdz_ave' ,cstrcat(datprfx,"S_dSdz.dat"));
  % invoke gnuplot
  unix(cstrcat("gnuplot ",limitsfile," ",dir.script,abrev,".plt"));
 end%if
end%function
