function [Px,dPx,f,xfit,err] = gappypsd(x,t,win)
# function [Px,dPx,f,xfit,err] = gappypsd(x,t,win)
# Calculate the 1-sided Power spectral density of a gappy time series
# 
# Regresses onto the fourier frequencies which correspond to the
# sample period over which there is good data as if it were sampled evenly
# returns those values whose regression coefficients are significantly distinct from zero
#
# win --- is the choice of windowing function
# win = 'sinw' uses the sine window (equivalent to band averaging two neighboring bands)
#  sin(pi*(t-min(t))/Period);
#
# win = 'cosw' uses the cosine or Hann window (band averaging over 3 bands)
#  (.5-cos(2*pi*(t-min(t))/Period));
#
# win = 'cos2w' uses a double cosine window (band averagin vers 5 bands)
#  xwin = xgood.*(3-4*cos(2*pi*(tgood-min(t))/Period)+cos(4*pi*(t-min(t))/Period))/8;
#
# otherwise no windowing function is used
#  
#
#
#
#
#
switch nargin()
 case 1
  t = 1:length(x);
  win='sinw';
 case 2
  win = 'sinw';
end
N = length(t);
Period = (max(t)-min(t))*(N/(N+1));
df = 1/(Period);
idxgood = find(~isnan(x));
Ngood = length(idxgood);
Nf = floor((Ngood-1)/2);
f = (1:Nf)*df;
# Initialize the output arrays to NaN
Fx = f*NaN;
dFx = f*NaN;
xfit = x*NaN;
errratio = 1;
# Initialize empty arrays for fitting frequencies
fgood = [];
relerr = [];
# Sucessively fit each freq individually, 
# calculate and store relative error
for i=1:length(f)
# Fit the current canidate frequency
 [A,dA] = harmonicfit(x,t,f(i),win);
 relerr = [relerr,abs((dA(2)-I*dA(1))/(A(2)-I*A(1)))];
end
[relerr,sortidx] = sort(relerr);
Nstop = min([Nf,find(relerr>errratio,1)]);
ftest =  f(sortidx);
xfit = 0*x;
for i=1:Nstop
# add the next frequency to be tested
# Fit the current canidate frequency to the remaining data
 [A,dA,dxfit] = harmonicfit(x-xfit,t,ftest(i),win);
 relerr = abs((dA(2)-I*dA(1))/(A(2)-I*A(1)));
 relerr = relerr*(Ngood-2)/(Ngood-2*i);
# Check if the current canidate is significant
 if((~isnan(relerr))&&(relerr<errratio));
# Place surviving frequencies in the known good array
  fgood = [fgood,ftest(i)];
  xfit = xfit+dxfit;
 end
end
fgood = sort(fgood);
Nfgood = length(fgood);
[A,dA,xfit,err] = harmonicfit(x,t,fgood,win);
Fxgood = [A(2:2:2*Nfgood)-I*A(1:2:2*Nfgood)]/2;
dFxgood = [dA(2:2:2*Nfgood)-I*dA(1:2:2*Nfgood)]/2;
# Replace NaNs for 'good' frequencies
for i=1:Nfgood
 idxfill = find(f==fgood(i));
 Fx(idxfill) = Fxgood(i);
 dFx(idxfill) = dFxgood(i);
end
Px = 2*abs(Fx.*conj(Fx))/df;
dPx = 4*abs(Fx).*abs(dFx)/df;
