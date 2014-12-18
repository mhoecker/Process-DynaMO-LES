function ObsSurfEps(dagnc,bcdat,outdir,trange)
 %function fig1(dagnc,bcascii,outdir,trange)
 %
 abrev = "ObsSurfEps";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dirs]=plotparam(outdir,abrev);
 if(nargin<4)
  trange = [t0sim,tfsim];
 end%if
 zrange = sort([0,-dsim]);
 % Extract Flux data
 [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,cp,sigH,HoT,HoS,LaBflx,JhBflx,SaBflx,netp] = DAGsfcflux(dagnc,bcdat,(trange-t0sim)*24*3600);
 tsfx=t0sim+tsfx./(24*3600);
 # Decomplse Stress into components
 %stressm = -stress.*sin(wdir*pi/180);
 %stressz = -stress.*cos(wdir*pi/180);
 stressm = real(stress);
 stressz = imag(stress);
 #Calculate Stokes Drift and wavenumber
 findgsw;
 g = gsw_grav(0);
 U = cp;
 l = sigH;
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
  binarray(tsfx',[Jh,netp,stressm,stressz,U,l]',cstrcat(dirs.dat,abrev,"JhPrecipTxTyUk.dat"));
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
