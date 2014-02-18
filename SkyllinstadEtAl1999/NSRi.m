function NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %
 %figure 4
 % Plot time series of N^2 S^2 and Ri
 abrev = "NSRi";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
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
 # Calculate vertical derivative matrix
 ddzdag = ddz(zdag);
 #
 # Calulate the Driven Richarson number
 [Ri,Jb]  = surfaceRi(stress,Jh,sst,sal);
 #
 # Calculate Density
 # need gsw
 findgsw;
 # Gravity
 g = gsw_grav(0);
 # Pressure
 Pdag = gsw_p_from_z(zdag,0);
 # Density
 rhoavg = gsw_rho(Savgdag,Tavgdag,0);
 # Mean Density
 rho0 = mean(mean(rhoavg));
 #
 # Calculate Stratification
 Nsqavg = -(g/rho0)*(ddzdag*rhoavg')';
 #
 # Calculate Shear
 Ssqavg = ((ddzdag*uavgdag').^2+(ddzdag*vavgdag').^2)';
 #
 # Calculate Richardson #
 Ricavg = Nsqavg./Ssqavg;
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
  binarray(tsfx',[4*Ri,Jb,stress]',[outdir abrev "a.dat"]);
  binmatrix(tdag',zdag',Nsqavg',[outdir abrev "b.dat"]);
  binmatrix(tdag',zdag',Ssqavg',[outdir abrev "c.dat"]);
  binmatrix(tdag',zdag',Ricavg',[outdir abrev "d.dat"]);
  binmatrix(tdag',zdag',rhoavg',[outdir abrev "e.dat"]);
  unix(["gnuplot " limitsfile " " scriptdir abrev "tab.plt"]);
  unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
 end%if
 %
end%function
