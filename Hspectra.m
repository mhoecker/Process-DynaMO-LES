function [Pzgrid,khun,z] = Hspectra(rstnc,outname,term)
 if(nargin()<3)
  term = 'png';
 end%if
 nc = netcdf(rstnc,'r');
 u = nc{'um'}(:);
 v = nc{'vm'}(:);
 w = nc{'wm'}(:);
 x = nc{'xu'}(:);
 y = nc{'yv'}(:);
 z = nc{'zu'}(:);
 z = z-max(z);
 Nx = length(x);
 Ny = length(y);
 Nz = length(z);
 dx = mean(diff(x));
 dy = mean(diff(y));
 dk = 2*pi/(Nx*dx);
 dl = 2*pi/(Ny*dy);
 k = ((0:Nx-1)-floor(Nx/2))*dk;
 l = ((0:Ny-1)-floor(Ny/2))*dl;
 [kk,ll] = meshgrid(k,l);
 lz = find(l==0);
 kz = find(k==0);
 kh = sqrt(kk.^2+ll.^2);
 [khlist,khsort] = sort(kh(:));
 khun = unique(khlist)';
 N = zeros(size(khun));
 khidx = {};
 for i=1:length(khun)
  khidx = {khidx{:},find(khlist==khun(i))};
  N(i) = length(khidx);
 end%for
 Pzgrid = [];
 figure(1)
 for i=1:Nz
  uz = squeeze(u(1,i,:,:));
  Fuz = fft2(uz);
  vz = squeeze(v(1,i,:,:));
  Fvz = fft2(vz);
  wz = squeeze(w(1,i,:,:));
  Fwz = fft2(wz);
  Pz = fftshift(abs(Fuz.*conj(Fuz)+Fvz.*conj(Fvz)+Fwz.*conj(Fwz)));
  binmatrix(k,l,Pz,[outname "Hspectra-" num2str(i,"%06i") ".dat"]);
  Pzl = Pz(khsort);
  Pzb = zeros(size(khun));
  for j=1:length(khun)
   Pzb(j) = 2*pi*khun(j)*sum(Pzl(khidx{j}))/N(j);
  end%for
  binarray(khun,Pzb,[outname "Hspectra-1D-" num2str(i,"%06i") ".dat"]);
  subplot(1,2,1)
  pcolor(kk,ll,log(Pz)/log(10)); shading flat
  xlabel("k Zonal Wavenumber (rad/m)");
  ylabel("l Meridional Wavenumber (rad/m)");
  axis([0,Nx*dk/2,-Ny*dl/2,Ny*dl/2])
  caxis(log(max(Pzb(2:end))*[.5/(Nx*Ny)^2,2])/log(10))
  subplot(1,2,2)
  loglog(khun(2:end),Pzb(2:end),".",khun(2:end),max(Pzb(2:end))*(khun(2:end)./min([dk,dl])).^(-5/3),"k;k^{-5/3};")
  axis([min([dk,dl]),max(khun),max(Pzb(2:end))*[.5/(Nx*Ny)^2,2]])
  title(["z=" num2str(z(i)) "m"])
  xlabel("Horizontal Wavenumber (rad/m)")
  ylabel("Spectral Energy Density (m^2/s^2/rad/m)")
  caxis(log(max(Pzb(2:end))*[.5/(Nx*Ny)^2,2])/log(10))
  colorbar();
  print([outname "Hspectra-" num2str(i,"%06i") ".png"],"-dpng")
  Pzgrid = [Pzgrid;Pzb];
 end%for
% figure(2)
% [khkh,zz] = meshgrid(khun,z);
% pcolor(log(khkh)/log(10),zz,log(Pzgrid)/log(10)); shading flat
% xlabel("Horizontal Wavenumber (rad/m)");
% ylabel("Depth (m)");
% title("Horizontal Spectra")
% axis([log([min([dk,dl]),max(khun)])/log(10),min(z),max(z)])
% caxis(log(max(max(Pzgrid))*[.5/(Nx*Ny)^2,2])/log(10))
% colorbar();
% print([outname "Hspectra-all.png"],"-dpng")
 binmatrix(khun,z,Pzgrid,[outname "Hspectra-all.dat"]);
 ncclose(nc);
end%function
