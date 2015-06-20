function profile = pofz(z,p)
 profile = p(1)*tanh((z-p(2))/abs(p(3)))+p(4);
end%function
