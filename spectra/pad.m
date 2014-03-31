function pady = pad(y,M)
 N = length(y);
 pady = [y,zeros(1,M-N)];
endfunction
