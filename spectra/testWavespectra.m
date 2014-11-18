for k=0:47
 [h,t] =Wavecorrected2NetCDF("/home/mhoecker/work/Dynamo/Observations/ascii/PSD_wave/",["Wavecorrected_32" num2str(floor(8+k/24),"%1i") num2str(mod(k,24),"%02i")],"/home/mhoecker/work/Dynamo/Observations/netCDF/PSD_wave/");
 output_dir = "/home/mhoecker/work/Dynamo/output/surfspectra/";
 plot_dir = "/home/mhoecker/work/Dynamo/plots/surfacewaves/";
 basename = "wavespectra";
 time()-tic;
 day = floor(min(t));
 hour = floor((t(1)-day)*24);
 Nt = length(t);
 dt = mean(24*60*60*diff(t));
 dN = floor(90./dt);
 [x,wmatrix]=harmfill(1:dN,1:dN,1:dN,4,ceil(1/dt));
 clear x;
 tvals = [];
 Avals = [];
 Tvals = [];
 lamvals = [];
 cpvals = [];
 Usvals = [];
 for i=1:floor(Nt/dN)
  tic = time();
  idx = [1+(i-1)*dN:i*dN];
  hnan = h(idx);
  ti = t(idx);
  hnan = hnan-nanmean(hnan);
  minute = floor(((t(idx(1))-day)*24-hour)*60);
  second = floor((((t(idx(1))-day)*24-hour)*60-minute)*60);
  dayhourstring = [padint2str(day,3) padint2str(hour,2)];
  datestring = [padint2str(day,3) padint2str(hour,2) padint2str(i,2)];
  tmid = mean(ti);
  tin = (ti-min(ti))*24*60*60;
  dt = mean(diff(tin));
  df = 1./(dN*dt);
  goodidx = find(~isnan(hnan));
  tingood = tin(goodidx);
  hgood = hnan(goodidx);
  val = ddzinterp(tingood,tin,2);
  hin = (val*hgood);
  hin = wmatrix'*hin;
  [Px,f,xfit] = interpPSD(hin',tin,3);
  Pxf = Px.*abs(f.^3);
  df = mean(diff(f));
  Nf = length(f);
#
  Pxm = max(Px);
  if(~isnan(Pxm));
   idxmax = find(Px==Pxm,1);
   fmax = abs(f(idxmax));
   [SCamp,dSCamp,xfmax,err] = harmonicfit(hnan,tin,fmax);
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
  tmids = tmid*ones(size(tin));
  binarray(ti',[hnan,xfit',xfmax]',[plot_dir basename "SSH" datestring '.dat']);
  binarray(tmids',[f;Px],[plot_dir basename "freq" datestring '.dat']);
  figure(1)
  subplot(2,1,1)
  loglog(abs(f),Px,fmax,Pxm,"r+");
  title([datestring " T=" T " A=" A])
  subplot(2,1,2)
  plot(tin,hnan,"ko;;",tin,xfit,"r-",tin,SCamp(1)*sin(2*pi*fmax*tin)+SCamp(2)*cos(2*pi*fmax*tin),"g-");
  axis([0,dN*dt])
  figure(2)
#
  time()-tic;
  save("-V7",[output_dir basename datestring ".mat"],"tin","hin","xfit","f","Px");
 end%for i
 binarray(tvals,[Avals;Tvals;lamvals;cpvals;Usvals],[plot_dir basename "vals" dayhourstring '.dat']);
 subplot(2,1,1)
 plot(tvals,Avals)
 subplot(2,1,2)
 plot(tvals,Tvals)
 save("-V7",[output_dir basename dayhourstring ".mat"],"tvals","Avals","Tvals","lamvals","cpvals","Usvals");
end%for k
