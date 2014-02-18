function [u,w,eta] = waveslice(x,z,l,h,D)
% makes a vertical slice of a gravity wave train
% Surface tension is not included
% x = 1-dimensional array of x values
% z = 1 dimensional array of z values
% l = wave length (l=1 if not given)
% h = wave height (h=l/10 if not given)
% D = water depth (D = infty if not given)
 if(nargin()<3)
  l = 1;
 end%if
 if(nargin()<4)
  h = l/30;
 end%if
 findgsw;
 omega = sqrt(2*pi*gsw_grav(0)/l);
 [xx,zz] = meshgrid(x,z);
 eta = zeros(size(x));
 u = zeros(size(xx));
 w = zeros(size(zz));
 for i=1:length(l)
  if(nargin()<5)
   ui = h*omega*exp(2*pi*zz/l).*sin(2*pi*xx/l);
   wi = h*omega*exp(2*pi*zz/l).*cos(2*pi*xx/l);
   dx = +wi/omega;
   dz = +ui/omega;
  else
   ui = h*omega*sin(2*pi*xx/l)*cosh(2*pi*(zz+D)/l)/sinh(2*pi*zz/l);
   wi = h*omega*cos(2*pi*xx/l)*sinh(2*pi*(zz+D)/l)/sinh(2*pi*zz/l);
   dx = +wi/omega;
   dz = -ui/omega
  end%if
   u = u+ui;
   w = w+wi;
   eta = eta-dz(1,:);
 end%for
 quiver(xx(:)-dx(:),zz(:)-dz(:),u(:),w(:))
 hold on
 plot(x-dx(1,:),eta)
 hold off
end%function
