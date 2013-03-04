function avgx = runavg(x,t,width)
%
%
%
 N = length(x);
 avgx = zeros(size(x));
 if(nargin==2)
  t = 1:N:1;
 endif
 for i=1:1:N
  idx = find((t>t(i)-width/2.)&(t<t(i)+width/2.));
  avgx(i)=mean(x(idx));
 endfor
endfunction
