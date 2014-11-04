function [d,dsq]=ddz(z,order)
% derivative matricies for independent variable z.
% Three point stencil.
% One-sided derivatives at boundaries.
% no assumptions about z spacing.
[val,d,dsq]=ddzinterp(z,z,order)
end
