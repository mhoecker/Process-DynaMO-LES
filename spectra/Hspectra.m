function [Ptkegrid,khun,z] = Hspectra(rstnc,outname,term)
 if(nargin()<3)
  term = 'png';
 end%if
 useoctplot = 0;
 nc = netcdf(rstnc,'r');
 x = nc{'xu'}(:);
 y = nc{'yv'}(:);
 z = nc{'zu'}(:);
 z = z-max(z);
 Pugrid = [];
 Pvgrid = [];
 Pwgrid = [];
 Ptkegrid = [];
 Nx = length(x);
 Ny = length(y);
 N = floor(sqrt(min([Nx,Ny])/2));
 for i=1:length(z)
  uz = squeeze(nc{'um'}(1,i,:,:));
  uz = uz-mean(mean(uz));
  uz = window2d(uz,0);
  vz = squeeze(nc{'vm'}(1,i,:,:));
  vz = vz-mean(mean(vz));
  vz = window2d(vz,0);
  wz = squeeze(nc{'wm'}(1,i,:,:));
  wz = wz-mean(mean(wz));
  wz = window2d(wz,0);
  [Pu,k,l,Pua,ka,la,Pub,khun]=twodpsd(x,y,uz,N,['/home/mhoecker/tmp/u' num2str(i,"%06i")]);
  [Pv,k,l,Pva,ka,la,Pvb,khun]=twodpsd(x,y,vz,N,['/home/mhoecker/tmp/v' num2str(i,"%06i")]);
  [Pw,k,l,Pwa,ka,la,Pwb,khun]=twodpsd(x,y,wz,N,['/home/mhoecker/tmp/w' num2str(i,"%06i")]);
  Ptke = Pu+Pv+Pw;
  Ptkea = Pua+Pva+Pwa;
  Ptkeb = Pub+Pvb+Pwb;
  # Append radial spectra
  Pugrid = [Pugrid;Pub];
  Pvgrid = [Pvgrid;Pvb];
  Pwgrid = [Pwgrid;Pwb];
  Ptkegrid = [Ptkegrid;Ptkeb];
  # Save 2-D Spectra
  binmatrix(k,l,Pu,[outname "Spectra-u-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Pv,[outname "Spectra-v-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Pw,[outname "Spectra-w-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Ptke,[outname "Spectra-tke-2D-" num2str(i,"%06i") ".dat"]);
  # Save Band Averaged 2-D Spectra
  binmatrix(ka,la,Pua,[outname "Average-Spectra-u-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Pva,[outname "Average-Spectra-v-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Pwa,[outname "Average-Spectra-w-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(ka,la,Ptkea,[outname "Average-Spectra-tke-2D-" num2str(i,"%06i") ".dat"]);
  # Save 1-D spectra for gnuplot to ingest
  binarray(khun,Pub,  [outname "Average-Spectra-u-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Pvb,  [outname "Average-Spectra-v-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Pwb,  [outname "Average-Spectra-w-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khun,Ptkeb,[outname "Average-Spectra-tke-1D-" num2str(i,"%06i") ".dat"]);
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
 binmatrix(khun,z,Pugrid,[outname "Spectra-u.dat"]);
 binmatrix(khun,z,Pvgrid,[outname "Spectra-v.dat"]);
 binmatrix(khun,z,Pwgrid,[outname "Spectra-w.dat"]);
 binmatrix(khun,z,Ptkegrid,[outname "Spectra-tke.dat"]);
 ncclose(nc);
end%function
