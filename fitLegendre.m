function c = fitLegendre(x,y,order)
 z = (2*x-(min(x)+max(x)))/(max(x)-min(x));
 c = zeros(1,order);
 for i=0:order-1
  l = legendre(i,z)(1,:);
  c(i+1) = trapz(z,y.*l)./trapz(z,l.*l);
 end%for
end%function
