function z,Z,f = gauss(t,a,f)
 if(nargin<3)
  N=length(t);
  T = (max(t)-min(t))*(N+1.)/N
  f = linspace(1,N,N)-floor((N+1)/2);
  f = f/T
 endif
 z = exp(-(a.*t).^2);
 Z = sqrt(pi/(a.*a))*exp(-(pi*f./a).^2);
end
