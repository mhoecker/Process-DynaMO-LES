function [y,x] = expandlegendre(Coef,z)
 modes = length(Coef);
 kdim = length(z);
 % Get a matrix of Legendre Polynomia Coefficients
 LegPolyCoef = legendrecoefs(modes);
 % Assumes x=-1 -> min(z) and x=1 -> max(z)
 x = zeros(1,kdim);
 for i=1:kdim
  x(i) = -1+2*(z(i)-min(z))/(max(z)-min(z));
 end%for
 % Fill in y(x)
 y = zeros(1,kdim);
 % Sum over legendre ploynomials
 for l=1:modes
  for m=1:l
   y = y + Coef(l).*LegPolyCoef(l,m).*(x.^(m-1));
  end%for
 end%for
 LegPolyCoef
end%function
