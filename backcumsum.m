function bsum = backcumsum(A,N)
 if (nargin()<2)
  bsum = sum(A)-cumsum(A)+A;
 else
  bsum = sum(A,N)-cumsum(A,N)+A;
 end%if
end%function
