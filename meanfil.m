function [y] = meanfil(x,t,s,T)
% [y,fil] = csqfil(x,t,s,T)
% Filter the time series x with a weighting function
%
% weight(t,s) = 1 for |s-t| < T/2
%
 if(nargin<4)
  T = 3*mean(diff(s));
 end%if
 N = length(t);
 M = length(s);
% ensure there is nothing to alias into the new sampling
 y = zeros(1,M);
 for i=1:M
  w = zeros(1,N);
  for j=1:N
   if((abs(s(i)-t(j))<T/2)*(1-isnan(x(j))))
    w(j) = meanwt(s(i)-t(j),T);
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

function w = meanwt(dt,T)
 w=(1+sign(1-(2*dt/T).^2));
end%function
