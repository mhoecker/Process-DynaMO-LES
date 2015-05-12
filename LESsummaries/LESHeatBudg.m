function LESHeatBudg(outdir,dagnc,bcfile)
% figure 7 Heat Profiles
 abrev = "LESHeatBudg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 sfcflx = SurfFlx(dagnc,bcfile,(trange-t0sim)*24*3600);
 # [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet]
 # Extract simulation data
 [DAGheat] = DAGheatprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 #Mixed Layer Depth
 [MLD,MLI]=getMLD(Savgdag,Tavgdag,zdag);
 [MLD2,MLI2]=getMLD(Savgdag,Tavgdag,zdag,.1);
 # convert to yearday
 DAGheat.Yday = t0sim+DAGheat.time/(24*3600);
 tdag = t0sim+tdag/(24*3600);
 # time derivative matricies
 ddt = ddz(DAGheat.time);
 # Convert depth to negavite definite
 DAGheat.zzw = -DAGheat.zzw;
 DAGheat.zzu = -DAGheat.zzu;
 # vertical derivative matricies
 ddzw = ddz(DAGheat.zzw);
 ddzu = ddz(DAGheat.zzu);
 # Define time range
 DAGheat.trange = max(max(DAGheat.t_ave))-min(min(DAGheat.t_ave));
 #
 DAGheat.hf_ave = DAGheat.hf_ave*4e6;
 DAGheat.wt_ave = DAGheat.wt_ave*4e6;
 DAGheat.dTdt_ave = ddt*DAGheat.t_ave*4e6;
 DAGheat.dhfdz_ave = -DAGheat.hf_ave*ddzw';
 DAGheat.dwtdz_ave = -DAGheat.wt_ave*ddzw';
 DAGheat.dTdt_ave = ddt*DAGheat.t_ave*4e6;
 DAGheat.T_dTdz_ave = sqrt(DAGheat.t2_ave)./abs(DAGheat.t_ave*ddzu');
 #
 #
 MLwt = MLD;
 MLwt2 = MLD2;
 for i=1:length(tdag)
  MLwt(i) = DAGheat.wt_ave(i,MLI(i));
  MLwt2(i) = DAGheat.wt_ave(i,MLI2(i));
 end%for
 #
 if(useoctplot==1)
  subplot(3,1,1)
  [Ydayw,zzw2] = meshgrid(DAGheat.Yday,DAGheat.zzw);
  pcolor(Ydayw',-zzw2',DAGheat.hf_ave); shading flat;
  subplot(3,1,2)
  pcolor(Ydayw',-zzw2',DAGheat.wt_ave); shading flat;
  subplot(3,1,3)
  [Ydayu,zzu2] = meshgrid(DAGheat.Yday,DAGheat.zzu);
  pcolor(Ydayu',-zzu2',log(DAGheat.t2_ave)); shading flat;
 else
  binarray(tdag',[sfcflx.Jh,MLwt,MLwt2]',[dir.dat abrev "Jh.dat"]);
  binarray(tdag',[MLD,MLwt]',[dir.dat abrev "ML.dat"]);
  binarray(tdag',[MLD2,MLwt2]',[dir.dat abrev "ML2.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.hf_ave',[dir.dat abrev "hf.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.wt_ave',[dir.dat abrev "wt.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.t2_ave',[dir.dat abrev "c.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.t_ave' ,[dir.dat abrev "d.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.dhfdz_ave',[dir.dat abrev "dhfdz.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.dwtdz_ave',[dir.dat abrev "dwtdz.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.dTdt_ave' ,[dir.dat abrev "dTdt.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.T_dTdz_ave' ,[dir.dat abrev "T_dTdz.dat"]);
  # invoke gnuplot
  unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
 end%if
end%function
