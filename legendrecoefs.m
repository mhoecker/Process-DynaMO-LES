function LegPolyCoef = legendrecoefs(order)
 LegPolyCoef = zeros(order,order);
 % P_0(z) = 1
 LegPolyCoef(1,1) = +1.0;
 % P_2(z) = z
 LegPolyCoef(2,2) = +1.0;
 % Generate the Legendre Polynomial Coefficients for order >1
 for l=1:order-2
  for m=1:l+2
   % (n+1) P_{n+1}(z) = (2*n+1) * z * P_{n}(z) - n * P_{n-1}(z)
   % n = l-1
   if(m>1)
    LegPolyCoef(l+2,m) = +(2*l+1) * LegPolyCoef(l+1,m-1);
   end%if
   LegPolyCoef(l+2,m) = LegPolyCoef(l+2,m)-l*LegPolyCoef(l,m);
   LegPolyCoef(l+2,m) = LegPolyCoef(l+2,m)/(l+1);
  end%for
 end%for
end%function
