DynamoDir = '/home/mhoecker/work/Dynamo/';
rstfile = [DynamoDir, 'output/yellowstone15/rst.nc'];
zlevels = -[5,30,60];
xlevels = [1,128,255];
ylevels = xlevels+.5;
outdir = [DynamoDir, '/plots/y15/'];
ensureSkyllingstad1999
[useoctplot,t0sim,dsim,tfsim,limitsfile,dir] = plotparam(outdir,"w")
removeSkyllingstad1999
nc = netcdf(rstfile,'r');
time = t0sim+nc{"time"}(:)/(24.0*60*60);
zfull = nc{"zw"}(:);
dz = mean(diff(zfull));
y = nc{"yu"}(:);
x = nc{"xw"}(:);
Nx = length(x);
Ny = length(y);
Nz = length(zlevels);
Nt = length(time);
z = [];
zfull = abs(zfull)-length(zfull)*dz;
for i=1:Nz
 xlevels(i)
 xidx = find(abs(x-xlevels(i))<dz,1)
 ylevels(i)
 yidx = find(abs(y-ylevels(i))<dz,1)
 zlevels(i)
 zidx = find(abs(zfull-zlevels(i))<dz,1)
 z = [z,zfull(zidx)];
 for j=1:Nt
  u = squeeze(nc{"um"}(j,zidx,:,:));
  v = squeeze(nc{"vm"}(j,zidx,:,:));
  wxy = squeeze(nc{"wm"}(j,zidx,:,:));
  wxz = squeeze(nc{"wm"}(j,:,yidx,:));
  wyz = squeeze(nc{"wm"}(j,:,:,xidx));
  u = u-mean(mean(u));
  v = v-mean(mean(v));
  tke = (u.^2+v.^2+wxy.^2)/2;
  p = squeeze(nc{"p_p"}(j,zidx,:,:));
  p = p-mean(mean(p));
  sfx = [num2str(i,"%02i") num2str(j,"%02i") ".dat"];
  pfx = [outdir "dat/"];
  binmatrix(x,y,wxy,[pfx "wxy" sfx]);
  binmatrix(x,zfull,wxz,[pfx "wxz" sfx]);
  binmatrix(x,zfull,wyz,[pfx "wyz" sfx]);
  binmatrix(x,y,p,[pfx "p" sfx]);
  binmatrix(x,y,tke,[pfx "tke" sfx]);
 end%for
end%for
ncclose(nc);
unix(["gnuplot " limitsfile " " dir.script "wplot.plt"])
