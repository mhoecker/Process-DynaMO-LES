function [spice,spice2,rholin] = linearSpice(dT,dS,alpha,beta)
% Calculate the spice and density using a linear aproximation
% of the equation of state
% perpendicular on a T-S plot
 spice = dT*beta-dS*alpha;
% linear approximation of rho
 rholin = alpha*dT+beta*dS;
% perpendicular on a alpha T vs beta S plot
 spice2 = dT*alpha-dS*beta;
end%function
