function  fig3(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %figure 3
 % Comparison of Temperature, Salinity, and Velocity in observations
 % and model.  The surface heat and momentum forcings are also shown
 %
 [useoctplot,t0sim,dsim]=plotparam(outdir);
 trange = [t0sim,t0sim+1];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir] = surfaceflux(sfxnc,trange);
 # Decomplse Stress into components
 stressm = -stress.*sin(wdir*pi/180);
 stressz = -stress.*cos(wdir*pi/180);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Convert Chameleon Salinity from absolute to practical
 findgsw; # Check to make sure Gibbs Sea Water is in the path
 Pchm = gsw_p_from_z(zchm,0);
 Schm = gsw_SP_from_SA(Schm,Pchm,80.5,0);
 # extract ADCP data
 [tadcp,zadcp,ulpadcp,vlpadcp]=ADCPprofiles(adcpnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 if(useoctplot==1)
  # Make co-ordinate 2-D arrays from lists
  [ttchm,zzchm] = meshgrid(tchm,zchm);
  [ttadcp,zzadcp] = meshgrid(tadcp,zadcp);
  [ttdag,zzdag] = meshgrid(tdag,zdag);
  # Picture time!
  figure(3)
  subplot(5,2,1)
  plot(tsfx,Jh,tsfx,p)
  subplot(5,2,2)
  plot(tsfx,stressz,tsfx,stressm)
  axis([trange])
  subplot(5,2,3)
  pcolor(ttchm,zzchm,Tchm')
  shading flat
  axis([trange])
  subplot(5,2,4)
  pcolor(ttdag,zzdag,Tavgdag')
  shading flat
  subplot(5,2,5)
  pcolor(ttchm,zzchm,Schm')
  shading flat
  axis([trange])
  axis([trange])
  subplot(5,2,6)
  pcolor(ttdag,zzdag,Savgdag')
  shading flat
  subplot(5,2,7)
  pcolor(ttadcp,zzadcp,ulpadcp')
  shading flat
  axis([trange])
  subplot(5,2,8)
  pcolor(ttdag,zzdag,uavgdag')
  shading flat
  subplot(5,2,9)
  pcolor(ttadcp,zzadcp,vlpadcp')
  shading flat
  axis([trange])
  subplot(5,2,10)
  pcolor(ttdag,zzdag,vavgdag')
  shading flat
  print([outdir 'fig3.png'],'-dpng')
 else
  # Save T,S profiles
  binmatrix(tchm',zchm',Tchm',[outdir "fig3c.dat"]);
  binmatrix(tchm',zchm',Schm',[outdir "fig3e.dat"]);
  # save U,V profiles
  binmatrix(tadcp',zadcp',ulpadcp',[outdir "fig3g.dat"]);
  binmatrix(tadcp',zadcp',vlpadcp',[outdir "fig3i.dat"]);
  # Save surface flux profiles
  binarray(tsfx',[Jh,p,stressm,stressz]',[outdir "fig3ab.dat"]);
  # save Simulated profiles
  binmatrix(tdag',zdag',Tavgdag',[outdir "fig3d.dat"]);
  binmatrix(tdag',zdag',Savgdag',[outdir "fig3f.dat"]);
  binmatrix(tdag',zdag',uavgdag',[outdir "fig3h.dat"]);
  binmatrix(tdag',zdag',vavgdag',[outdir "fig3j.dat"]);
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig3.plt");
 end%if
end%function