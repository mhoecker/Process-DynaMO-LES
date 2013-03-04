function winy = hann2w(y)
 N = length(y);
 winy = linspace(1,N,N)-1;
 winy = (3-4*cos(winy*2*pi/N)+cos(winy*4*pi/N))/8;
 winy = winy.*y;
endfunction
