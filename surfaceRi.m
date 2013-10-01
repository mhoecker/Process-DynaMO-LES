function [Ri,alpha,g,nu,kappaT] = surfaceRi(stress,Jh,sst,sss)
 % Convert surface stress and heat flux into a richardson number
 %
 % Ri = g * alpha * ( Jh / kappaT ) * / (stress/nu rho)^2
 %
 findgsw
 nu = 1.05e-6; %
 kappaT = 1.46e-7; %
 % from
 % Tables of Physical & Chemical Constants (16th edition 1995).
 % 2.7.9 Physical properties of sea water.
 % Kaye & Laby Online. Version 1.0 (2005) www.kayelaby.npl.co.uk
 sssa = gsw_SA_from_SP(sss,80.5+0*sss,0*sss,0*sss);
 alpha = gsw_alpha(sst,sssa,0*sst );
 rho0 = gsw_rho(sst,sssa,0*sst);
 g = grav = gsw_grav(0);
 Ri = -(nu.^2).*g.*rho0.*alpha.*Jh./(kappaT.*stress.^2);
end%function
