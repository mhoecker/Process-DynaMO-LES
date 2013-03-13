function [u,err,A,Asqinv] = frontvel(t,x,y,z)
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
dt = zeros(1,M);
dx = zeros(1,M);
if(nargin>2)
 dy = zeros(1,M);
 if(nargin>3)
  dy = zeros(1,M);
 end
end	
k = 0;
for i=1:length(x)
 for j=i+1:length(x)
  k = k+1;
  dt(k) = t(i)-t(j);
  dx(k) = x(i)-x(j);
  if(nargin>2)
   dy(k) = y(i)-y(j);
   if(nargin>3)
    dz(k) = z(i)-z(j);
   end
  end
 end
end
A=[dx];
if(nargin>2)
 A = [A;dy];
 if(nargin>3)
  A = [A;dz];
 end
end	
Asq = A*A';
Asqinv = inv(Asq);
u = Asqinv*A*dt';
u = u'/sum(u.*u);
err = dt-u*A/(u*u');
end
