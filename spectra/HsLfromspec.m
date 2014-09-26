function [Hs,lam,t] = HsLfromspec(basename,dayrange)
 if(nargin<1)
  basename="/home/mhoecker/work/Dynamo/output/surfspectra/wavespectra";
 end#if
 if(nargin<2)
  dayrange = [328,329.375];
 end#if
 tseries = [];
 Aseries = [];
 Lseries = [];
 daymax = max(dayrange);
 daymin = min(dayrange);
 lastday =  floor(daymax);
 firstday = floor(daymin);
 for i=firstday:lastday
  if(i<lastday)
   jmax=23;
  else
   jmax = floor(24*(daymax-lastday));
  end#if

  if(i==firstday)
   jmin = ceil(24*(daymin-firstday));
  else
   jmin = 0;
  end#if
  for(j=jmin:jmax)
   matfile = [basename num2str(i,"%03i") num2str(j,"%02i") ".mat"];
   load(matfile);
   tseries = [tseries,tvals];
   Aseries = [Aseries,Avals];
   Lseries = [Lseries,lamvals];
  end#for
 end#for
 Hs = 2*medfilt1(Aseries,3);
 Lam = medfilt1(Lseries,3);
 tHL = tseries;
 save("-V7",[basename  "HSL.mat"],"tHL","Hs","Lam");
 subplot(2,1,1)
 plot(tseries,Hs)
 subplot(2,1,2)
 plot(tseries,Hs./Lam)
end#function


