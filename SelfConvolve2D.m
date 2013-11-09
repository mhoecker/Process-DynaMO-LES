function AstarA = SelfConvolve2D(A,w,k)
 # Assumes
 #w is a one sided interval with equal spacing
 #k is an even intervals with equal spacing
 dw = abs(mean(diff(w)));
 dk = abs(mean(diff(k)));
 Nk = length(k);
 AstarA = zeros(size(A));
 for i = 1:length(w)
  for j = 1:length(k)
   for i2 = 1:length(w)
    for j2 = 1:length(k)
     # w2>0
     w2 = w(i)-w(i2);
     k2 = k(j)-k(j2);
     i3 = find(w==w2,1);
     j3 = find(k==k2,1);
     if(length(i3).*length(j3)!=0)
      dAstarA = dw*dk*A(i2,j2)*A(i3,j3);
      if(dAstarA!=0)
       AstarA(i,j) = AstarA(i,j)+dAstarA;
      end%if
     end%if
     #w2<0
     w2 = w(i)+w(i2);
     k2 = k(j)+k(j2);
     i3 = find(w==w2,1);
     j3 = find(k==k2,1);
     if(length(i3).*length(j3)!=0)
      dAstarA = dw*dk*A(i2,j2)*A(i3,j3);
      if(dAstarA!=0)
       %[i,j;i2,j2;i3,j3]
       %[w(i),k(j);w(i2),k(j2);w(i3),k(j3)]
       AstarA(i,j) = AstarA(i,j)+dAstarA;
      end%if
     end%if
    end%for
   end%for
  end%for
 end%for
end%function
