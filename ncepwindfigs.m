function ncepwidnfigs(uvfile)
#
if(nargin==0)
 uvfile='/home/mhoecker/work/Dynamo/output/ncep.reanalysis/uvwnd.2013.nc';
end#if
uvnc = netcdf(uvfile,'r');
t = uvnc{'time'}(:);
t = (t-min(t));
lat = uvnc{'lat'}(:);
lon = uvnc{'lon'}(:);
#U = uvnc{'uwnd'}(:);
#V = uvnc{'uwnd'}(:);
#angle = atan2(U,V);
ncclose(uvnc)
figure(1)
subplot(3,1,1)
plot(t)
subplot(3,1,2)
plot(lat)
subplot(3,1,3)
plot(lon)
