function [rad] = synthradflux(t,Qrange)
# assumes t is in day
if(nargin<2)
Qrange=[1,0]-1/pi;
Qrange=Qrange/(1-1/pi);
endif
rad = (cos(2*pi*(t-.25))+abs(cos(2*pi*(t-.25))))/2;
rad = rad*(max(Qrange)-min(Qrange))+min(Qrange);
#rad = rad.*(1-rand(size(t))*.2);
#rad = rad.*(1-exp(-t/pi));
plot(t,rad)
endfunction
