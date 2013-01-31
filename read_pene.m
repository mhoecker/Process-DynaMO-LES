function [t r1 mu1 r2 mu2] = read_pene(ifile);
% Read ascii file of DYNAMO solar transmission data, courtesy C. Ohlmann, UCSB.
% Input file is "pene.dat".
% USAGE: Tr(z,t)=r1(t)*exp(-z/mu1(t))+(1-r1(t))*exp(-z/mu2(t))
% Multiply by shortwave flux (minus albedo), 
%   differentiate w.r.t. z to get heating rate at any depth.
% W. Smyth, December 2011

% X=load('../../pene/pene.txt');
X=load('input/pene.txt');
t=X(:,1)
r1=X(:,2);
mu1=X(:,3);
r2=1-r1;
mu2=X(:,4);

% example:
% Jerlov IB: r1=0.6 r2=1-r1=0.4 amu1=1.0m amu2=17m (Paulson & Simpson 1977)
