function [P,f,DOF] = ensavg(y,t,M)
%function [P,f,DOF] = ensavg(y,t,M)
% Ensamble average of Power spectra
%
% Requires
% time series y
% times t (assumed equalluy spaced)
% number of subsamples M
%
% Returns average
% power spectra P
% frequencies f
% and  degrees of freedom DOF
%
%
%
 N = length(t);
 dt = mean(diff(t));
 N = floor(N/M);
 f = (linspace(0,N-1,N)-floor(N/2))/(N*dt);
 P = zeros(1,N);
 for i=1:M
  ysub = y((i-1)*N+1:i*N);
  ysub = ysub-mean(ysub);
  var = sum(ysub.^2);
  ysub = sinew(ysub);
  var = var/sum(ysub.^2);
  ysub = ysub*sqrt(var);
  Ysub = fftshift(fft(ysub))/N;
  P = P+N*dt*Ysub.*conj(Ysub);
 endfor
 P = P/M;
