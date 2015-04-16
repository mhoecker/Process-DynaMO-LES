addpath spectra;
addpath Article2;
outdir = "/home/mhoecker/Documents/work/Dynamo/plots/MIMOC";
dir = plotparam(outdir,"winplots");
dtunits = 1/(60*24);%convert minutes to days
ncfile = "/home/mhoecker/Documents/work/Dynamo/Observations/netCDF/TAO/10m/w0n155w_10m.cdf"
nc = netcdf(ncfile,'r');
t = nc{'time'}(:);
mean(diff(t));
Ntot = length(t);
Nt = 2^10;
ti = nc{'time'}(1:Nt)*dtunits;
ti = ti-mean(ti);
x = [ones(size(ti))';ti'];
j = 0;
tm  = [];
mus = [];
mvs = [];
for i=Nt:Nt/8:Ntot
 j = j+1;
 idx = 1+i-Nt:i;
 ti = nc{'time'}(idx)*dtunits;
 ui = squeeze(nc{'WU_422'}(idx,:,:,:));
 vi = squeeze(nc{'WV_423'}(idx,:,:,:));
 if(sum(isnan(ui+vi))==0)
  tm = [tm,mean(ti)];
  % Detrend (effectivly HP filter)
  mu = LinearRegression(x',ui);
  mus = [mus,mu];
  uh = ui-x'*mu;
  mv = LinearRegression(x',vi);
  mvs = [mvs,mv];
  vh = vi-x'*mv;
  %
  binarray(ti',[uh';vh'],[dir.dat "windplots" num2str(j,"%04i") ".dat"]);
  %subplot(2,1,1)
  %plot(ti,uh,";Zonal;",ti,x'*mu,";Low Pass;")
  %axis([min(ti),max(ti),-15,15])
  %title(["Zonal"])
  %subplot(2,1,2)
  %title(["Meridional"])
  %plot(ti,vh,";High Pass;",ti,x'*mv,";Low Pass;")
  %axis([min(ti),max(ti),-15,15])
  %print([dir.png "windplots" num2str(j,"%04i") ".png"],"-dpng","-S1280,1024")
 end%if
end%for
binarray(tm,[mus;mvs],[dir.dat "windplotsLP.dat"]);
unix(["gnuplot " dir.initplt " " dir.script "windplots.plt"])
unix(["pngmovie.sh -t avi -n " dir.png "windplots -l " dir.png "windplot"])
