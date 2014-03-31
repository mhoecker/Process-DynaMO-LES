function Y = slowdft(y,f,t)
N = length(y);
M = length(f);
Y = zeros(size(f));
 for i=1:M
  for j = 1:N
   Y(i) = Y(i) + y(j)*exp(-I*2*pi*f(i)*t(j));
  endfor
 endfor
endfunction
