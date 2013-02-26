function [SCamp,dSCamp,y,err] = harmonicfit(x,t,f)
idxgood = find(~isnan(x));
xgood = x(idxgood);
tgood = t(idxgood);
Ngood = length(idxgood);
clear idxgood
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
  SCval(i,2*j-1) = sin(2*pi*f(j)*t(i));
  SCval(i,2*j) = cos(2*pi*f(j)*t(i));
 end
end
SCvsq = SCval'*SCval;
[SCvsi,rcon] = inv(SCvsq);
if(rcon>eps*trace(SCvsi))
 SCamp = SCvsq\SCval'*xgood';
 y = SCamp'*SCval';
 err=xgood-y;
 sige = sum(err.*err)/(Ngood-2*Nf);
 dSCamp = sqrt(sige*diag(SCvsi)/Ngood);
else
 SCamp = NaN*ones(1,2*Nf);
 dSCamp = NaN*ones(1,2*Nf);
 err = NaN;
end

