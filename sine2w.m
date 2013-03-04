function winy = sine2w(y)
 N = length(y);
 winy = linspace(1,N,N)-1;
 winy = .75*sin(winy*pi/N)-.25*sin(winy*3*pi/N);
 winy = winy.*y;
endfunction
