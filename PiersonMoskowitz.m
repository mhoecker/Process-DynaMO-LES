function PiersonMoskowitz(U,t)
# Fake Pierson Moskowitz spectrum
#
alpha  = 8.10e-3;
beta  = 0.74;
g = 9.81;
#
if(nargin<1)
# Load wind speed data
 sfxnc = '/home/mhoecker/work/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc';
 sfx = netcdf(sfxnc,'r');
 t = sfx{'Yday'}(:);
 idx = find((t>=328)&(t<=329));
 t = sfx{'Yday'}(idx(1:10:end));
 U = sfx{'U10'}(idx(1:10:end));
 ncclose(sfx)
end
#
f = .05:.01:1;
Sf = zeros(length(f),length(U));
#
Us = 0.015*U;
k = 1./(.24 *(U.^2)/g);
fs = sqrt(g*k)/(2*pi);
T = 1./fs;
#
figure(1)
for i=1:length(U)
 # Calculate peak frequency
 f0 = g./(2*pi*U(i));
 Sf(:,i) = 2*pi*(alpha*g^2).*exp(-beta*(f0./f).^4)./(2*pi*f).^5;
 plot(f,Sf(:,i))
end
[tt,ff] = meshgrid(t,f);
figure(2)
subplot(2,1,1)
plot(t,U,"k;U_w (m/s);",t,100*Us,"b;U_s (cm/s);"); ylabel("U")
subplot(2,1,2)
pcolor(tt,1./ff,Sf); shading flat; ylabel("Period");xlabel("UTC Yearday")
hold on
plot(t,T,"k;T Stokes")
hold off
print("/home/mhoecker/tmp/PMspectra.pdf","-dpdf")
