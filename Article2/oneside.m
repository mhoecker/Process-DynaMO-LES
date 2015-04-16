function [P1,Pm,Pp] = oneside(P)
 N = length(P);
 N0 = floor(N/2)+1;
 P1 = P(N0+1:end);
 Pp = P1;
 Pm = Pp;
 for i=1:N-N0
  Pm(i) = P(N0-i);
  P1(i) = Pp(i) + Pm(i);
 end%for
end%function
