[t_sfc0,SST,tauM,tau,precip_sfc,evap_sfc,h20f_sfc,hflx_sfc,hf_lat] = DYNAMOsfc();
N = length(t_sfc0);
if N>4096
 M = 4096;
else
 M=N;
endif
t = t_sfc0(1:N);
t = t-min(t);
t = t/(3600*24);
dt = mean(diff(t));
stress = tau;
T = N*dt;
df = 1/T;
f = (linspace(1,N,N)-ceil((N+1)/2))*df;
Ftau = fftshift(fft(sinew(stress'-mean(stress))));
fig = 0;
%
%close all
fig = fig+1; figure(fig)
plot(t,real(tau),t,imag(tau));
%
idxp = find(f>0);
Ftaup = Ftau(idxp);
Staup = abs(Ftaup).^2;;
StauM = max(Staup);
fp = f(idxp);
%
fig = fig+1; figure(fig)
loglog(fp,Staup);
axis([df,M*df/2,StauM/N^2,1.1*StauM])
%
H = exp(-.5*(f'/(M*df/5)).^2);
Hp = H(idxp);
%
fig = fig+1; figure(fig)
loglog(fp,Hp,fp,Staup.*Hp')
axis([df,M*df/2,StauM/N^2,1.1*StauM])
%
Ftau = fftshift(fft(stress));
Ftau = Ftau.*H;
cleanstress = ifft(ifftshift(Ftau));
%
fig = fig+1; figure(fig)
plot(t,real(cleanstress),t,imag(cleanstress));
%
fig = fig+1; figure(fig)
plot3(t,cleanstress)
%
fig = fig+1; figure(fig)
subplot(2,1,1)
plot(t,evap_sfc)
subplot(2,1,2)
plot(t,SST)
