function [u10,ustar,tau]=uten(u,y)
% Calculate wind speed at 10m from a measurement at a different height
% Assumes the law of the wall and measurenments are in the log layer
% Uses constant drag coefficient from Large & Pond 1981
%

% VonKarman Constant
 kappa = 0.4;
%
 uguess = ones(size(u))*11;
 u10 = zeros(size(u));
 du = max((uguess-u10).^2);
 i=0;
 while(du>.00000001)
  u10 = u./(1-sqrt(Cd(uguess)).*log(10./y)/kappa);
  du = max((uguess-u10).^2)
  uguess = u10;
  i = i+1
 end%while
%
end%function

function CDN = Cd(u10)
% Drag Coefficient from Large and Pond 1981
% only valid for 4m/s < u10
% CDN = 1.2e-3 4m/s<u10<11m/s;
% CDN = (0.49+0.065*u10)*1e-3 u10>11m/s;
CDN =(1e-3)*(1.2.*(u10<=11)+(0.49+0.065*u10).*(u10>11));
end%function
