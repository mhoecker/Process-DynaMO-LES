function triy = triangle(y)
 N = length(y);
 triy = linspace(1,N,N)-1;
 triy = 1-abs(.5*N-triy)/(.5*N);
 triy = triy.*y;
endfunction
