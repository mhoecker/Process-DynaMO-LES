function [u]=uofy(u10,y)
% Calculate wind speed at height y given u at 10m
% Assumes the law of the wall and measurenments are in the log layer
% Uses constant drag coefficient from Large & Pond 1981
%

% VonKarman Constant
 kappa = 0.4;
%
 u = u10.*(1-sqrt(Cd(u10)).*log(10./y)/kappa);
%
end%function

function CDN = Cd(u10)
% Drag Coefficient from Large and Pond 1981
% only valid for 4m/s < u10
% CDN = 1.2e-3 4m/s<u10<11m/s;
% CDN = (0.49+0.065*u10)*1e-3 u10>11m/s;
CDN =(1e-3)*(1.2.*(u10<=11)+(0.49+0.065*u10).*(u10>11));
end%function
