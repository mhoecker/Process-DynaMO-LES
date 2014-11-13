N = 128;
T = -log(rand(1,1));
t = (1:N)/N;
t = T*t;
dt = mean(diff(t));
df = 1.0/T;
f = ((1:N)-1-floor((N+1)/2))*df;
phase = 2*pi*rand(1,N);
for i=1:N
 if(f(i)<0)
  idxminus = find(f==-f(i));
  phase(idxminus) = -phase(i);
 elseif(f(i)==0)
  phase(i)==0;
 end
end
f1 = df*sqrt(N/2);
fwid = (sqrt(N/2)/3)*df;
figure(3)
subplot(3,1,1)
Fx = (abs(f)-f1)/(fwid);
Fx = exp(-2.0*(Fx).^2)/2;
plot(f/df,Fx)
Fx = Fx.*exp(I*phase);
subplot(3,1,2)
plot(f/df,abs(Fx),f,phase/(2*pi))
#
x = (N*ifft(ifftshift(Fx)));
subplot(3,1,3)
plot(t/T,imag(x))
x = real(x);
#x = sin(2*pi*f1*t);
#x = exp(-6*(t-mean(t)).^2).*x;
Fx = fftshift(fft(x))/N;
Px = 2*abs(Fx.*conj(Fx))/df;
figure(4)
#
noisy = 1./16;
xnoise = x+noisy*(rand(1,N)-.5)*2;
Fxnoise = fftshift(fft(sinew(xnoise)))/N;
figure(5)
win = 'sinw';
Pxnoise = 2*abs(Fxnoise.*conj(Fxnoise))/df;
#
gappy = 0.25;
idxnan = find(rand(1,N)<gappy);
gaps = ones(1,N);
gaps(idxnan) = NaN*gaps(idxnan);
xgap = x.*gaps;
[Pxgap,dPxgap,fgap] = gappypsd(xgap,t,win);
xgapnoise = xnoise.*gaps;
[Pxgapnoise,dPxgapnoise,fgapnoise] = gappypsd(xgapnoise,t,win);
#
order = 1;
fillwid = 10*T/N;
idxgood = find(~isnan(xgap));
xgapfill = harmfill(xgap(idxgood),t(idxgood),t,order,fillwid);
[Pxgapfill,dPxgapfill,fgapfill] = gappypsd(xgapfill,t,win);
xgapnoisefill = harmfill(xgapnoise(idxgood),t(idxgood),t,order,fillwid);
[Pxgapnoisefill,dPxgapnoisefill,fgapnoisefill] = gappypsd(xgapnoisefill,t,win);
# do linear interpolation
interporder = 5;
[Pxi,fi,xi] = interpPSD(xgap,t,interporder);
Pxi = 2*Pxi;
#
[Pxin,fin,xin] = interpPSD(xgapnoise,t,interporder);
Pxin = 2*Pxin;
#
figure(1)
arange = [0,T];
subplot(3,1,1)
plot(t,x,'k;signal;',t,xnoise,'r;+noise;')
title('data with gaps and noise')
axis(arange)
subplot(3,1,2)
plot(t,xgap,'g;gaps;',t,xgapnoise,'b;gaps+noise;')
axis(arange)
subplot(3,1,3)
plot(t,xi,'g;gaps;',t,xin,'b;gaps+noise;')
axis(arange)
print('gapy-noisy-data.png','-dpng')
#
arange = [df,max(f),min(Pxnoise)/2,2*max(Pxnoise)];
figure(2)
subplot(1,1,1)
#,fgap,dPxgap,'g',fgapnoise,dPxgapnoise,'b',fgapfill,dPxgapfill,'c',fgapnoisefill,dPxgapnoisefill,'m'
#,fgapfill,Pxgapfill,'c.;filtered gaps;',fgapnoisefill,Pxgapnoisefill,'m.;filtered gaps+noise;'
loglog(f,Px,'k;signal;',f,Pxnoise,'r;+noise;',fgap,Pxgap,'g.;gaps;',fgapnoise,Pxgapnoise,'b.;gaps+noise;',f,Pxi,"g;interpolated;",f,Pxin,"b;interpolated w/noise;")
ylabel('PSD')
legend('location','northwest')
title('PSD of data with gaps and noise')
axis(arange)
print('gapy-noisy-PSD.png','-dpng')

