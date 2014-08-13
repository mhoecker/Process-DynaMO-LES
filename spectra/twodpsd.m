function [P,k,l,Pa,ka,la,Pb,khun]=twodpsd(x,y,z,N,outloc)
%function [P,k,l,Pa,ka,la,Pb,khun]=twodpsd(x,y,z,N,outloc)
%
%
 if(nargin==0)
  x = 1:2048;
  x = 2*pi*(x-.5)/length(x);
  y = x;
  [xx,yy] = meshgrid(x,y);
  z = 0*xx;
  k0 = .25+length(x)/8;
  for i=0:.1:pi/2
   phi = 2*pi*rand(2,1);
   z = z+cos(k0*cos(i)*xx+phi(1)).*cos(k0*sin(i)*yy+phi(2));
  end%for
%  phi = 2*pi*rand(2,1);
%  z = cos(k0*cos(pi/4)*xx+phi(1)).*cos(k0*sin(pi/4)*yy+phi(2));
  Nx = length(x);
  Ny = length(y);
  z = z-mean(mean(z));
  z = z./mean(mean(z.*z));
  z = z+(2^(1))*rand(Ny,Nx);
  z = z-mean(mean(z));
  z = window2d(z,4);
  %subplot(1,1,1); pcolor(xx,yy,z);  pause()
 end%if
 Nx = length(x);
 Ny = length(y);
 if(nargin<4)
  N = floor(sqrt(min([Nx,Ny])/2));
 end%if
 dx = mean(diff(x));
 dy = mean(diff(y));
 dk = 2*pi/(Nx*dx);
 dl = 2*pi/(Ny*dy);
 k = ((0:Nx-1)-floor(Nx/2))*dk;
 l = ((0:Ny-1)-floor(Ny/2))*dl;
 [k2,l2] = meshgrid(k,l);
 F = fftshift(fft2(z));
 P = abs(F.*conj(F));
 [Pa,ka,la] = twodba(P,k,l,N,N);
 [kk,ll] = meshgrid(ka,la);
 kh = sqrt(kk.^2+ll.^2);
 [Pb,N,khidx,khl,khun,khsort] = anularavg(Pa,kh);
 Pmax = max(max(P));
 Pmax = max([eps,Pmax]);
 Pamax = max(max(Pa));
 Pamax = max([eps,Pamax]);
 Pxmax = max(sum(P,2));
 Pxmax = max([eps,Pxmax]);
 Pymax = max(sum(P,1));
 Pymax = max(eps,Pymax);
 Pbmax = max(Pb);
 Pbmax = max([eps,Pbmax]);
 if(nargin>4)
  subplot(2,2,1)
  pcolor(kk,ll,log(Pa)/log(10));
  colormap(mycmap('grey',16)); colorbar;
  axis([[1,Nx]*dk,[-Ny,Ny]*dl]/2);
  caxis(log([1./(Nx*Ny),2]*Pamax)/log(10));
  shading flat
  xlabel("k")
  ylabel("l")
  subplot(2,2,2)
  loglog(sum(P,1),l,'k');
  axis([Pymax*[1/(Ny),4],[1,Ny]*dl]/2)
  xlabel("Power")
  ylabel("l")
  subplot(2,2,3)
  loglog(k,sum(P,2),'k');
  axis([[1,Nx]*dk,Pxmax*[1/Nx,4]]/2)
  xlabel("k")
  ylabel("Power")
  subplot(2,2,4)
  loglog(khun,Pb,'k');
  axis([sqrt(dk^2+dl^2)/2,sqrt((Nx*dk)^2+(Ny*dl)^2)/2,Pbmax*[1/(Nx*Ny),2]])
  xlabel("|k|")
  ylabel("Power")
  print([outloc "twodpsdtest.png"],'-dpng')
 end%if
end%function
