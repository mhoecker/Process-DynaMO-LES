function [c,yfit] = fitLegendre(x,y,order)
 z = (2*x-(min(x)+max(x)))/(max(x)-min(x));
 c = zeros(1,order);
 yfit = zeros(size(z));
 for i=0:order-1
  l = legendre(i,z)(1,:);
  c(i+1) = trapz(z,y.*l)./trapz(z,l.*l);
  yfit = yfit+c(i+1)*l;
 end%for
end%function
