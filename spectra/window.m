function winy = window(y,order,NoBoost)
% Returned a windowed version of the data using a sine window
%  winy_n = y_n*sin((n-1/2)*pi/N).^order;
% Set NoBoost=1 for no variace boosting
 if(nargin==1)
  order = 1;
 end%if
 if(nargin<3)
  NoBoost=0;
 end%if
 N = length(y);
 ysq = var(y,1);
 winy = linspace(1,N,N)-.5;
 winy = sin(winy*pi/N).^order;
 plot(winy)
 winy = winy.*y;
 wsq = var(winy,1);
 if(NoBoost==0)
  if(wsq>0)
   winy = winy*sqrt(ysq/wsq);
  end%if
 end%if
end%function
