function idx = inclusiverange(variable,limits)
  a=(abs(variable-min(limits)));
  b=(abs(variable-max(limits)));
  abidx = sort([find(a==min(a),1),find(b==min(b),1)]);
  idx = abidx(1):abidx(2);
end%function
