function  ObsSimSideTSUVwSurf(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %ObsSimSideTSUVwSurf
 % Comparison of Temperature, Salinity, and Velocity in observations
 % and model.  The surface heat and momentum forcings are also shown
 %
 abrev = "ObsSim";
 abrev1 = "ObsSimTS";
 abrev2 = "ObsSimUV";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,tfsim];
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
 % Calculate Mixed Layer Depth
 [MLDchm,MLIchm,drhochm,rhochm,drho]=getMLD(Schm,Tchm,zchm);
 MLtext = ["MLtext = ' {/Symbol Dr}=" num2str(1000*drho,"%3.0f") " g/m^3'"];
 # extract ADCP data
 [tadcp,zadcp,ulpadcp,vlpadcp]=ADCPprofiles(adcpnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 % Calculate Mixed Layer Depth
 [MLD,MLI,drho,rho]=getMLD(Savgdag,Tavgdag,zdag,drho);
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
  binmatrix(tchm',zchm',Tchm',[dir.dat abrev "To.dat"]);#
  binmatrix(tchm',zchm',Schm',[dir.dat abrev "So.dat"]);#
  binmatrix(tchm',zchm',rhochm',[dir.dat abrev "rhoo.dat"]);#
  binmatrix(tchm',zchm',drhochm',[dir.dat abrev "drhoo.dat"]);#
  # save U,V profiles
  binmatrix(tadcp',zadcp',ulpadcp',[dir.dat abrev "Uo.dat"]);#
  binmatrix(tadcp',zadcp',vlpadcp',[dir.dat abrev "Vo.dat"]);#
  # Save surface flux profiles
  binarray(tsfx',[Jh,p,stressm,stressz]',[dir.dat abrev "JPtau.dat"]);#
  # save Simulated profiles
  binmatrix(tdag',zdag',Tavgdag',[dir.dat abrev "Ts.dat"]);#
  binmatrix(tdag',zdag',Savgdag',[dir.dat abrev "Ss.dat"]);#
  binmatrix(tdag',zdag',rho',[dir.dat abrev "rhos.dat"]);#
  binmatrix(tdag',zdag',drho',[dir.dat abrev "drhos.dat"]);#
  binmatrix(tdag',zdag',uavgdag',[dir.dat abrev "Us.dat"]);#
  binmatrix(tdag',zdag',vavgdag',[dir.dat abrev "Vs.dat"]);#
  # Mixed Layer Depths
  unix(['echo "' MLtext '">>' limitsfile]);
  binarray(tdag',[MLD]',[dir.dat abrev "ML.dat"]);
  binarray(tchm',[MLDchm]',[dir.dat abrev "MLchm.dat"]);
  #
  %unix(["gnuplot " limitsfile " " dir.script abrev "SideTSUVwSurf.plt"]);
  unix(["gnuplot " limitsfile " " dir.script abrev "T.plt"]);
  unix(["gnuplot " limitsfile " " dir.script abrev "S.plt"]);
  unix(["gnuplot " limitsfile " " dir.script abrev "UVwSurf.plt"]);
 end%if
end%function
