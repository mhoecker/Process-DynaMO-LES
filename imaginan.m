function Y = imaginan(X)
% convert all NaNs into imaginary numbers
% if(NaN) set = I
%
 Y = X;
 idxnan = find(isnan(X));
 Y(idxnan) = I;
end%function
