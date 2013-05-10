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
s = floor(min(tgood)):1/24:ceil(max(tgood));
ulp = zeros(length(s),length(z));
uhp = zeros(length(s),length(z));
vlp = zeros(length(s),length(z));
vhp = zeros(length(s),length(z));
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
save("/home/mhoecker/work/Dynamo/Observations/mat/ADCP/adcp150_filled_with_140_filtered_1hr_3day.mat","z","s","lats","lons","Uss","Vss","uhp","ulp","vhp","vlp")
