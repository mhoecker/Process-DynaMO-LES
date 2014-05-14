function [Ptkegrid,khun,z] = Hspectra(rstnc,outname,dagnc)
 useoctplot = 0;
 % Get time
 [tdims,tvar] = myncread(rstnc,{'time'},{'time'});
 if(nargin>2)
  % Get wind direction
  [taudims,tauvars] = myncread(dagnc,{'time','z','y','x'},{'ustr_t','vstr_t'},{[1,1]*tvar{1}(1),[1,1],[1,1],[1,1]});
  theta = atan2(tauvars{2}(:),tauvars{1}(:));
 end%if
 %
 nc = netcdf(rstnc,'r');
 x = nc{'xu'}(:);
 y = nc{'yv'}(:);
 z = nc{'zu'}(:);
 z = z-max(z);
 # arrays for iotropic spectra
 Pugrid = [];
 Pvgrid = [];
 Pwgrid = [];
 Ptgrid = [];
 Ptkegrid = [];
 # arrays for windward spectra
 PuWgrid = [];
 PvWgrid = [];
 PwWgrid = [];
 PtWgrid = [];
 PtkeWgrid = [];
 # arrays for cross wind spectra
 PuXgrid = [];
 PvXgrid = [];
 PwXgrid = [];
 PtXgrid = [];
 PtkeXgrid = [];
 #
 Nx = length(x);
 Ny = length(y);
 N = floor(sqrt(min([Nx,Ny])/32));
 for i=1:length(z)
  uz = squeeze(nc{'um'}(1,i,:,:))';
  uz = uz-mean(mean(uz));
  uz = window2d(uz,0);
  vz = squeeze(nc{'vm'}(1,i,:,:))';
  vz = vz-mean(mean(vz));
  vz = window2d(vz,0);
  wz = squeeze(nc{'wm'}(1,i,:,:))';
  wz = wz-mean(mean(wz));
  wz = window2d(wz,0);
  tz = squeeze(nc{'t'}(1,i,:,:))';
  tz = tz-mean(mean(tz));
  tz = window2d(tz,0);
  if(useoctplot==1)
   [Pu,k,l,Pua,ka,la,Pub,khun]=twodpsd(x,y,uz,N,['/home/mhoecker/tmp/u' num2str(i,"%06i")]);
   [Pv,k,l,Pva,ka,la,Pvb,khun]=twodpsd(x,y,vz,N,['/home/mhoecker/tmp/v' num2str(i,"%06i")]);
   [Pw,k,l,Pwa,ka,la,Pwb,khun]=twodpsd(x,y,wz,N,['/home/mhoecker/tmp/w' num2str(i,"%06i")]);
   [Pt,k,l,Pta,ka,la,Ptb,khun]=twodpsd(x,y,tz,N,['/home/mhoecker/tmp/t' num2str(i,"%06i")]);
  else
   [Pu,k,l,Pua,ka,la,Pub,khun]=twodpsd(x,y,uz,N);
   [Pv,k,l,Pva,ka,la,Pvb,khun]=twodpsd(x,y,vz,N);
   [Pw,k,l,Pwa,ka,la,Pwb,khun]=twodpsd(x,y,wz,N);
   [Pt,k,l,Pta,ka,la,Ptb,khun]=twodpsd(x,y,tz,N);
  end%if
  # Calculate tke specrta
  Ptke = Pu+Pv+Pw;
  Ptkea = Pua+Pva+Pwa;
  Ptkeb = Pub+Pvb+Pwb;
  # Append isotropic spectra
  Pugrid = [Pugrid;Pub];
  Pvgrid = [Pvgrid;Pvb];
  Pwgrid = [Pwgrid;Pwb];
  Ptgrid = [Ptgrid;Ptb];
  Ptkegrid = [Ptkegrid;Ptkeb];
  # Save 2-D Spectra
  binmatrix(k,l,Pu,[outname "Spectra-u-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Pv,[outname "Spectra-v-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Pw,[outname "Spectra-w-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Pt,[outname "Spectra-t-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Ptke,[outname "Spectra-tke-2D-" num2str(i,"%06i") ".dat"]);
  # Save Band Averaged 2-D Spectra
  binmatrix(ka,la,Pua,[outname "Average-Spectra-u-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Pva,[outname "Average-Spectra-v-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Pwa,[outname "Average-Spectra-w-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Pta,[outname "Average-Spectra-t-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Ptkea,[outname "Average-Spectra-tke-2D-" num2str(i,"%06i") ".dat"]);
  # Save 1-D spectra for gnuplot to ingest
  binarray(khun,Pub,  [outname "Average-Spectra-u-isotropic-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Pvb,  [outname "Average-Spectra-v-isotropic-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Pwb,  [outname "Average-Spectra-w-isotropic-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Ptb,  [outname "Average-Spectra-t-isotropic-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Ptkeb,[outname "Average-Spectra-tke-isotropic-1D-" num2str(i,"%06i") ".dat"]);
  if(nargin>2)
   # Calculate Radial spectra Paraelell to wind
   [kr,Pur]=directionalSpec(theta,k,l,Pu);
   [kr,Pvr]=directionalSpec(theta,k,l,Pv);
   [kr,Pwr]=directionalSpec(theta,k,l,Pw);
   [kr,Ptr]=directionalSpec(theta,k,l,Pt);
   Ptker = Pur+Pvr+Pwr;
   # Append windward spectra
   PuWgrid = [PuWgrid;Pur];
   PvWgrid = [PvWgrid;Pvr];
   PwWgrid = [PwWgrid;Pwr];
   PtWgrid = [PtWgrid;Ptr];
   PtkeWgrid = [PtkeWgrid;Ptker];
   # Save windward spectra
   binarray(kr,Pur,  [outname "Average-Spectra-u-windward-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(kr,Pvr,  [outname "Average-Spectra-v-windward-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(kr,Pwr,  [outname "Average-Spectra-w-windward-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(kr,Ptr,  [outname "Average-Spectra-t-windward-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(kr,Ptker,  [outname "Average-Spectra-tke-windward-1D-"   num2str(i,"%06i") ".dat"]);
   # Calculate spectra perpendicular to wind
   [ks,Pus]=directionalSpec(theta+pi/2,k,l,Pu);
   [ks,Pvs]=directionalSpec(theta+pi/2,k,l,Pv);
   [ks,Pws]=directionalSpec(theta+pi/2,k,l,Pw);
   [ks,Pts]=directionalSpec(theta+pi/2,k,l,Pt);
   Ptkes = Pus+Pvs+Pws;
   # Append cross wind spectra
   PuXgrid = [PuXgrid;Pus];
   PvXgrid = [PvXgrid;Pvs];
   PwXgrid = [PwXgrid;Pws];
   PtXgrid = [PtXgrid;Pts];
   PtkeXgrid = [PtkeXgrid;Ptkes];
   # Save cross wind spectra
   binarray(ks,Pus,  [outname "Average-Spectra-u-Xwind-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(ks,Pvs,  [outname "Average-Spectra-v-Xwind-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(ks,Pws,  [outname "Average-Spectra-w-Xwind-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(ks,Pts,  [outname "Average-Spectra-t-Xwind-1D-"   num2str(i,"%06i") ".dat"]);
   binarray(ks,Ptkes,  [outname "Average-Spectra-tke-Xwind-1D-"   num2str(i,"%06i") ".dat"]);
  end%if
  #
  if(useoctplot)
   figure(1)
   subplot(1,2,1)
   pcolor(kk,ll,log(Ptke)/log(10)); shading flat
   xlabel("k Zonal Wavenumber (rad/m)");
   ylabel("l Meridional Wavenumber (rad/m)");
   axis([0,Nx*dk/2,-Ny*dl/2,Ny*dl/2])
   caxis(log(max(Ptkeb(2:end))*[.5/(Nx*Ny)^2,2])/log(10))
   subplot(1,2,2)
   loglog(khun(2:end),Ptkeb(2:end),".",khun(2:end),max(Ptkeb(2:end))*(khun(2:end)./min([dk,dl])).^(-5/3),"k;k^{-5/3};")
   axis([min([dk,dl]),max(khun),max(Ptkeb(2:end))*[.5/(Nx*Ny)^2,2]])
   title(["z=" num2str(z(i)) "m"])
   xlabel("Horizontal Wavenumber (rad/m)")
   ylabel("Spectral Energy Density (m^2/s^2/rad/m)")
   caxis(log(max(Ptkeb(2:end))*[.5/(Nx*Ny)^2,2])/log(10))
   colorbar();
   print([outname "Spectra-tke" num2str(i,"%06i") ".png"],"-dpng")
  end%if
 end%for
 # isotropic spectra
 binmatrix(khun,z,Pugrid,[outname "Spectra-u.dat"]);
 binmatrix(khun,z,Pvgrid,[outname "Spectra-v.dat"]);
 binmatrix(khun,z,Pwgrid,[outname "Spectra-w.dat"]);
 binmatrix(khun,z,Ptgrid,[outname "Spectra-t.dat"]);
 binmatrix(khun,z,Ptkegrid,[outname "Spectra-tke.dat"]);
 if(nargin>2)
  # windward
  binmatrix(kr,z,PuWgrid,[outname "Spectra-u-wind.dat"]);
  binmatrix(kr,z,PvWgrid,[outname "Spectra-v-wind.dat"]);
  binmatrix(kr,z,PwWgrid,[outname "Spectra-w-wind.dat"]);
  binmatrix(kr,z,PtWgrid,[outname "Spectra-t-wind.dat"]);
  binmatrix(kr,z,PtkeWgrid,[outname "Spectra-tke-wind.dat"]);
  # cross wind
  binmatrix(ks,z,PuXgrid,[outname "Spectra-u-Xwind.dat"]);
  binmatrix(ks,z,PvXgrid,[outname "Spectra-v-Xwind.dat"]);
  binmatrix(ks,z,PwXgrid,[outname "Spectra-w-Xwind.dat"]);
  binmatrix(ks,z,PtXgrid,[outname "Spectra-t-Xwind.dat"]);
  binmatrix(ks,z,PtkeXgrid,[outname "Spectra-tke-Xwind.dat"]);
 end%if
 #
 ncclose(nc);
end%function
