function [f,A] = bestf(x,t)
 # Build a nearly orthogonal set of sinusoids
 # over the points t where there is data in x and t
 idxgood = find((~isnan(t)).*(~isnan(x)));
 tgood = t(idxgood);
 Ngood = length(tgood);
 T = (max(t)-min(t))*(Ngood+1)/Ngood;
 f0 = 1/T;
 dferr = .01*f0/Ngood;
 f = [0];
 for i=1:floor((Ngood-1)/2)
  f1 = f(i)+f0;
  df = f0;
  badcount = 0;
  while((abs(df)>dferr))
   A1 = finderr(f,f1,tgood);
   DA = finderr(f,f1+dferr,tgood)-finderr(f,f1-dferr,tgood);
   df = -2*dferr*A1/DA;
   if(abs(df)>f0/2)
    badcount = badcount+1;
    if(badcount>10)
     df = 0;
    else
     df = sign(df)*2*dferr;
    end
   end
   f1 = f1+df;
  end
  f = [f,f1];
 end
 f = f(2:length(f));
 A = 0*f;
 for i=1:length(f)
  idx = find(f!=f(i));
  A(i) = finderr(f(idx),f(i),tgood);
 end
end

function A = finderr(flist,g,t)
 A = 0.0;
 z2 = exp(-2*pi*I*g*t);
 for i=1:length(flist)
  z1 = exp(2*pi*I*flist(i)*t);
  A = A+abs(z1*z2')^2;
  z1 = exp(-2*pi*I*flist(i)*t);
  A = A+abs(z1*z2')^2;
 end
 A = A/length(t);
end
