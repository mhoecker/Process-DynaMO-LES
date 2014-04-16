function [kr,Pr]=directionalSpec(theta,k,l,P)
 dk = mean(diff(k));
 dl = mean(diff(l));
 dkr = sqrt((dk*cos(theta))^2+(dl*sin(theta))^2);
 rhat = [cos(theta),sin(theta)];
 kraw = [];
 Praw = [];
 [kk,ll] = meshgrid(k,l);
 kmag = sqrt(kk.^2+ll.^2);
 delta = 0.125*dkr/max(max(kmag));
 kdot = kk*rhat(1)+ll*rhat(2);
 dtheta = (1-kdot./kmag);
 goodidx = find(dtheta<delta);
 Praw = P(goodidx);
 kraw = kdot(goodidx);
 [kraw,idx] = sort(kraw);
 Praw = Praw(idx);
 kr = min(kraw):dkr:max(kraw);
 Pr = harmfill(Praw,kraw,kr,1);
end%function

function [k,l,P]=loadspec(file)
 fid = fopen([file,'.dat'],'r');
 N = fread(fid,1,'float');
 k = fread(fid,N,'float');
 l = [];
 P = [];
 while(~feof(fid))
  l = [l;fread(fid,1,'float')];
  P = [P;fread(fid,[1,N],'float')];
 end%while
 fclose(fid);
end%function
