function NSRi(adcpnc,sfxnc,dagnc,outdir)
 %
 %figure 4
 % Plot time series of N^2 S^2 and Ri
 abrev = "NSRi";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 #useoctplot=1;
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract simulation data
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss] = DAGtkeprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # Get MLD
 [MLD,MLI]=getMLD(Savgdag,Tavgdag,zdag);
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
 rho = gsw_rho(SA,CT,P*0);
 % Calculate Buoyancy frquency
 Nsqavg = -g*(rho*ddzdag')./rho;
 # Calculate vertical derivative matrix
 ddzdag = ddz(zdag);
 #
 #
 #
 # Calculate Shear
 Ssqavg = ((ddzdag*uavgdag').^2+(ddzdag*vavgdag').^2)';
 #
 # Calculate Richardson #
 Ricavg = Nsqavg./Ssqavg;
 #
 # Calculate Ozmidov Scale
 LO = sqrt(-Diss)./power(abs(Nsqavg),3./4);
 LObad = find(Nsqavg<0);
 LO(LObad) = NaN;
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
  binmatrix(tdag',zdag',Nsqavg',cstrcat(dir.dat,abrev,"b.dat"));
  binmatrix(tdag',zdag',Ssqavg',cstrcat(dir.dat,abrev,"c.dat"));
  binmatrix(tdag',zdag',Ricavg',cstrcat(dir.dat,abrev,"d.dat"));
  binmatrix(tdag',zdag',rho',cstrcat(dir.dat,abrev,"e.dat"));
  binmatrix(tdag',zdag',LO',cstrcat(dir.dat,abrev,"LO.dat"));
  binarray(tdag',MLD',[dir.dat abrev "ML.dat"]);
  unix(cstrcat("gnuplot ",limitsfile," ",dir.script,abrev,"tab.plt"));
  unix(cstrcat("gnuplot ",limitsfile," ",dir.script,abrev,".plt"));
 end%if
 %
end%function
