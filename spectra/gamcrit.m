function gamc = gamcrit(conf,dof)
 q = finv(conf,2,dof-2);
 gamc = 2*q/(dof-2-2*q);
endfunction
