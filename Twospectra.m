function [Pzgrid,khun,z] = Twospectra(ncfile,varname,xname,yname,zname,outname,term)
 if(nargin()<7)
  term = 'png';
 end%if
 nc = netcdf(ncfile,'r');
 u = nc{varname}(:);
 uunits = nc{varname}.units;
 x = nc{xname}(:);
 xunits = nc{xname}.units;
 y = nc{yname}(:);
 yunits = nc{yname}.units;
 z = nc{zname}(:);
 zunits = nc{zname}.units;
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
% for i=1:3
  uz = squeeze(u(i,1,:,:));
  Fuz = fft2(uz);
  Pz = fftshift(real(Fuz.*conj(Fuz)));
%  binmatrix(k,l,Pz,[outname varname "-" num2str(i,"%06i") ".dat"]);
  Pzl = Pz(khsort);
  Pzb = zeros(size(khun));
  for j=1:length(khun)
   Pzb(j) = 2*pi*khun(j)*sum(Pzl(khidx{j}))/N(j);
  end%for
  if 1==0
   subplot(1,2,1)
   pcolor(kk,ll,log(Pz)/log(10)); shading flat
   xlabel([xname " Wavenumber (rad/" xunits ")"]);
   ylabel([yname " Wavenumber (rad/" yunits ")"]);
   axis([0,Nx*dk/2,-Ny*dl/2,Ny*dl/2])
   crange = log(max(Pzb(2:end))*[.5/(Nx*Ny)^2,2]/max(khun))/log(10);
   caxis(crange)
   subplot(1,2,2)
   loglog(khun(2:end),Pzb(2:end),".",khun(2:end),max(Pzb(2:end))*(khun(2:end)./min([dk,dl])).^(-5/3),"k;k^{-5/3};")
   axis([min([dk,dl]),max(khun),max(Pzb(2:end))*[.5/(Nx*Ny)^2,2]])
   title([zname"=" num2str(z(i)) "(" zunits ")"])
   xlabel(["Horizontal Wavenumber (rad/" xunits ")"])
   ylabel(["Spectral Energy Density ([" uunits "]^2/rad/" xunits ")"])
   caxis(crange)
   colorbar();
   print([outname varname "-" num2str(i,"%06i") ".png"],"-dpng")
  end%if
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
 save([outname varname "all.mat"],"Pzgrid","khun","z");
 binmatrix(khun,z,Pzgrid,[outname varname "-all.dat"]);
 ncclose(nc);
end%function
