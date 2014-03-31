function gamc = gamcrit(conf,dof)
%function gamc = gamcrit(conf,dof)
% Calculate the critical coherence gamc
% given
% Confidence interval conf
% degrees of freedom dof
 q = finv(conf,2,dof-2);
 gamc = 2*q/(dof-2-2*q);
endfunction
