function [Pa,ka,la]=twodba(P,k,l,Xstride,Ystride)
 k0idx = find(k==0);
 l0idx = find(l==0);
 la=[];
 Pya = [];
 for i=(l0idx-1):-Ystride:Ystride
  la = [mean(l((1+i-Ystride):i)),la];
  Pya = [mean(P((1+i-Ystride):i,:),1);Pya];
 end%for
 Pya = [Pya;P(l0idx,:)];
 la = [la,0];
 for i=(l0idx+1):Ystride:(length(l)+1-Ystride)
  la = [la,mean(l(i:(i+Ystride-1)))];
  Pya = [Pya;mean(P(i:(i-1+Ystride),:),1)];
 end%for
 Pa = [];
 ka = [];
 for j=(k0idx-1):-Xstride:(Xstride)
  ka = [mean(k((1+j-Xstride):j)),ka];
  Pa = [mean(Pya(:,(1+j-Xstride):j),2),Pa];
 end%for
 Pa = [Pa,Pya(:,k0idx,:)];
 ka = [ka,0];
 for j=(k0idx+1):Xstride:(length(k)+1-Xstride)
  ka = [ka,mean(k(j:(j-1+Xstride)))];
  Pa = [Pa,mean(Pya(:,j:(j-1+Xstride)),2)];
 end%for
end%function
