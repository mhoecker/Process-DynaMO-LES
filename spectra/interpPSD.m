function [Pi,f,yi,Fi]=interpPSD(y,t,order)
%
%
%
 if(nargin<2)
  t = 1:length(y);
 end%if
 if(nargin<3)
  order=3;
 end%if
 N = length(t);
 Period = N*mean(diff(t));
 df = 1.0/(Period);
 f = ((1:N)-1-floor(N/2))*df;
 idxgood = find(~isnan(y));
 ygood = y(idxgood);
 ymax = max(ygood);
 ymin = min(ygood);
 Ngood = length(idxgood);
 tgood = t(idxgood);
 val = ddzinterp(tgood,t,order);
 yi = (val*ygood')';
 [yhigh,idxhigh]=find(yi>ymax);
 yi(idxhigh) = ymax;
 [ylow,idxlow]=find(yi<ymin);
 yi(idxlow) = ymin;
 Fi = fftshift(fft(window(yi,order-1)))/N;
 Pi = abs(Fi.*conj(Fi))/df;
end%function

