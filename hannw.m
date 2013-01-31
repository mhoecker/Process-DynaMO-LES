function winy = hannw(y)
 N = length(y);
 winy = linspace(1,N,N)-1;
 winy = .5-.5*cos(winy*2*pi/N);
 winy = winy.*y;
endfunction
