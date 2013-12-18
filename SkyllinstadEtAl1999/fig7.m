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
 # Convert depth to negavite definite
 DAGheat.zzw = -DAGheat.zzw;
 DAGheat.zzu = -DAGheat.zzu;
 DAGheat.trange = max(max(DAGheat.t_ave))-min(min(DAGheat.t_ave));
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
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.t2_ave'./DAGheat.trange^2,[outdir "fig7c.dat"]);
  binmatrix(DAGheat.Yday',DAGheat.zzu',DAGheat.t_ave' ,[outdir "fig7d.dat"]);
  # invoke gnuplot
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig7.plt");
 end%if
end%function
