function NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %
 %figure 4
 % Plot time series of N^2 S^2 and Ri
 abrev = "NSRi";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 #useoctplot=1;
 trange = [t0sim-2,tfsim+2];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = DAGsfcflux(dagnc,trange);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 % Calculate derivative matrix
 ddzdag = ddz(zdag,3);
 % need gsw
 findgsw;
 g = gsw_grav(0);
 % Calculate pressure
 P = gsw_p_from_z(zdag,0);
 % Calculate Absolute Salinity
 SA = gsw_SA_from_SP(Savgdag,P,0,0);
 % Calculate Conservative Temperature
 CT = gsw_CT_from_t(SA,Tavgdag,P);
 % Calculate density(S,T,Z)
 rho = gsw_rho(SA,CT,P);
 % Calculate Buoyancy frquency
 Nsqavg = -g*(rho*ddzdag')./rho;
 # Calculate vertical derivative matrix
 ddzdag = ddz(zdag);
 #
 # Calulate the Driven Richarson number
 [Ri,Jb]  = surfaceRi(stress,Jh,sst,sal);
 #
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
  binarray(tsfx',[4*Ri,Jb,stress]',[dir.dat abrev "a.dat"]);
  binmatrix(tdag',zdag',Nsqavg',[dir.dat abrev "b.dat"]);
  binmatrix(tdag',zdag',Ssqavg',[dir.dat abrev "c.dat"]);
  binmatrix(tdag',zdag',Ricavg',[dir.dat abrev "d.dat"]);
  binmatrix(tdag',zdag',rho',[dir.dat abrev "e.dat"]);
  unix(["gnuplot " limitsfile " " dir.script abrev "tab.plt"]);
  unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
 end%if
 %
end%function
