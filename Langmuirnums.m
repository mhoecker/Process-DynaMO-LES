function [Lat,LaSL] = Langmuirnums(Ustar,Ustokes,lambda,MLD)
% Calculate Langmuir numbers La_t and La_SL from
% McWilliams, Sullivan, and Moeng J. Fluid Mech. 1997
% and
% Harcourt and D'Asaro J. Phys. Oc. 2008
%
%
 if(nargin<2)
 Lat = NaN;
 else
  Lat = sqrt(Ustar./Ustokes);
 end%if
 if(nargin<4)
  LaSL = NaN*Lat;
 else
  LaSL = (2*lambda./(.2*MLD));
  LaSL = LaSL.*(1-exp(-.2*MLD./(2*lambda)));
  LaSL = LaSL-exp(-0.765*MLD./(2*lambda));
  LaSL = Lat./sqrt(LaSL);
 end%if
end%function
