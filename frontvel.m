function [u,du] = frontvel(t,x)
%function [u,err,A,Asqinv] = frontvel(t,x,y,z)
%
% from a list of observations
% t = time
% x = x-coordinate
% y = y-coordinate
% z = z-coordinate [optional]
% returns the best estimate for the velocity of a front
% assumes the front is locally straight relative to the observation array
%
%
%
M = length(t)*(length(t)-1)/2;
dimgood = find(var(x,0,2)>0);
N = length(dimgood);
dt = zeros(1,M);
dx = zeros(N,M);
k = 0;
for i=1:length(x)
 for j=i+1:length(x)
  k = k+1;
  dt(k) = t(i)-t(j);
  dx(:,k) = x(dimgood,i)-x(dimgood,j);
 end
end
Asq = dx*dx';
Asqinv = inv(Asq);
uip = Asqinv*dx*dt';
err = dt-uip'*dx;
sige = sum(err.*err)/(M-N-1);
duip = sqrt(sige*diag(Asqinv)/M);
uipmag = sqrt(sum(uip.*uip));
u = uip'/uipmag^2;
du = sum(2*abs(duip.*uip))/uipmag^3;
end
