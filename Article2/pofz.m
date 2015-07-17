function profile = pofz(z,p)
 if(nargin<2)
  profile = "p(1)*tanh((z-p(2))/abs(p(3)))+p(4)";
 else
  profile = p(1)*tanh((z-p(2))/abs(p(3)))+p(4);
 end%if
end%function
