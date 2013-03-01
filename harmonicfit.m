function [SCamp,dSCamp,y,err] = harmonicfit(x,t,f,win)
y = x*NaN;
N = length(t);
dt = mean(diff(t));
idxgood = find(~isnan(x));
xgood = x(idxgood);
mu = mean(xgood);
xgood = xgood-mu;
tgood = t(idxgood);
Ngood = length(idxgood);
Period = (max(t)-min(t))*(N/(N+1));
clear idxgood
switch(win)
 case 'sinw' # window using a sine function (jump rolls off like f^-2)
  w = sin(pi*(tgood+dt/2-min(tgood))/Period);
 case 'cosw' #window usind a hann window (jump rolls off like f^-4)
  w = (.5-cos(2*pi*(tgood+dt/2-min(tgood))/Period));
 case 'sin2w'# window using two sine functions (jump rolls off like f^-6)
  w = (.75*sin(pi*(tgood+dt/2-min(tgood))/Period)-.25*sin(3*pi*(tgood+dt/2-min(tgood))/Period));
 case 'cos2w'#window using three cosine functions (jump rolls off like f^-8)
  w = (3-4*cos(2*pi*(tgood+dt/2-min(tgood))/Period)+cos(4*pi*(tgood+dt/2-min(tgood))/Period))/8;
 otherwise
  w = ones(size(xin));
end
# window the data
nowinvar = var(xgood,1);
xgood = w.*xgood;
scale = nowinvar./var(xgood,1);
xgood = scale*xgood;

if(size(xgood)(1)!=1)
xgood = xgood';
end
if(size(xgood)(1)!=1)
tgood = tgood';
end
Nf =length(f);
Nt = length(tgood);
SCval = zeros(Nt,2*Nf);
for i=1:Nt
 for j=1:Nf
  SCval(i,2*j-1) = sin(2*pi*f(j)*tgood(i));
  SCval(i,2*j) = cos(2*pi*f(j)*tgood(i));
 end
end
SCvsq = SCval'*SCval;
if(abs(det(SCvsq))>eps*trace(SCvsq))
 SCvsi = inv(SCvsq);
 SCamp = SCvsq\SCval'*xgood';
 ygood = SCamp'*SCval';
 err=xgood-ygood;
 sige = sum(err.*err)/(Ngood-2*Nf);
 dSCamp = sqrt(sige*diag(SCvsi)/Ngood);
 for i=1:length(tgood)
  idxfill = find(t==tgood(i));
  y(idxfill) = (ygood(i)/scale+mu);
 end
else
 SCamp = NaN*ones(1,2*Nf);
 dSCamp = NaN*ones(1,2*Nf);
 err = NaN;
end

