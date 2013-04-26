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
idxclose = find((dpos<maxdpos).*(t>734818).*(t<734841));
% depths
z = nc{'z'}(:);
% choose times near station
tgood = t(idxclose);
% velocity data
u = nc{'u'}(:,:);
%v = nc{'v'}(:,:);
% choose times near station
u = u(idxclose,:);
s = min(tgood):1/24:max(tgood);
size(z)
size(tgood)
[zt,tt] = meshgrid(z,tgood);
[zs,ss] = meshgrid(z,s);
ulp = ss;
uhp = ss;
for i=1:length(z)
 ulp(:,i) =csqfil(u(:,i),tgood,s,5);
 uhp(:,i) =csqfil(u(:,i),tgood,s);
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
