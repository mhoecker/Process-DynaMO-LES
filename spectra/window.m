function winy = window(y,order)
% Returned a windowed version of the data using a sine window
%  winy_n = y_n*sin((n-1/2)*pi/N).^order;

 if(nargin==1)
  order = 1;
 end%if
 N = length(y);
 ysq = y*y';
 winy = linspace(1,N,N)-.5;
 winy = sin(winy*pi/N).^order;
 winy = winy.*y;
 wsq = winy*winy';
 winy = winy*sqrt(ysq/wsq);
end%function
