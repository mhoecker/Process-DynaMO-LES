function [P,k,w] = simeqwaves(krange,wrange)
 findgsw;
 dk = min(abs(krange));
 kmax = max(abs(krange));
 k = -kmax:dk:kmax;
 #
 dw = min(abs(wrange));
 wmax = max(abs(wrange));
 w = 0:dw:wmax;
 wmag = 16;
 wfind = 0:dw/wmag:wmax+dw;
 #
 [kk,ww] = meshgrid(k,w);
 P = zeros(size(kk));
 g = gsw_grav(0);
 c = sqrt(g*60);
 # extract the Kelvin, Yanai, Rossby, and Poincare wave even modes
 kcells = eqwavenum(wfind,c,[0,2]);
 Pin = P;
 # find the cells which contain the dispersion relation
 for i=1:length(kcells)
  for j=1:length(w)
   for l=1:length(k)
    for m=1+wmag*(j-1):wmag*j
     if (wfind(m)-w(j)>dw)
      [j,w(j),m,wfind(m)]
     end%if
     if(abs(kcells{i}(m)-k(l))<=dk/2)
      Pin(j,l)=1;
     end%if
    end%for
   end%for
  end%for
 end%for
 #Magically turn the number of modes into a dpectral density
 binmatrix(k,w,Pin,'/home/mhoecker/tmp/eqwaves.dat');
 P = SelfConvolve2D(sqrt(Pin),w,k).^2;
 #P = Pin;
 binmatrix(k,w,P,'/home/mhoecker/tmp/eqwaves2.dat');
 if(length(k)*length(w)<2^5)
  subplot(1,2,1)
  pcolor(kk,ww,exp(log(Pin))); shading flat
  axis([-kmax,kmax,0,wmax])
  caxis([0,1])
  xlabel("wavenumber (rad/m)")
  ylabel("frequency (rad/s)")
  subplot(1,2,2)
  pcolor(kk,ww,exp(log(P))); shading flat
  axis([-kmax,kmax,0,wmax])
  xlabel("wavenumber (rad/m)")
  ylabel("frequency (rad/s)")
  print('/home/mhoecker/tmp/eqwave.png','-dpng')
 end%if
end%function
