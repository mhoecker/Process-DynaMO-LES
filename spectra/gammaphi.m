function [gamsq,gamc,favg,phi,dphi,fphi] = gammaphi(Sxy,Sx,Sy,f,bands,conf)
 % Band average
 [Sxavg,favg,dof] = bandavg(Sx,f,bands);
 Syavg = bandavg(Sy,f,bands);
 Sxyavg = bandavg(Sxy,f,bands);
 % calculate gamma squared
 gamsq = Sxyavg.*conj(Sxyavg)./(Sxavg.*Syavg);
 % calculate the Fischer's F distribution
 q = finv(conf,2,dof-2);
 % find the critical value
 gamc = 2*q/(dof-2+2*q);
 % calculate the significant phases
 idx = find(gamsq>=gamc);
 phi = atan2(imag(Sxyavg(idx)),real(Sxyavg(idx)));
 dphi = (2*q/(dof-2))*(1-gamsq(idx))./(gamsq(idx));
 dphi = sqrt(dphi);
 dphi = asin(dphi);
 fphi = favg(idx);
endfunction
