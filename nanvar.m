function thevar = nanvar(hasnan,dim)
 if(nargin<2)
  dim=1;
 end%if
 nonan = hasnan;
 Ntot = size(hasnan)(dim);
 Nnan = sum(isnan(hasnan),dim);
 [themean,idxnan] = nanmean(hasnan,dim);
 nonan(idxnan) = themean;
 diffsq = (nonan-themean).^2;
 thevar = sum(diffsq,dim)./(Ntot-Nnan)
 diffsq = diffsq.-thevar;
 diffsq(idxnan) = 0;
 thevar = thevar+sum(diffsq,dim)./(Ntot-Nnan-1)
end%function
