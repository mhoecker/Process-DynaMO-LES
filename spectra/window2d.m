function winz = window2d(z,order,NoBoost)
% Returned a windowed version of the data using a sine window
%  winy_n = y_n*sin((n-1/2)*pi/N).^order;
% Set NoBoost=1 for no variace boosting
 if(nargin==1)
  order = 1;
 end%if
 if(nargin<3)
  NoBoost=0;
 end%if
 Nx = length(z(:,1));
 Ny = length(z(1,:));
 zsq = sum(sum(z.*z));
 winx = linspace(1,Nx,Nx)-.5;
 winx = sin(winx*pi/Nx).^order;
 winy = linspace(1,Ny,Ny)-.5;
 winy = sin(winy*pi/Ny).^order;
 [wx,wy] = meshgrid(winx,winy);
 winz = (wx.*wy)';
 winz = winz.*z;
 wsq = sum(sum(winz.*winz));
 if(NoBoost==0)
  if(wsq>0)
   winz = winz*sqrt(zsq/wsq);
  end%if
 end%if
end%function
