N = 512;
t = (1:N)/N;
dt = mean(diff(t));
T = N*dt;
df = 1/T;
f = ((1:N)-ceil((N+1)/2))*df;
phase = 2*pi*rand(1,N);
f1 = 48;
Fx = 	abs(f).*exp(-(f/f1).^2);
Fx = Fx.*exp(I*phase);
for i=1:N
 if f(i)>0
  idxminus = find(f==-f(i));
  Fx(i) = conj(Fx(idxminus));
 end
 if f(i)==0
  F(i) = 0;
 end
end
x = real(ifft(ifftshift(Fx)));
#x = sin(2*pi*f1*t);
#x = exp(-6*(t-mean(t)).^2).*x;
Fx = fftshift(fft(x))/N;
Px = 2*abs(Fx.*conj(Fx))*N*dt;
#
noisy = 1./128;
xnoise = x+noisy*(rand(1,N)-.5)*2;
Fxnoise = fftshift(fft(sinew(xnoise)))/N;
win = 'sinw';
Pxnoise = 2*abs(Fxnoise.*conj(Fxnoise))/df;
#
gappy = .25;
idxnan = find(rand(1,N)<gappy);
gaps = ones(1,N);
gaps(idxnan) = NaN*gaps(idxnan);
xgap = x.*gaps;
[Pxgap,dPxgap,fgap] = gappypsd(xgap,t,win);
xgapnoise = xnoise.*gaps;
[Pxgapnoise,dPxgapnoise,fgapnoise] = gappypsd(xgapnoise,t,win);
#
figure(1)
subplot(2,1,1)
plot(t,x,'k;signal;',t,xnoise,'r;+noise;')
title('data with gaps and noise')
subplot(2,1,2)
plot(t,xgap,'g;gaps;',t,xgapnoise,'b;gaps+noise;')
print('gapy-noisy-data.png','-dpng')
#
#arange = [df/2,2*max(f),.0625/df,2/df];
arange = [df/2,2*max(f),min(Pxnoise)/2,2*max(Pxnoise)];
figure(2)
subplot(1,1,1)
loglog(f,Px,'k;signal;',f,Pxnoise,'r;+noise;',fgap,Pxgap,'g.;gaps;',fgapnoise,Pxgapnoise,'b.;gaps+noise;',fgap,dPxgap,'g',fgapnoise,dPxgapnoise,'b')
ylabel('PSD')
legend('location','northwest')
title('PSD of data with gaps and noise')
axis(arange)
print('gapy-noisy-PSD.png','-dpng')

