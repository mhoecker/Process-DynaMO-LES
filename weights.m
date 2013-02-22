function [w1,w2] = weights(t,t1,t2)

 if(t1<t2)
  x = (t-t1)/(t2-t1);
  w1 = 1-x;
  w2 = x;
 elseif(t2<t1)
  x = (t-t2)/(t1-t2);
  w2 = 1-x;
  w1 = x;
 else
  w1=.5;
  w2=.5;
  x = NaN;
 endif
endfunction

function y = H(x)
 y = (sign(x)+1)/2;
endfunction
