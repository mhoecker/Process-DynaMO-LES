function [P,f,DOF] = ensavg(y,t,M)
 N = length(t);
 dt = t(2)-t(1);
 N = floor(N/M);
 f = (linspace(0,N-1,N)-floor(N/2))/(N*dt);
 P = zeros(1,N);
 for i=1:M
  ysub = y((i-1)*N+1:i*N);
  ysub = ysub-mean(ysub);
  var = sum(ysub.^2);
  ysub = triangle(ysub);
  var = var/sum(ysub.^2);
  ysub = ysub*sqrt(var);
  Ysub = fftshift(fft(ysub))/N;
  P = P+N*dt*Ysub.*conj(Ysub);
 endfor
 P = P/M;
