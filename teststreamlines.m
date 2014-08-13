function x = teststreamline(x0,N,field)
% function x = teststreamline(x0,N,field)
%
% x is the filedline
%
% x0 is the start of the streamline
% N is the number of itterations
% field is a function handle
% [A,dA] = field(x);
% field takes one argument x
% and returns two matricies A
% one vector and one matrix dA
 if(nargin<1)
 x0 = [0;0;2*rand(1,1)-1]
 end%if
% number of jumps
 if(nargin<2)
  N = 8;
 end%if
% vectorfield
 if(nargin<3)
  field=@vfield;
 end%if
% number of dimensions
 M = length(x0);
%
 x = x0;
 for i=1:N
  [vi,dvi] = vfield(x(:,i));
  [vinorm,vbydvi] = norms(vi,dvi);
  if(vinorm==0)
   dx =[0;0;0];
  elseif(vbydvi==0)
   dx =vi/vinorm;
  else
   dx =vinorm*vi/vbydvi;
  end%if
  x = [x,x(:,i)+2*pi*dx/N];
 end%for
 xyzrange = [-1,1,-1,1,-1,1];
 figure(1); subplot(1,1,1)
 plot(x(1,:),x(2,:),'-;;'); axis(xyzrange)
 v = [];
 for i=1:length(x(1,:))
  xi = x(:,i);
  [vi,dvi,vbydvi] = vfield(xi);
  v = [v,vi];
 end%for
 figure(2); subplot(1,1,1)
 quiver(x(1,:),x(2,:),v(2,:),-v(1,:)); axis(xyzrange)
 sum(diff(x'))
end%function


function [A,dA] = vfield(x)
 %
 % u =
 % cos(pi*z)*sin(pi*z)^2
 % sin(pi*z)*cos(pi*z)^2
 % 0
 %
 % omega =
 % pi*sin(pi*z)^3-2*pi*sin(pi*z)*cos(pi*z)^2
 % pi*cos(pi*z)^3-2*pi*cos(pi*z)*sin(pi*z)^2
 % 0
 %
 A = [];
 A = [A;2*cos(pi*x(3))-3*cos(pi*x(3)).^3];
 A = [A;sin(pi*x(3)).*(3*cos(pi*x(3)).^2-1)];
 A = [A;0];
 A = A*pi/2;
 % dA = [dA(1)/dx(1), dA(1)/dx(2), dA(1)/dx(3);
 %       dA(2)/dx(1), dA(2)/dx(2), dA(2)/dx(3);
 %       dA(3)/dx(1), dA(3)/dx(2), dA(3)/dx(3);]
 dA = [];
 dA = [dA; [0, 0, 0]];
 dA = [dA; [0, 0, 0]];
 dA = [dA; [(9*cos(pi*x(3))^2-2)*sin(pi*x(3)),9*cos(pi*x(3))^3-7*cos(pi*x(3)),0]];
 dA = pi*pi*dA/2;
end%function

function [Anorm,normAbydA] = norms(A,dA)
 Anorm = sqrt(sum(A.^2));
 normAbydA = sqrt(sum((dA*A).^2));
end%function
