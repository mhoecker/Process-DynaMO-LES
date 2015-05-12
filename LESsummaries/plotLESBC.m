function plotLESBC(outdir,bcnc)
 %function plotLESBC(outdir,bcnc)
 %
 abrev = "LESBC";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dirs]=plotparam(outdir,abrev);
 zrange = sort([0,-dsim]);
 trange = [t0sim,tfsim];
 % Extract Flux data
 field=["time";"lhf_top";"swf_top";"hf_top";"rain";"ustr_t";"vstr_t";"wave_l";"wave_h";"w_angle"]
 bc = bcvars(bcnc,field);
 bc.time = bc.time/3600/24;
 % Calculate Stokes Drift and wavenumber
 findgsw;
 g = gsw_grav(0);
 % Plot using octave or Gnuplot
 if(useoctplot==1)
  figure(1)
  subplot(4,1,1)
  plot(tsfx,stress)
  ylabel("Wind Stress (Pa)")
  subplot(4,1,2)
  plot(tsfx,p)
  ylabel("Precipitation rate (mm/hour)")
  subplot(4,1,3)
  plot(tsfx,Jh)
  ylabel("Heat Flux (W/m^2)")
  [tt,zz] = meshgrid(tchm,zchm);
  subplot(4,1,4)
  pcolor(tt,zz,log(epschm')/log(10));
  shading flat;
  axis([trange,zrange]);
  colorbar()
  xlabel("2011 Year Day")
  ylabel("Depth (m)")
  print([outdir 'fig1.png'],'-dpng')
 else
  % Save Flux data
  binarray(bc.time',[bc.hf_top+bc.lhf_top+bc.swf_top,bc.rain,bc.ustr_t,bc.vstr_t,bc.wave_h,bc.wave_l]',cstrcat(dirs.dat,abrev,".dat"));
  if(nargin>3)
   trange
   dtplot = diff(trange);
   T = max(trange)-min(trange);
   if(T<1)
    dttic = 1.0/24.0;
    dtmtic = 4;
   elseif(T<3)
    dttic = 1;
    dtmtic = 4;
   else
    dttic = ceil(T/3);
    dtmtic = dttic;
   end%if
   trangetext = cstrcat('t0sim = ',num2str(trange(1),"%12.10f"),'; tfsim=',num2str(trange(2),"%12.10f"),';set xrange [t0sim:tfsim]');
   xtictext = cstrcat('set xtic t0sim,',num2str(dttic,"%12.10f"));
   mxtictext = cstrcat('set mxtic ',num2str(dtmtic,"%2i"));
   unix(cstrcat('echo "',trangetext,'">>',limitsfile));
   unix(cstrcat('echo "',xtictext,'">>',limitsfile));
   unix(cstrcat('echo "',mxtictext,'">>',limitsfile));
  end%if
  unix(cstrcat("gnuplot ",limitsfile," ",dirs.script,abrev,".plt"))
 end%if
end%function
