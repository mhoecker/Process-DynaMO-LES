function [d,dsq]=ddz(z,order)
 % derivative matricies for independent variable z.
 % Three point stencil.
 % One-sided derivatives at boundaries.
 % no assumptions about z spacing.
 % example
 % z = 1:10
 % y = z.*z
 % [der,dsq] = ddz(z,3)
 % dydz = der*y'
 % dsqydz = dsq*y'
 if(nargin<2)
  order=3;
 end%if
 [val,d,dsq]=ddzinterp(z,z,order);
end
