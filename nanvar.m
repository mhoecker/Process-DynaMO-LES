function thevar = nanvar(hasnan,dim)
 if(nargin<2)
  dim=1;
 end%if
 nonan = hasnan;
 Ntot = size(hasnan)(dim);
 Nnan = sum(isnan(hasnan),dim);
 if(Nnan>0)
  nonan(find(isnan(hasnan))) = themean ;
 end%if
 themean = nanmean(hasnan,dim);
 thevar = sum((nonan-themean).^2,dim)./(Ntot-Nnan-1);
end%function
