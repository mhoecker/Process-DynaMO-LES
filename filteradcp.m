%filteradcp
fileloc = '/home/mhoecker/work/Dynamo/Observations/netCDF/ADCP/';
filename = 'adcp150_filled_with_140';
maxdpos = .2;
nc = netcdf([fileloc filename '.nc'],'r');
t = nc{'t'}(:);
lat = nc{'lat'}(:);
lon = nc{'lon'}(:);
Us = nc{'Us'}(:);
Vs = nc{'Vs'}(:);
dlat = diff(lat);
dlon = diff(lon);
dt = diff(t);
% Distance from nominal station
dpos = sqrt(lat.^2+(lon-80.5).^2);
% indecies of points near station
dnumstart = datenum([2011,11,11,0,0,0]);
dnumstop = datenum([2011,12,3,0,0,0]);
idxclose = find((dpos<maxdpos).*(t>dnumstart).*(t<dnumstop));
% depths
z = nc{'z'}(:);
% choose times near station
tgood = t(idxclose);
% velocity data
u = nc{'u'}(:,:);
v = nc{'v'}(:,:);
% choose times near station
s = min(tgood):1/24:max(tgood);
figure(1)
plot(s)
figure(2)
[zs,ss] = meshgrid(z,s);
ulp = ss;
uhp = ss;
vlp = ss;
vhp = ss;
lats = csqfil(lat,t,s);
lons = csqfil(lon,t,s);
Uss = csqfil(lon,t,s);
Vss = csqfil(lon,t,s);
for i=1:length(z)
 uhp(:,i) =csqfil(u(:,i),t,s);
 ulp(:,i) =csqfil(uhp(:,i),s,s,3);
 vhp(:,i) =csqfil(v(:,i),t,s);
 vlp(:,i) =csqfil(vhp(:,i),s,s,3);
end%for
save("/home/mhoecker/work/Dynamo/adcp150_filled_with_140_filtered_1hr_3day.mat","s","lat","lon","Uss","Vss","uhp","ulp","vhp","vlp")
uhp = uhp-ulp;
vhp = vhp-vlp;
%
%
uhrange = max(max(abs(uhp)));
ulrange = max(max(abs(ulp)));
vhrange = max(max(abs(vhp)));
vlrange = max(max(abs(vlp)));
tzero = datenum([2011,10,31,0,0,0]);
[zt,tt] = meshgrid(z,tgood-tzero);
[zs,ss] = meshgrid(z,s-tzero);
%
%
figure(1)
subplot(2,1,1)
plot(t-tzero,dpos,t-tzero,maxdpos*ones(size(t)));
axis([min(t)-tzero,max(t)-tzero,0,5*maxdpos]);
subplot(2,1,2)
plot(s-tzero,Uss,";Ship U;",s-tzero,Vss,";Ship V;");
axis([min(t)-tzero,max(t)-tzero]);
%
%
figure(2)
subplot(4,1,1)
pcolor(ss,zs,uhp);shading flat;axis([min(tgood)-tzero,max(tgood)-tzero,-250,0]);caxis(uhrange*[-1,1]);colorbar;title("U high pass")
%
subplot(4,1,2)
pcolor(ss,zs,vhp);shading flat;axis([min(tgood)-tzero,max(tgood)-tzero,-250,0]);caxis(vhrange*[-1,1]);colorbar;title("V high pass")
%
subplot(4,1,3)
pcolor(ss,zs,ulp);shading flat;axis([min(tgood)-tzero,max(tgood)-tzero,-250,0]);caxis(ulrange*[-1,1]);colorbar;title("U low pass")
subplot(4,1,4)
pcolor(ss,zs,vlp);shading flat;axis([min(tgood)-tzero,max(tgood)-tzero,-250,0]);caxis(vlrange*[-1,1]);colorbar;title("V low pass")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" filename ".png"],"-dpng","-S1280,1024")
