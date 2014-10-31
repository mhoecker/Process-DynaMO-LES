function ncepwindfigs(uvfile)
#
if(nargin==0)
 uvfile='/home/mhoecker/work/Dynamo/output/ncep.reanalysis/uvwnd.10m.gauss.2012.nc';
end#if
plotdir = "/home/mhoecker/work/Dynamo/plots/ncep/";
uvnc = netcdf(uvfile,'r');
t = uvnc{'time'}(:);
t = (t-min(t))/24;
lat = uvnc{'lat'}(:);
lon = uvnc{'lon'}(:);
U = uvnc{'uwnd'}(:);
V = uvnc{'vwnd'}(:);
ncclose(uvnc)
ensureSkyllingstad1999;
[useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam(plotdir,plotdir,"");
removeSkyllingstad1999;
idx = strfind(scriptdir,"/S");
scriptdir = scriptdir(1:idx(1));
for i=1:1#length(t)
 u = squeeze(U(i,:,:));
 v = squeeze(V(i,:,:));
 a = atan2(v,u);
 s = sqrt(u.^2+v.^2);
 adat = [plotdir,"angle", num2str(i,"%09i"),".dat"];
 sdat = [plotdir,"speed", num2str(i,"%09i"),".dat"];
 binmatrix(lon,lat,a,adat);
 binmatrix(lon,lat,s,sdat);
end#for
unix(["gnuplot " limitsfile " " scriptdir "ncepwindfigs.plt"])
#
