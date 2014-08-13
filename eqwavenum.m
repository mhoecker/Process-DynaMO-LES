function [ks] = eqwavenum(w,c,j)
#function [ks] = eqwavenum(w,c,j)
#
# returns a cell array of real equatorial wavenembers
# if k is imiginary a NaN is returned
# every value of j generates two additional lists of
# wavenumbers.
# if j=0 Kelvin and Yanai waves are generated
# if j>0 Rossby and Poincare waves are generated
#
# Inputs:
# angular frequency w (default 2 pi / day)
# baroclinic wave speed c (default 20 2.4 m/s)
# meridional modes j (default modes 0 and 1)
 if(nargin()<1)
  findgsw;
  w = 2*pi/(3600*24);
 end%if
 if(nargin()<2)
  c = 2.4; # default to 2.4 m/s
 end%if
 if(nargin()<3)
  j = [0,1]; # Default to Kelvin and Yanai waves
 end%if
 ks = {};
 b = 2.3e-11; #Equatorial beta
 for i=1:length(j)
  if(j(i)>0)
   ko = -b./(2.*w);
   kr = (b./w -2*w/c).^2-8*j(i)*b/c;
   kr(find(kr<0)) = NaN; # don't return imaginary wave numbers
   kr = (1/2)*sqrt(kr);
   kp = ko+kr; # positive root
   km = ko-kr; # negative root
   ks = {ks{:},kp,km};
  elseif(j(i)==0)
   kk = w./c; # kelvin wave
   kr = -b./w +w/c; #Yanai wave
   ks = {ks{:},kk,kr};
  end%if
 end%for
end%function
