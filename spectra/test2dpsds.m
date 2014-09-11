% test two dimensional power spectral density functions
x = linspace(0,1,2^9);
y = linspace(0,1,2^9);
kf = 2*pi/sum(diff(x));
lf = 2*pi/sum(diff(y));
km = min([pi/mean(diff(x)),pi/mean(diff(y))])/2;
theta0 = rand(1,1)*2*pi;
k0 = km*cos(theta0);
l0 = km*sin(theta0);
[xx,yy] = meshgrid(x,y);
zz = 0*xx;
Npeaks = floor(sqrt(length([x,y])/16));
for i=1:Npeaks
 kscale = (i-.5)/Npeaks;
 lscale = (i-.5)/Npeaks;
 phi = rand(1,1)*2*pi;
 zz = zz+cos(phi+kscale*k0*xx+lscale*l0*yy);
end%for
zz = window2d(zz,1);
[P,k,l,Pa,ka,la,Pb,khun] = twodpsd(x,y,zz);
[kr,Pr,dtheta]=directionalSpec(theta0,k,l,P);
krange = [-1,1]*max(abs(k));
kprange = [mean(diff(kr)),max(abs(kr))];
lrange = [-1,1]*max(abs(l));
klrange = [krange,lrange];
[kk,ll]=meshgrid(k,l);
[kka,lla]=meshgrid(ka,la);
figure(1)
subplot(2,2,1);pcolor(kk,ll,log(P)/log(10)); shading flat;axis(klrange); colorbar
subplot(2,2,2);pcolor(kka,lla,log(Pa)/log(10)); shading flat;axis(klrange); colorbar
subplot(2,2,3);loglog(khun,Pb); axis(kprange)
subplot(2,2,4);loglog(kr,Pr); axis(kprange)
figure(2)
pcolor(kk,ll,dtheta); shading flat
