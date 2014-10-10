function ObsSurfEps(sfxnc,chmnc,outdir,wavespecHL,trange)
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
 abrev = "ObsSurfEps";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 if(nargin<5)
  trange = [t0sim,tfsim];
 end%if
 zrange = sort([0,-dsim]);
 % Extract Flux data
 [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,cp,sigH] = surfaceflux(sfxnc,trange,wavespecHL);
 # Decomplse Stress into components
 stressm = -stress.*sin(wdir*pi/180);
 stressz = -stress.*cos(wdir*pi/180);
 #Calculate Stokes Drift and wavenumber
 findgsw;
 g = gsw_grav(0);
 k = g./(cp.*cp);
 U = cp.*(sigH.*k/2).^2;
 l = 2*pi./k;
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
  binarray(tsfx',[Jh,p,stressm,stressz,U,l]',[outdir abrev "JhPrecipTxTyUk.dat"]);
  # Save epsilon profiles
  binmatrix(tchm',zchm',epschm',[outdir abrev "d.dat"]);
  if(nargin>3)
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
   trangetext = ['t0sim = ' num2str(trange(1),"%12.10f") '; tfsim=' num2str(trange(2),"%12.10f") ';set xrange [t0sim:tfsim]']
   xtictext = ['set xtic t0sim,' num2str(dttic,"%12.10f")]
   mxtictext = ['set mxtic ' num2str(dtmtic,"%2i")]
   unix(['echo "' trangetext '">>' limitsfile]);
   unix(['echo "' xtictext '">>' limitsfile]);
   unix(['echo "' mxtictext '">>' limitsfile]);
  end%if
  unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"])
 end%if
end%function
