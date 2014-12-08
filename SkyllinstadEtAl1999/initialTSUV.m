function  initialTSUV(chmnc,adcpnc,outdir)
 %figure 2
 %
 % two side by side plots with a common y axis (depth)
 %
 % 1st plot on upper x-axis Salinity (psu) on lower x-axis Potential Temperature (C) at simulation start
 % 2nd plot E/W (u) and N/S (v) velocity at simulation start
 abrev = "initialTSUV";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,t0sim];
 zrange = sort([0,-dsim]);
 zsim  = abs(zrange(1):1:zrange(2));
 # Extract Legendre coefficients and fit velocity profiles from adcp file
 [Ucoef,Vcoef,Ufit,Vfit,zadcp,U,V] = uvLegendre(adcpnc,t0sim,dsim,1/24,5,["t";"z";"u";"v"]);
 zleg = (2*zsim-(min(zsim)+max(zsim)))/(max(zsim)-min(zsim));
 Usim = 0*zsim;
 Vsim = Usim;
 for i=0:length(Ucoef)-1
  l = legendre(i,zleg)(1,:);
  Usim = Usim+Ucoef(i+1)*l;
  Vsim = Vsim+Vcoef(i+1)*l;
 end%for
 #plot(U,zadcp,Ufit,zadcp)
 # read Chameleon file
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Plot using octave or gnuplot script
 if(useoctplot==1)
  figure(2)
  subplot(1,2,1)
  plot(Tchm,zchm,Schm,zchm)
  axis([min([Tchm,Schm]),max([Tchm,Schm]),zrange])
  subplot(1,2,2)
  plot(U,zadcp,V,zadcp)
  axis([min([U,V]),max([U,V]),zrange])
  print([outdir 'fig2.png'],'-dpng')
 else
  # save U,V profiles
  binarray(zadcp,[U;V;Ufit;Vfit],[dir.dat abrev "b.dat"]);
  binarray(zsim,[Usim;Vsim],[dir.dat abrev "UVfit.dat"]);
  # Save T,S profiles
  binarray(zchm',[Tchm;Schm],[dir.dat abrev "a.dat"]);
  unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
 end%if
end%function
