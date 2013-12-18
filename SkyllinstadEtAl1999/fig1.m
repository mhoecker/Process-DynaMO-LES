function fig1(sfxnc,chmnc,outdir)
 %function fig1(sfxnc,chmnc,outdir)
 %
 % 4 plots stacked vertically with a common x-axis (yearday)
 %
 % 1st plot is Wind stress (tau~Pa) as a function of time
 % 2nd plot is Precipitation (P~mm/h) as a function of time
 % 3rd plot is Net Heat flux (J~W/m^2) as a function of time
 % 4th plot is Turbulent dissipation (epsilon~W/kg) as a function of depth (m) and time
 %
 % The simulated time is bracketed by 2 days prior and 1 day after
 % The simulated time is highlighted on the line plots
 % line plots are filled
 % epsilon is plotted on a log10 scale
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim-1,tfsim+1];
 zrange = sort([0,-dsim]);
 % Extract Flux data
 [tsfx,stress,p,Jh] = surfaceflux(sfxnc,trange);
 # Extract epsilon profiles
 [tchm,zchm,epschm]=ChameleonProfiles(chmnc,trange,zrange);
 # Plot using octave or Gnuplot
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
  # Save Flux data
  binarray(tsfx',[stress,p,Jh]',[outdir "fig1abc.dat"]);
  # Save epsilon profiles
  binmatrix(tchm',zchm',epschm',[outdir "fig1d.dat"]);
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig1.plt");
 end%if
end%function
