function fig4(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %
 %figure 4
 % Plot time series of N^2 S^2 and Ri
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 #useoctplot=1;
 trange = [t0sim-2,tfsim+2];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 # Calulatwe the Driven Richarson number
 [Ri,Jb]  = surfaceRi(stress,Jh,sst,sal);
 #
 if(useoctplot==1)
  subplot(4,1,1)
%  plot(tsfx,Jh,tsfx,0*ones(size(tsfx)),"k")
%  ylabel("Jh")
%  subplot(4,1,2)
%  plot(tsfx,stress)
%  ylabel("stress")
%  subplot(4,1,3)
%  semilogy(tsfx,4*Ri,tsfx,ones(size(tsfx)),"k")
%  ylabel("+4Ri")
%  subplot(4,1,4)
%  semilogy(tsfx,-4*Ri,tsfx,ones(size(tsfx)),"k")
%  ylabel("-4Ri")
  subplot(2,1,1)
  semilogy(tsfx,4*Ri,tsfx,ones(size(tsfx)),"k")
  ylabel("+4Ri")
  subplot(2,1,2)
  semilogy(tsfx,-4*Ri,tsfx,ones(size(tsfx)),"k")
  ylabel("-4Ri")
  print([outdir "fig4.png"],"-dpng")
 else
  binarray(tsfx',[4*Ri,Jb,stress]',[outdir "fig4a.dat"]);
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig4.plt");
 end%if
 %
end%function
