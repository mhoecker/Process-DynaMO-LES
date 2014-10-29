function [Pm,Pp] = PSDuncert(ci,N)
# function [Pm,Pp] = PSDuncert(ci,N)
# Resturns the confidence interval of a sample power spectral density (PSD)
# which has been band averaged over N bands
# Assumes N is an integer greater than 0
# Assumes 0 < ci < 1
 lower = .5*(1-ci);
 %
 upper = 1-lower;
 %
 upper = chi2inv(upper,2*N)/(2*N);
 %
 lower = chi2inv(lower,2*N)/(2*N);
 %
 Pm = 1.0/upper;
 %
 Pp = 1.0./lower;
endfunction
