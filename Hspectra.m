function [Ptkegrid,khun,z] = Hspectra(rstnc,outname,term)
 if(nargin()<3)
  term = 'png';
 end%if
 waithandle = waitbar(0,["loading file " rstnc]);
 useoctplot = 1;
 nc = netcdf(rstnc,'r');
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
 clear x;
 clear y;
 k = ((0:Nx-1)-floor(Nx/2))*dk;
 l = ((0:Ny-1)-floor(Ny/2))*dl;
 [kk,ll] = meshgrid(k,l);
 lz = find(l==0);
 kz = find(k==0);
 waitbar(0,waithandle,"Calculating horizontal wave number");
 kh = sqrt(kk.^2+ll.^2);
 dkh = sqrt(dk^2+dk^2);
 khsmooth = 0:dkh:max(kh);
 waitbar(0,waithandle,"Finding unique horizontal wave number");
 [khlist,khsort] = sort(kh(:));
 khun = unique(khlist)';
 waitbar(0,waithandle,"Counting and finding duplicate horizontal wave numbers");
 N = zeros(size(khun));
 khidx = {};
 Nun = length(khun);
 Nkl = length(khlist);
 i=1;
 khidx0 = [];
 for j=1:Nkl
  if(khlist(j)>khun(i))
   khidx = {khidx{:},khidx0};
   N(i) = length(khidx{i});
   if(mod(i,Nx)==0)
    waitbar(0+i*0.5/Nun,waithandle,["Found " num2str(N(i)) " duplicates of wave number kh=" num2str(khun(i))]);
   end%if
   khidx0 = [];
   i=i+1;
  end%if
   khidx0 = [khidx0,j];
 end%for
 khidx = {khidx{:},khidx0};
 N(i) = length(khidx{i});
 waitbar(0,waithandle,"Calculating horizontal spectra at each depth")
 Ptkegrid = [];
 Pwgrid = [];
 for i=1:Nz
  waitbar(0.5+i*0.5/Nz,waithandle,["Calculating spectra for z=" num2str(z(i))]);
  uz = squeeze(nc{'um'}(1,i,:,:));
  Fuz = fft2(uz);
  clear uz;
  vz = squeeze(nc{'vm'}(1,i,:,:));
  Fvz = fft2(vz);
  clear vz;
  wz = squeeze(nc{'wm'}(1,i,:,:));
  Fwz = fft2(wz);
  clear wz;
  Ptke = fftshift(abs(Fuz.*conj(Fuz)+Fvz.*conj(Fvz)+Fwz.*conj(Fwz)));
  Pw = fftshift(abs(Fwz.*conj(Fwz)));
  # Save 2-D Spectra
  binmatrix(k,l,Ptke,[outname "Spectra-tke-2D-" num2str(i,"%06i") ".dat"]);
  binmatrix(k,l,Pw,[outname "Spectra-w-2D-" num2str(i,"%06i") ".dat"]);
  # Calculate Raw and smoothed 1-D Spectra
  Ptkeb = anularavg(Ptke(khsort),khlist,khun,khidx,N,1);
  Ptkegrid = [Ptkegrid;Ptkeb];
  Ptkesb = csqfil(Ptke(khsort),khlist,khsmooth,3*dkh)
  Ptkesgrid = [Ptkesgrid;Ptkesb];
  Pwb   = anularavg(Pw(khsort)  ,khlist,khun,khidx,N,1);
  Pwgrid = [Pwgrid;Pwb];
  Pwsb = csqfil(Pw(khsort),khlist,khsmooth,3*dkh)
  Pwsgrid = [Pwsgrid;Pwsb];
  # Save 1-D spectra for gnuplot to ingest
  binarray(khun,Ptkeb,[outname "Spectra-tke-1D-" num2str(i,"%06i") ".dat"]);
  binarray(khun,Pwb,  [outname "Spectra-w-1D-"   num2str(i,"%06i") ".dat"]);
  binarray(khsmooth,Ptkesb,[outname "Spectra-Smooth-tke-1D-" num2str(i,"%06i") ".dat"]);
  binarray(khsmooth,Pwsb,  [outname "Spectra-Smooth-w-1D-"   num2str(i,"%06i") ".dat"]);
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
 close(waithandle)
% figure(2)
% [khkh,zz] = meshgrid(khun,z);
% pcolor(log(khkh)/log(10),zz,log(Ptkegrid)/log(10)); shading flat
% xlabel("Horizontal Wavenumber (rad/m)");
% ylabel("Depth (m)");
% title("Horizontal Spectra")
% axis([log([min([dk,dl]),max(khun)])/log(10),min(z),max(z)])
% caxis(log(max(max(Ptkegrid))*[.5/(Nx*Ny)^2,2])/log(10))
% colorbar();
% print([outname "Hspectra-all.png"],"-dpng")
 binmatrix(khun,z,Ptkegrid,[outname "Spectra-tke.dat"]);
 binmatrix(khun,z,Pwgrid,[outname "Spectra-w.dat"]);
 binmatrix(khsmooth,z,Ptkesgrid,[outname "Spectra-Smooth-tke.dat"]);
 binmatrix(khsmooth,z,Pwsgrid,[outname "Spectra-Smooth-tke.dat"]);
 ncclose(nc);
end%function

function [Pb,N,khidx,khl,khun,khsort]= anularavg(P,kh,khun,khidx,N,nosort)
 if(nargin==6)
  khl=kh;
  Pl=P;
 else
  # kh needs to be sorted since unique sorts
  [khl,khsort] = sort(kh(:));
  Pl = P(khsort);
 end%if
 # Find unique k magnitudes
 if(nargin()<3)
  khun = unique(khl)';
 end%if
 # Calculate the indecies and number of points
 # with a given unique wavenumber
 if(nargin()<4)
  N = zeros(size(khun));
  khidx = {};
  for i=1:length(khun)
   khidx = {khidx{:},find(kh==khun(i))};
   N(i) = length(khidx{i});
  end%for
 end%if
 # Calculate the number of points
 # with a given unique wavenumber
 if(nargin()==4)
  N = zeros(size(khun));
  for i=1:length(khun)
   N(i) = length(khidx{i});
  end%for
 end%if
 Pb = zeros(size(khun));
  for j=1:length(khun)
   Pb(j) = 2*pi*khun(j)*sum(Pl(khidx{j}))/N(j);
  end%for
endfunction
