function y = csqfil(x,t,s,T)
 if(nargin==0)
  harmfill(0,0,0,0,4,"csqfill")
  y = NaN;
 else
  y = harmfill(x,t,s,T,4);
 end%if
end%function
