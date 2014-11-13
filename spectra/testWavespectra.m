for k=0:47
 [h,t] =Wavecorrected2NetCDF("/home/mhoecker/work/Dynamo/Observations/ascii/PSD_wave/",["Wavecorrected_32" num2str(floor(8+k/24),"%1i") num2str(mod(k,24),"%02i")],"/home/mhoecker/work/Dynamo/Observations/netCDF/PSD_wave/");
 output_dir = "/home/mhoecker/work/Dynamo/output/surfspectra/";
 plot_dir = "/home/mhoecker/work/Dynamo/plots/surfacewaves/";
 basename = "wavespectra";
 time()-tic
 day = floor(min(t));
 hour = floor((t(1)-day)*24);
 Nt = length(t);
 dt = mean(24*60*60*diff(t));
 dN = floor(180./dt);
 tvals = [];
 Avals = [];
 Tvals = [];
 lamvals = [];
 cpvals = [];
 Usvals = [];
 j=0;
 for i=1:dN:Nt-dN
  j=j+1;
  tic = time();
  hin = h(i:i+dN);
  hin = hin-nanmean(hin);
  minute = floor(((t(i)-day)*24-hour)*60);
  second = floor((((t(i)-day)*24-hour)*60-minute)*60);
  dayhourstring = [padint2str(day,3) padint2str(hour,2)];
  datestring = [padint2str(day,3) padint2str(hour,2) padint2str(j,2)];
  ti = t(i:(i+dN));
  tmid = mean(ti);
  tin = (ti-min(ti))*24*60*60;
  dt = mean(diff(tin));
  df = 1./(dN*dt);
  [Px,f,xfit] = interpPSD(hin',tin,1);
  Pxf = Px.*abs(f);
  df = mean(diff(f));
  Nf = length(f);
#
  Pxfm = max(Pxf);
  if(~isnan(Pxfm));
   idxmax = find(Pxf==Pxfm,1);
   fmax = abs(f(idxmax));
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
  tmids = tmid*ones(size(tin));
  binarray(ti',[hin,xfit',xfmax]',[plot_dir basename "SSH" datestring '.dat']);
  binarray(tmids',[f;Px],[plot_dir basename "freq" datestring '.dat']);
  figure(1)
  subplot(2,1,1)
  loglog(abs(f),Pxf,fmax,Pxfm,"r+");
  title([datestring " T=" T " A=" A])
  subplot(2,1,2)
  plot(tin,hin,"ko;;",tin,xfit,"r-",tin,SCamp(1)*sin(2*pi*fmax*tin)+SCamp(2)*cos(2*pi*fmax*tin),"g-");
  axis([0,dN*dt])
  figure(2)
#
  time()-tic
  save("-V7",[output_dir basename datestring ".mat"],"tin","hin","xfit","f","Px");
 end%for i
 binarray(tvals,[Avals;Tvals;lamvals;cpvals;Usvals],[plot_dir basename "vals" dayhourstring '.dat']);
 subplot(2,1,1)
 plot(tvals,Avals)
 subplot(2,1,2)
 plot(tvals,Tvals)
 save("-V7",[output_dir basename dayhourstring ".mat"],"tvals","Avals","Tvals","lamvals","cpvals","Usvals");
end%for k
