function y = csqfil(x,t,s,T)
 if(nargin==0)
  harmfill(0,0,0,0,4,"csqfill")
  y = NaN;
 else
  y = harmfill(x,t,s,4,T);
 end%if
end%function
