function themean = nanmean(hasnan,dim)
 if(nargin<2)
  dim=1;
 end%if
 nonan = hasnan;
 Ntot = size(hasnan)(dim);
 Nnan = sum(isnan(hasnan),dim);
 if(Nnan>0)
  nonan(find(isnan(hasnan))) = 0 ;
 end%if
 themean = sum(nonan,dim)./(Ntot-Nnan);
end%function
