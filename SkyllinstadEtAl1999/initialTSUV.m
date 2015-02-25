function  initialTSUV(TSUVnc,outdir)
 %figure 2
 %
 % two side by side plots with a common y axis (depth)
 %
 % 1st plot on upper x-axis Salinity (psu) on lower x-axis Potential Temperature (C) at simulation start
 % 2nd plot E/W (u) and N/S (v) velocity at simulation start
 findgsw;
 abrev = "initialTSUV";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,t0sim];
 zrange = sort([0,-dsim]);
 zsim  = abs(zrange(1):1:zrange(2));
 TSUV =netcdf(TSUVnc,'r');
 z = TSUV{'Z'}(:);
 idx = inclusiverange(z,zrange);
 z = TSUV{'Z'}(idx)';
 CT = TSUV{'CT'}(idx)';
 S = TSUV{'SA'}(idx)';
 U = TSUV{'U'}(idx)';
 V = TSUV{'V'}(idx)';
 ncclose(TSUV)
 if(max(z)<0)
  imin = find(z==max(z),1);
  z = [z(:);0]';
  CT = [CT(:);CT(imin)]';
  S = [S(:);S(imin)]';
  U = [U(:);U(imin)]';
  V = [V(:);V(imin)]';
 end%if
 findgsw;
 T = gsw_t_from_CT(S,CT,0*S);
 %useoctplot=1
 if(useoctplot==1)
  figure(1)
  subplot(2,2,1)
  plot(T,z)
  axis([min(T),max(T),zrange])
  subplot(2,2,2)
  plot(S,z)
  axis([min(S),max(S),zrange])
  subplot(2,2,3)
  plot(U,z)
  axis([min([U]),max([U]),zrange])
  subplot(2,2,4)
  plot(V,z)
  axis([min([V]),max([V]),zrange])
  print([outdir 'fig2.png'],'-dpng')
 else
  %
  CTmid = (max(CT)+min(CT))/2;
  Smid  = (max(S)+min(S))/2;
  Tmid = (max(T)+min(T))/2;
  UVmid = (max([max(U),max(V)])+min([min(U),min(V)]))/2;
  %
  DCT = (max(CT)-min(CT))/2;
  DS  = (max(S)-min(S))/2;
  DT  = (max(T)-min(T))/2;
  DUV = (max([max(U),max(V)])-min([min(U),min(V)]))/2;
  %
  alpha = gsw_alpha(Smid,CTmid,0);
  beta = gsw_beta(Smid,CTmid,0);
  %
  DrhoT = abs(alpha*DCT);
  DrhoS = abs(beta*DS);
  %
  pad = 1.1
  UVmax = UVmid+pad*DUV;
  UVmin = UVmid-pad*DUV;
  if(DrhoT>DrhoS)
   Tmax = Tmid+DT*pad;
   Tmin = Tmid-DT*pad;
   Smin = Smid-DS*pad*DrhoT/DrhoS;
   Smax = Smid+DS*pad*DrhoT/DrhoS;
  else
   Tmax = Tmid+DT*pad*DrhoS/DrhoT;
   Tmin = Tmid-DT*pad*DrhoS/DrhoT;
   Smin = Smid-DS*pad;
   Smax = Smid+DS*pad;
  end%if
  # save CT,SA,U,V profiles
  binarray(z,[T;S;U;V],[dir.dat abrev "TSUV.dat"]);
  Trangetext = cstrcat('Tmin= ',num2str(Tmin,"%12f"),'\nTmax= ',num2str(Tmax,"%12f"));
  Srangetext = cstrcat('Smin= ',num2str(Smin,"%12f"),'\nSmax= ',num2str(Smax,"%12f"));
  UVrangetext = cstrcat('UVmin= ',num2str(UVmin,"%12f"),'\nUVmax= ',num2str(UVmax,"%12f"));
  unix(cstrcat('echo "',Trangetext,'">>',limitsfile));
  unix(cstrcat('echo "',Srangetext,'">>',limitsfile));
  unix(cstrcat('echo "',UVrangetext,'">>',limitsfile));
  unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
 end%if
end%function
