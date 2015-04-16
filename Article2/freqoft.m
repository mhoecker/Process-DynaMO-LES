function [f,f1,f0] = freqoft(t)
 N = length(t);
 f0 = ((N+1)/N)/abs(t(N)-t(1));
 f = ((0:N-1)-floor(N/2))*f0;
 f1 = (1:ceil(N/2)-1)*f0;
end%function
