function AstarA = SelfConvolve2D(A,w,k)
 # Assumes
 #A is indexed so that A(i,j) = A[w(i),k(j)]
 #w is an interval with equal spacing
 #k is an interval with equal spacing
 dw = mean(diff(w));
 dk = mean(diff(k));
 dwdk = abs(dk*dw);
 Nk = length(k);
 Nw = length(w);
 wmin = min(w);
 wmax = max(w);
 kmax = max(k);
 kmin = min(k);
 AstarA = zeros(size(A));
 for i = 1:length(w)
  for j = 1:length(k)
   for i2 = 1:length(w)
    for j2 = 1:length(k)
     # w2>0
     w2 = w(i)-w(i2);
     i3 = 1+round((w2-wmin)/dw);
     if((i3>0)&&(i3<=Nw))
      k2 = k(j)-k(j2);
      j3 = 1+round((k2-kmin)/dk);
      if((j3>0)&&(j3<=Nk))
       dAstarA = dwdk*A(i2,j2)*A(i3,j3);
       AstarA(i,j) = AstarA(i,j)+dAstarA;
      end%if
     end%if
     #w2<0
     w2 = w(i)+w(i2);
     i3 = 1+round((w2-wmin)/dw);
     if((i3>0)&&(i3<=Nw))
      k2 = k(j)+k(j2);
      j3 = 1+round((k2-kmin)/dk);
      if((j3>0)&&(j3<=Nk))
       dAstarA = dwdk*A(i2,j2)*A(i3,j3);
       AstarA(i,j) = AstarA(i,j)+dAstarA;
      end%if
     end%if
    end%for
   end%for
  end%for
 end%for
end%function
