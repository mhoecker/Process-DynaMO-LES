function [y,fil] = csqfil(x,t,T)
N = length(t);
fil = zeros(N,N);
for i=1:N
 for j=1:N
  if(abs(t(i)-t(j))<T/2)
   fil(i,j) = (1+cos(2*pi*(t(i)-t(j))/T))^2;
  end%if
 end%for
  fil(i,:) = fil(i,:)/sum(fil(i,:));
end%for
y = (x*fil);
end%function
