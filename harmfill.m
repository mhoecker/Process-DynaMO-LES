function [y,wmatrix] = harmfill(x,t,s,T,order,demoname)
% [y,fil] = harmfill(x,t,s,T,order)
% Filter the time series x with a weighting function
%
% weight(t,s) = cos(pi*(s-t)/T)^order for |s-t| < T/2
% This filter has a 1/2 power point of f approx 1/T
% first zero power at f~(.5*order+1)/T
% Roll off of (T*f)^(-10)
% if T is not given T = (.5*order+1)*mean(diff(s))
% if the order is not given order = 1
%
 if(nargin<5)
  order = 1;
 end%if
 %
 if(nargin==0)
 % plot the filter frequency response
 % compare a moving average of same width
  N = 2^18;
  harmfilldemo(N,1,"harmfill1")
  harmfilldemo(N,2,"harmfill2")
  harmfilldemo(N,3,"harmfill3")
  harmfilldemo(N,4,"harmfill4")
  harmfilldemo(N,5,"harmfill5")
  harmfilldemo(N,6,"harmfill6")
  harmfilldemo(N,7,"harmfill7")
 elseif(nargin==6)
 % plot the filter frequency response
 % compare a moving average of same width
  N = 2^16;
  harmfilldemo(N,order,demoname)

 else
  if(nargin<4)
   T = (.5*order+1)*mean(diff(s));
  end%if
  N = length(t);
  M = length(s);
  wmatrix = [];
% ensure there is nothing to alias into the new sampling
  y = zeros(1,M);
  for i=1:M
   w = zeros(1,N);
   for j=1:N
    if((abs(s(i)-t(j))<T/2)*(1-isnan(x(j))))
     w(j) = harmwt(s(i)-t(j),T,order);
     y(i) = y(i)+x(j).*w(j);
    end%if
   end%for
    wsum = sum(w);
    if(wsum==0)
     y(i) = NaN;
     w = w.*0
    else
     w = w./wsum;
     y(i) = y(i)/wsum;
    end%if
    wmatrix = [wmatrix,w'];
  end%for
 end%if
end%function

function harmfilldemo(N,order,outname)
  f = (1:N)-1-ceil(N/2);
  t = f/N; t = t-mean(t);
  f = f/sqrt(N);
  t = t*sqrt(N);
  T = 1.0;
  wa = (1+sign(1-abs((order+2)*t/T)));
  wa = wa./sum(wa);
  Fwa = fftshift(fft(wa));
  Pwa = abs(Fwa).^2;
  w = harmwt(t,T,order);
  w = w/sum(w);
  Fw = fftshift(fft(w));
  Pw = abs(Fw).^2;
%
% Pass band
  subplot(2,2,1);
  plot(f,Pw,"b;filter  ;",f,Pwa,["r;T/" num2str(1+.5*order) " moving avg.  ;"]);
  grid on;
  axis([0,.95/T,.1,1]);
%  title(["cosq filter 1/T=" num2str(1/T)]);
  xlabel("freq.");
  ylabel("Filter");
% Filtered band
  subplot(2,2,2);
  loglog(f,Pw,"b;filter  ;",f,(T*f).^(-2-2*order),["k;fT^{" int2str(-2-2*order) "};"],f,Pwa,["r;T/" num2str(1+.5*order) " moving avg.  ;"],f,(T*f).^-2,"k;fT^{-2};");
  axis([1/T,64/T,64^(-6),1]);
%  title(["cosq filter 1/T=" num2str(1/T)]);
  xlabel("freq.");
  ylabel("Filter");
% weights
  subplot(2,1,2);
  plot(t,w,"b;filter ;",t,wa,["r;T/" num2str(1+.5*order) " moving avg.  ;"]);
  axis([-T/2,T/2,0,1.05*max([w,wa])]);
  title(["filters, T=" num2str(T)]);
  xlabel("Time diff.");
  ylabel("Weight")
  print([outname ".png"],"-dpng","-S1280,1024","-F:8")
end%function

function w = harmwt(dt,T,order)
 w=(1+sign(1-abs(2*dt/T))).*(cos(pi.*(dt./T))).^(order);
end%function
