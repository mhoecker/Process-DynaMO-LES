function [themean,idxnan] = nanmean(hasnan,dim)
% Calculate mean of data with nan's
 if(nargin<2)
  dim=1;
 end%if
 nonan = hasnan;
 Ntot = size(hasnan)(dim);
 Nnan = sum(isnan(hasnan),dim);
 if(Nnan>0)
  idxnan = find(isnan(hasnan));
 else%if
  idxnan = [];
 end%if
 nonan(idxnan) = 0 ;
 themean = sum(nonan,dim)./(Ntot-Nnan);
 nonan = nonan-themean;
 nonan(idxnan) = 0 ;
 themean = themean+sum(nonan,dim)./(Ntot-Nnan);
end%function
