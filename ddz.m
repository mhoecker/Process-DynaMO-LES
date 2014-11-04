function [d,dsq]=ddz(z,order)
 % derivative matricies for independent variable z.
 % Three point stencil.
 % One-sided derivatives at boundaries.
 % no assumptions about z spacing.
 if(nargin<2)
  order=3;
 end%if
 [val,d,dsq]=ddzinterp(z,z,3);
end
