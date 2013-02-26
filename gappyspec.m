function [Fx,dFx,fgood,tgood,xgood,xfit,err] = gappyspec(x,t,win)
# function [Fx,dFx,fgood,tgood,xgood,xfit,err] = gappyspec(x,t)
# Calculate the Fourier Transform of a gappy time series
# 
# Exrtacts a list of points where x is valid
# Regresses onto the fourier frequencies which correspond to the
# sample period over which there is good data as if it were sampled evenly
# returns those values whose regression coefficients are significantly distinct from zero
#
# win --- is the choice of windowing function
# win = 'sinw' uses the sine window (equivalent to band averaging two neighboring bands)
#  sin(pi*(tgood-min(tgood))/GoodPeriod);
#
# win = 'cosw' uses the cosine or Hann window (band averaging over 3 bands)
#  (.5-cos(2*pi*(tgood-min(tgood))/GoodPeriod));
#
# case 'cos2w' uses a double cosine window (band averagin vers 5 bands)
#  xwin = xgood.*(3-4*cos(2*pi*(tgood-min(tgood))/GoodPeriod)+cos(4*pi*(tgood-min(tgood))/GoodPeriod))/8;
#
# otherwise no windowing function is used
#  
#
#
#
#
#
idxgood = find(~isnan(x));
xgood = x(idxgood);
tgood = t(idxgood);
Ngood = length(idxgood);
clear idxgood;
#for testing only do the first 16 points
# this will be deleted later
#if(Ngood>32)
# xgood = xgood(1:32);
# tgood = tgood(1:32);
# Ngood=32;
#end
errratio = 2;
GoodPeriod = (max(tgood)-min(tgood))*(Ngood/(Ngood+1));
df = 1/(GoodPeriod);
switch(win)
 case 'sinw'
  xwin = xgood.*sin(pi*(tgood-min(tgood))/GoodPeriod);
 case 'cosw'
  xwin = xgood.*(.5-cos(2*pi*(tgood-min(tgood))/GoodPeriod));
 case 'cos2w'
  xwin = xgood.*(3-4*cos(2*pi*(tgood-min(tgood))/GoodPeriod)+cos(4*pi*(tgood-min(tgood))/GoodPeriod))/8;
 otherwise
  xwin = xgood;
end
f = (1:floor((Ngood-1)/2))*df;
fgood = [];
ftest = [];
for i=1:length(f)
 ftest = [fgood,f(i)];
 Ntest = length(ftest);
 [A,dA] = harmonicfit(xwin,tgood,ftest);
 Fxtest = A(2*Ntest)+I*A(2*Ntest-1);
 dFxtest = dA(2*Ntest)+I*dA(2*Ntest-1);
 if((~isnan(Fxtest))&&(abs(2*dFxtest./Fxtest)<errratio/2));
   Fx = [I*A(1:2:2*Ntest)+A(2:2:2*Ntest)];
   dFx = [I*dA(1:2:2*Ntest)+dA(2:2:2*Ntest)];
   idxok = find(abs(dFx./Fx)<errratio);
   fgood = ftest(idxok);
 end
end
Nf = length(fgood);
figure(1)
[A,dA,xfit,err] = harmonicfit(xwin,tgood,fgood);
Fx = [I*A(1:2:2*Nf)+A(2:2:2*Nf)];
dFx = [I*dA(1:2:2*Nf)+dA(2:2:2*Nf)];

