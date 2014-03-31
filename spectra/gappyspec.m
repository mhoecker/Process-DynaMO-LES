function [Fx,dFx,f,xfit,err] = gappyspec(x,t,win)
# function [Fx,dFx,f,tgood,xgood,xfit,err] = gappyspec(x,t)
# Calculate the Fourier Transform of a gappy time series
# 
# Exrtacts a list of points where x is valid
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
N = length(t);
idxgood = find(~isnan(x));
Ngood = length(idxgood);
Period = (max(t)-min(t))*(N/(N+1));
df = 1/(Period);
f = (1:floor((Ngood-1)/2))*df;
# Initialize the output arrays to NaN
Fx = f*NaN;
dFx = f*NaN;
xfit = x*NaN;
errratio = .25;
# Initialize empty arrays for fitting frequencies
fgood = [];
ftest = [];
# Sucessively add frequencies to the fit
for i=1:length(f)
# add sucessfull frequencies and the next frequency to be tested
 ftest = [fgood,f(i)];
 Ntest = length(ftest);
# Fit the current canidate list of frequencines
 [A,dA] = harmonicfit(x,t,ftest,win);
 Fxtest = A(2*Ntest)+I*A(2*Ntest-1);
 dFxtest = dA(2*Ntest)+I*dA(2*Ntest-1);
# Check if the current canidate is significant
 if((~isnan(Fxtest))&&(abs(2*dFxtest./Fxtest)<errratio/2));
# Check if the previously good frequencies are still significant
   Fxgood = [A(2:2:2*Ntest)-I*A(1:2:2*Ntest)]/2;
   dFxgood = [dA(2:2:2*Ntest)-I*dA(1:2:2*Ntest)]/2;
   idxok = find(abs(dFxgood./Fxgood)<errratio);
# Place surviving frequencies in the known good array
   fgood = ftest(idxok);
 else
 end
end
Nf = length(fgood);
[A,dA,xfit,err] = harmonicfit(x,t,fgood,win);
Fxgood = [A(2:2:2*Nf)-I*A(1:2:2*Nf)]/2;
dFxgood = [dA(2:2:2*Nf)-I*dA(1:2:2*Nf)]/2;
# Add NaNs for 'bad' frequencies
for i=1:length(fgood)
 idxfill = find(f==fgood(i));
 Fx(idxfill) = Fxgood(i);
 dFx(idxfill) = dFxgood(i);
end

