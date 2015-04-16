addpath spectra;
addpath Article2;
outdir = "/home/mhoecker/Documents/work/Dynamo/plots/MIMOC";
dir = plotparam(outdir,"winspecs");
dtunits = 1;%/(60*24);%convert minutes to days
ncfile = "/home/mhoecker/Documents/work/Dynamo/Observations/netCDF/TAO/1hr/w0n95w_hr.cdf"
PSDofF = @(f,p) p(1)^2./(1+((f-p(2))./p(3)).^2);
p0 = [1,1,1];
SumTol = 1e-4;
Niter = 200;
nc = netcdf(ncfile,'r');
t = nc{'time'}(:);
mean(diff(t))
Ntot = length(t);
Nt = 2^14;
j = 0;
for i=Nt:Nt:Nt
 j = j+1;
 idx = 1+i-Nt:i;
 ti = nc{'time'}(idx)*dtunits;
 ui = squeeze(nc{'WU_422'}(idx,:,:,:));
 vi = squeeze(nc{'WV_423'}(idx,:,:,:));
 % Detrend
 x = [ones(size(ti))';ti'-mean(ti)];
 p = LinearRegression(x',ui);
 ui = ui-x'*p;
 p = LinearRegression(x',vi);
 vi = vi-x'*p;
 %
 [f,f1] = freqoft(ti);
 uw  = window(ui',1);
 vw  = window(vi',1);
 Fu  = fftshift(fft(uw))/Nt;
 Fv  = fftshift(fft(vw))/Nt;
 Fuv = fftshift(fft(uw+I*vw))/Nt;
 Pu  = abs(Fu).^2;
 Pu1 = oneside(Pu);
 Pv  = abs(Fv).^2;
 Pv1 = oneside(Pv);
 Puv = abs(Fuv).^2;
 [P1uv,Pmuv,Ppuv] = oneside(Puv);
 %
 lf = [ones(size(f1));log(f1)];
 mu = LinearRegression(lf',log(Pu1)');
 Pu1 = Pu1./exp(mu'*lf);
 mv = LinearRegression(lf',log(Pv1)');
 Pv1 = Pv1./exp(mv'*lf);
 mpuv = LinearRegression(lf',log(Ppuv)');
 mmuv = LinearRegression(lf',log(Pmuv)');
 Ppuv = P1uv./exp(mpuv'*lf);
 Pmuv = P1uv./exp(mmuv'*lf);
 %
 Puparam = p0;
 %
 %if(j!=0)
  Pu1avg = Pu1;
  Pv1avg = Pv1;
  Puvpavg = Ppuv;
  Puvmavg = Pmuv;
 %else
 % Pu1avg = Pu1+Pu1avg;
 % Pv1avg = Pv1+Pv1avg;
 % Puvpavg = Ppuv+Puvpavg;
 % Puvmavg = Pmuv+Puvmavg;
 %end%if
end%for
ncclose(nc);
%Pu1avg   = Pu1avg/j;
%Pv1avg   = Pv1avg/j;
%Puvpavg  = Puvpavg/j;
%Puvmavg = Puvmavg/j;
subplot(2,2,1)
loglog(f1,Pu1avg)
subplot(2,2,2)
loglog(f1,Pv1avg)
subplot(2,2,3)
loglog(f1,Puvmavg)
subplot(2,2,4)
loglog(f1,Puvpavg)
