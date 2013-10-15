function [Ri,Jb,rho0,alpha,g,sssa,cp,nu,kappaT] = surfaceRi(stress,Jh,sst,sss,lat,lon)
 % Convert surface stress and heat flux into a richardson number
 %
 % Ri = Jb / (stress/nu rho)^2
 %
 if(nargin()<5)
  lat = 0;
 end%if
 if(nargin()<6)
  lon = 80.5;
 end%if
 nu = 1.05e-6; %
 kappaT = 1.46e-7; %
 % from
 % Tables of Physical & Chemical Constants (16th edition 1995).
 % 2.7.9 Physical properties of sea water.
 % Kaye & Laby Online. Version 1.0 (2005) www.kayelaby.npl.co.uk
 [Jb,rho0,sssa,cp,alpha,g,kappaT] = JhtoJb(Jh,sst,sss,lat,lon);
 Ri = (Jb./kappaT)./((stress./(nu.*rho0)).^2);
end%function
