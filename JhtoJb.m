function [Jb,rho0,sssa,cp,alpha,g,kappaT] = JhtoJb(Jh,sst,sss,lat,lon)
 % Jb = - g * Jh * alpha / rho0 * c_p
 if(nargin()<4)
  lat = 0;
 end%if
 if(nargin()<5)
  lon = 80.5;
 end%if
 findgsw
 % measurements at surface P==0
 P = 0;
 % Other constants
 kappaT = 1.46e-7; %
 % from
 % Tables of Physical & Chemical Constants (16th edition 1995).
 % 2.7.9 Physical properties of sea water.
 % Kaye & Laby Online. Version 1.0 (2005) www.kayelaby.npl.co.uk
 %
 % Conver psu tp absolute salinity
 sssa = gsw_SA_from_SP(sss,P,lon,lat);
 % Density
 rho0 = gsw_rho(sst,sssa,P);
 % Thermal expansion
 alpha = gsw_alpha(sst,sssa,P);
 % heat capacity
 cp = gsw_cp_t_exact(sssa,sst,P);
 %
 g = grav = gsw_grav(lat);
 #
 Jb = Jh.*(-g.*alpha)./(cp.*rho0);
end%function
