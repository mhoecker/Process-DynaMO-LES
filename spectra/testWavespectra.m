for k=34:48
 [h,t] =Wavecorrected2NetCDF("/home/mhoecker/work/Dynamo/Observations/ascii/PSD_wave/",["Wavecorrected_32" num2str(floor(8+k/24),"%1i") num2str(mod(k,24),"%02i")],"/home/mhoecker/work/Dynamo/Observations/netCDF/PSD_wave/");
 output_dir = "/home/mhoecker/work/Dynamo/output/surfspectra/";
 plot_dir = "/home/mhoecker/work/Dynamo/plots/surfacewaves/";
 basename = "wavespectra";
 time()-tic
 win = '';
 day = floor(min(t));
 Nt = length(t);
 dN = 500;
 close all
 tvals = [];
 Avals = [];
 Tvals = [];
 lamvals = [];
 cpvals = [];
 Usvals = [];
 j=0
 for i=1:dN:Nt-dN
  j=j+1;
  tic = time();
  hin = h(i:i+dN);
  hin = hin-nanmean(hin);
  j = ceil((i+dN)/(dN+1));
  hour = floor((t(i)-day)*24);
  minute = floor(((t(i)-day)*24-hour)*60);
  second = floor((((t(i)-day)*24-hour)*60-minute)*60);
  dayhourstring = [padint2str(day,3) padint2str(hour,2)];
  datestring = [padint2str(day,3) padint2str(hour,2) padint2str(j,2)];
  tin = t(i:i+dN);
  tmid = mean(tin);
  tin = (tin-min(tin))*24*60*60;
  dt = mean(diff(tin));
  df = 1./(dN*dt);
  ftest = [floor(.01/df)*df:df:1];
  win = '';
  [Px,dPx,f,xfit,err] = gappypsd(hin,tin,win);
  df = mean(diff(f));
  Nf = length(f);
#
  Pxm = max(Px);
  if(~isnan(Pxm));
   idxmax = find(Px==Pxm,1);
   fmax = f(idxmax);
   [SCamp,dSCamp,xfmax,err] = harmonicfit(hin,tin,fmax);
   Amax = SCamp(2);
   Bmax = SCamp(1);
  else
   fmax = NaN;
   xfmax = NaN*tin;
   Amax = NaN;
   Bmax = NaN;
  end%if
  Aval = (sqrt(Amax^2+Bmax^2));
  Tval = (1/fmax);
  lamval = (9.80665/(2*pi*fmax^2));
  cpval = lamval*fmax;
  Usval = cpval*(2*pi*Aval/lamval)^2;
  tvals = [tvals,tmid];
  Avals = [Avals,Aval];
  Tvals = [Tvals,Tval];
  lamvals = [lamvals,lamval];
  cpvals = [cpvals,cpval];
  Usvals = [Usvals,Usval];
  A = num2str(Aval);
  T = num2str(Tval);
  lam = num2str(lamval);
  cp = num2str(cpval);
  Us = num2str(Usval);
#
  binarray(tin',[hin,xfit,xfmax]',[plot_dir basename "SSH" datestring '.dat']);
  binarray(f,Px,[plot_dir basename "freq" datestring '.dat']);
#
  time()-tic
  save("-V7",[output_dir basename datestring ".mat"],"tin","hin","xfit","f","Px");
 end%for i
 binarray(tvals,[Avals;Tvals;lamvals;cpvals;Usvals],[plot_dir basename "vals" dayhourstring '.dat']);
 save("-V7",[output_dir basename dayhourstring ".mat"],"tvals","Avals","Tvals","lamvals","cpvals","Usvals");
end%for k
