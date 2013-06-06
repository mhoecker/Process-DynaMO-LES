function [xs] = smooth(x,f)
%   SMOOTH
%   Apply simple binomial smoothing to the vector x. 
%   (For now, x is assumed to be a column vector!)
%
%   The optional second argument is the smoothing factor f.
%      f=1: full smoothing (the default);
%      f=0: no smoothing.
%      f>1: repeat smoothing floor(f) times;
%
%   Endpoints are not altered.
%
%   Example: If x=[1 4 9 16 25]',
%      then smooth(x) = smooth(x,1) = [1.0 4.5 9.5 16.5 25.0]';
%           smooth(x,.5) = [1.0 4.25 9.25 16.25 25.0]'
%
s=size(x);
nx=s(1);
%
% Determine smothing factor (make sure it's <=1)
%
if nargin>=2
   ff=f;
else
   ff=1;
end

if ff<=1;
    % Smooth data
    xs(1,:)=x(1,:);
    for i=2:nx-1
        xs(i,:)=(1-.5*ff)*x(i,:)+.25*ff*(x(i-1,:)+x(i+1,:));
    end
    xs(nx,:)=x(nx,:);
    
else
    for j=1:floor(ff)
        xs(1,:)=x(1,:);
        for i=2:nx-1
            xs(i,:)=.5*x(i,:)+.25*(x(i-1,:)+x(i+1,:));
        end
        xs(nx,:)=x(nx,:);
        x=xs;
    end
end

% s=size(x);
% if s(1)>s(2);xs=xs';end
return