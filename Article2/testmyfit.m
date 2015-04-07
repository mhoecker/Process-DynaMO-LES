# Test using fit
pofz = @(z,p) p(1)*tanh((z-p(2))/p(3))+p(4)*exp(z/p(5));
x = -1000:10:0;
p = [2,-100,30,20,1000];
T = pofz(x+(-.5+rand(size(x)))*mean(diff(x)),p);
[Tfit,pfit] = leasqr(x,T,p,pofz);
plot(T-Tfit,x);
