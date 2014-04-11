function idx = inclusiverange(variable,limits)
%function idx = inclusiverange(variable,limits)
% returns the range of indecies closest to the limits
% if no limits are given it returns the entire range
 if(nargin<2)
  limits = [min(variable),max(variable)];
 end%if
  a=(abs(variable-min(limits)));
  b=(abs(variable-max(limits)));
  abidx = sort([find(a==min(a),1),find(b==min(b),1)]);
  idx = abidx(1):abidx(2);
end%function
