function fig7(chmnc,adcpnc,sfxnc,dagnc,outdir)
% figure 7 Heat Profiles
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange);
 # Calulatwe the Driven Richarson number
 [Ri,Jb]  = surfaceRi(stress,Jh,sst,sal);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [DAGheat] = DAGheatprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 DAGheat.Yday = t0sim+DAGheat.time/(24*3600);
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
 DAGheat.dhfdz_ave = -DAGheat.hf_ave*ddzw'*4e6;
 DAGheat.dwtdz_ave = -DAGheat.wt_ave*ddzw'*4e6;
 DAGheat.dTdt_ave = ddt*DAGheat.t_ave*4e6;
 #DAGheat.T_dTdz_ave = sqrt(DAGheat.t2_ave);
 #DAGheat.T_dTdz_ave = (DAGheat.t_ave*ddzu');
 DAGheat.T_dTdz_ave = sqrt(DAGheat.t2_ave)./abs(DAGheat.t_ave*ddzu');
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
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.hf_ave',[outdir "fig7a.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.wt_ave',[outdir "fig7b.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.t2_ave',[outdir "fig7c.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.t_ave' ,[outdir "fig7d.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.dhfdz_ave',[outdir "fig7dhfdz.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzw',DAGheat.dwtdz_ave',[outdir "fig7dwtdz.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.dTdt_ave' ,[outdir "fig7dTdt.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.T_dTdz_ave' ,[outdir "fig7T_dTdz.dat"]);
  # invoke gnuplot
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig7.plt");
 end%if
end%function
