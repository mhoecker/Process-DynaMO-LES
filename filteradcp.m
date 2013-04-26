%filteradcp
filename = '/home/mhoecker/work/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140.nc';
maxdpos = .2;
nc = netcdf(filename,'r');
t = nc{'t'}(:);
lat = nc{'lat'}(:);
lon = nc{'lon'}(:);
dlat = diff(lat);
dlon = diff(lon);
dt = diff(t);
% Distance from nominal station
dpos = sqrt(lat.^2+(lon-80.5).^2);
% indecies of points near station
dnumstart = datenum([2011,11,20,0,0,0]);
dnumstop = datenum([2011,11,30,0,0,0]);
idxclose = find((dpos<maxdpos).*(t>dnumstart).*(t<dnumstop));
% depths
z = nc{'z'}(:);
% choose times near station
tgood = t(idxclose)-datenum([2011,1,1,0,0,0]);
% velocity data
u = nc{'u'}(:,:);
%v = nc{'v'}(:,:);
% choose times near station
u = u(idxclose,:);
s = min(tgood):1/24:max(tgood);
figure(1)
plot(s)
figure(2)
[zt,tt] = meshgrid(z,tgood);
[zs,ss] = meshgrid(z,s);
ulp = ss;
uhp = ss;
for i=1:length(z)
 uhp(:,i) =csqfil(u(:,i),tgood,s);
 ulp(:,i) =csqfil(uhp(:,i),s,s,3);
end%for
uhp = uhp-ulp;
%
figure(1)
plot(t,dpos,t,maxdpos*ones(size(t)));
axis([min(t),max(t),0,5*maxdpos]);
colorbar
%
figure(2)
subplot(2,1,1)
pcolor(ss,zs,uhp);
shading flat;
axis([min(tgood),max(tgood),-200,0]);
colorbar
subplot(2,1,2)
pcolor(ss,zs,ulp);
shading flat;
axis([min(tgood),max(tgood),-200,0]);
colorbar
