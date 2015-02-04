function [Pi,f,yf,Fi]=interpPSD(y,t,order)
%
%
%
 if(nargin<2)
  t = 1:length(y);
 end%if
 if(nargin<3)
  order=3;
 end%if
 dt = mean(diff(t));
 N = length(t);
 Period = N*mean(dt);
 df = 1.0/(Period);
 f = ((1:N)-1-floor(N/2))*df;
 idxgood = find(~isnan(y));
 if(length(idxgood)<N)
  ygood = y(idxgood);
  ymax = max(ygood);
  ymin = min(ygood);
  Ngood = length(idxgood);
  Nbad = N-Ngood;
  gaplength = max(5,1+Nbad);
  gaplength = dt*gaplength;
  tgood = t(idxgood);
  val = ddzinterp(tgood,t,order+1);
  yi = (val*ygood')';
  [yhigh,idxhigh]=find(yi>ymax);
  yi(idxhigh) = ymax;
  [ylow,idxlow]=find(yi<ymin);
  yi(idxlow) = ymin;
  yf = yi;%harmfill(ygood,tgood,t,horder,gaplength);
 else
  yf=y;
 end%if
 Fi = fftshift(fft(window(yf,order)))/N;
 Pi = abs(Fi.*conj(Fi))/df;
end%function

