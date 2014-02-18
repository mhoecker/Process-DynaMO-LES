function [Cx,Cy,Ax,Ay,Bx,By,xx,yy] = lie2dvec(A,B,x,y)
%
% [Cx,Cy,Ax,Ay,Bx,By] = lie2dvec(A,B,x,y)
%
% Calculates the lie bracket for a pair of two dimensional
% vector fields (A,B) on a set of points (x,y)
%
% A and B are assumed to be functions of two variables
%
% x,y are assumed to be two arrays of coordinates with the same shape
%
 if(nargin()<1)
  A = @lie2dA;
  warning("using A(x,y) = [x,y]")
 end%if
 if(nargin()<2)
  B = @lie2dB;
  warning("using B(x,y) = [y,x]")
 end%if
 if(nargin()<3)
  x = -1:.1:1;
  warning("using x = -1:.1:1")
 end%if
 if(nargin()<4)
  y = -1:.1:1;
  warning("using y = -1:.1:1")
 end%if
 if(((size(x)==size(x(:)))||(size(x')==size(x(:))))&&((size(y)==size(y(:)))||(size(y')==size(y(:)))))
  [xx,yy] = meshgrid(x,y);
 else
  xx = x;
  yy = y;
 end%if
 if(~is_function_handle(A)&&~is_function_handle(B))
  error("A and B (1st two arguments) must be function handles")
 end%if
 [Ax,Ay ]= A(xx,yy);
 [Bx,By] = B(xx,yy);
 [ABx,ABy] = A(Bx,By);
 [BAx,BAy] = B(Ax,Ay);
 Cx = ABx.-BAx;
 Cy = ABy.-BAy;
 if(nargin()==0)
  subplot(2,2,1)
  quiver(xx,yy,Ax,Ay)
  title("A(x,y)")
  axis([-1,1,-1,1])
  subplot(2,2,2)
  quiver(xx,yy,Bx,By)
  axis([-1,1,-1,1])
  title("B(x,y)")
  subplot(2,2,3)
  quiver(xx,yy,Cx,Cy)
  axis([-1,1,-1,1])
  title("[A,B](x,y)")
  subplot(2,2,4)
  pcolor(xx,yy,sqrt(Cx.^2+Cy.^2));
  shading flat
  axis([-1,1,-1,1])
  title("|[A,B](x,y)|")
  print("/home/mhoecker/tmp/lie2dvec.png","-dpng")
 end%if
end%function

function [Ax,Ay] = lie2dA(x,y)
 %R = sqrt(x.^2+y.^2);
 Ax = -x;
 Ay = y;
end%function

function [Bx,By] = lie2dB(x,y)
 %R = sqrt(x.^2+y.^2);
 Bx = -y;
 By = x;
end%function
