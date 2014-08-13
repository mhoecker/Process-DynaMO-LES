function ydiff = firstdiff(y)
% function ydiff = firstdiff(y)
% Periodic First difference filter
% ydiff(1) = (y(N)-y(1))/(N-1)
 N = length(y);
 ydiff = zeros(size(y));
 for j=2:N
  ydiff(j) = y(j)-y(j-1);
 endfor
 ydiff(1) = 0;
 ydiff(1) = (y(N)-y(1))/(N-1);
endfunction
