function [fp,fm] = aliaser(f,dt)
%function [fp,fm] = aliaser(f,dt)
% Finds the frequency to which a real signal of frequency f
% is aliased by sampling at interval dt
% returns the positive fp and negative values fm
%
%
 fp = abs(f);
 %f_j = f + 2*j*fnyq
 %|fa| < fnyq
 %
 %|f+2*j*fnyq| < fnyq
 %|f/fnyq+2*j| < 1
 %
 % |f/fny|+2*j < 1
 % j < (1-|f/fny|)/2
 if(fp>.5/dt)
  j = floor(.5-fp*dt);
  fp = abs(fp*dt+j)/dt;
 endif
 fm = -fp;
endfunction
