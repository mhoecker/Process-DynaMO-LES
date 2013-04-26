function [y] = csqfil(x,t,s,T)
% [y,fil] = csqfil(x,t,T)
% Filter the time series x with a weighting function
%
% weight(t,s) = (1+cos(2*pi*(s-t)/T)) for |s-t| < T/2
% if T is not given T = 4*mean(diff(s))
%
N = length(t);
M = length(s);
if(nargin<4)
 T = 4*mean(diff(s));
end%if
y = zeros(1,M);
for i=1:M
 w = zeros(1,N);
 for j=1:N
  if((abs(s(i)-t(j))<T/2)*(1-isnan(x(j))))
   w(j) = (1+cos(2*pi*(s(i)-t(j))/T));
   y(i) = y(i)+x(j)*w(j);
  end%if
 end%for
  wsum = sum(w);
  if(wsum==0)
   y(i) = NaN;
  else
   y(i) = y(i)/wsum;
  end%if
end%for
end%function
