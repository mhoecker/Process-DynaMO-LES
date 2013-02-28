function [Pavg,favg,DOF]=bandavg(P,f,M)
 N = length(f);
 m = floor((M-1)/2);
 w = 2*m+1;
 DOF = 2*w;
 [fsort,idx] = sort(f);
 Psort = P(idx);
 favg = [];
 Pavg = [];
 if(min(f)>0)
  for j=(1+w):w:N+1
   Pavg = [Pavg,mean(Psort(j-w:j-1))];
   favg = [favg,mean(fsort(j-w:j-1))];
  endfor
 else
  zidx = find(fsort==0);
  for j=1:w:zidx-2+mod(N,2)-w
   Pavg = [Pavg,mean(Psort(zidx-j-w+1:zidx-j))];
   favg = [favg,mean(fsort(j:j+w-1))];
  endfor
  for j=(zidx+1+w):w:N+1
   Pavg = [Pavg,mean(Psort(j-w:j-1))];
   favg = [favg,mean(fsort(j-w:j-1))];
  endfor
 endif
endfunction
