function  initialTSUV(TSUVnc,outdir)
 %figure 2
 %
 % two side by side plots with a common y axis (depth)
 %
 % 1st plot on upper x-axis Salinity (psu) on lower x-axis Potential Temperature (C) at simulation start
 % 2nd plot E/W (u) and N/S (v) velocity at simulation start
 abrev = "initialTSUV";
 outdir
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,t0sim];
 zrange = sort([0,-dsim]);
 zsim  = abs(zrange(1):1:zrange(2));
 TSUV =netcdf(TSUVnc,'r');
 z = TSUV{'Z'}(:);
 idx = inclusiverange(z,zrange);
 z = TSUV{'Z'}(idx)';
 T = TSUV{'CT'}(idx)';
 S = TSUV{'SA'}(idx)';
 U = TSUV{'U'}(idx)';
 V = TSUV{'V'}(idx)';
 ncclose(TSUV)
 if(max(z)<0)
  imin = find(z==max(z),1);
  z = [z(:);0]';
  T = [T(:);T(imin)]';
  S = [S(:);S(imin)]';
  U = [U(:);U(imin)]';
  V = [V(:);V(imin)]';
 end%if

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
  # save CT,SA,U,V profiles
  binarray(z,[T;S;U;V],[dir.dat abrev "TSUV.dat"]);
  unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
 end%if
end%function
