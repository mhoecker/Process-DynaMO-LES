function winy = sinew(y)
 N = length(y);
 ysq = y*y';
 winy = linspace(1,N,N)-1;
 winy = sin(winy*pi/N);
 winy = winy.*y;
 wsq = winy*winy';
 winy = winy*sqrt(ysq/wsq);
endfunction
