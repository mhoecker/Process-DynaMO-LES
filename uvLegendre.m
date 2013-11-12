function [Ucoef,Vcoef,Ufit,Vfit,z,U,V] = uvLegendre(adcpfile,wantdate,max_depth,avgtime,order,varnames)
 % Set Default values for dimnames and varnames
 if nargin()<5
  varnames = ["t";"z";"u";"v"];
 end%if
 nc = netcdf(adcpfile,"r");
 t = nc{deblank(varnames(1,:))}(:);
 dateidx = find(abs(t-wantdate)<avgtime,1);
 dateused  = mean(t(dateidx));
 clear t;
 z = abs(nc{deblank(varnames(2,:))}(:));
 U = nanmean(nc{deblank(varnames(3,:))}(dateidx,:),1);
 V = nanmean(nc{deblank(varnames(4,:))}(dateidx,:),1);
 if(nargin<3)
  max_depth = max(abs(z));
 end%if
 good = (isnan(U)==0)&(isnan(V)==0)&(abs(z')<=abs(max_depth));
 idxgood = find(good);
 z = z(idxgood);
 U = U(idxgood);
 V = V(idxgood);
 ncclose(nc);
 [z,reidx] = sort(z,'ascend');
 U = U(reidx);
 V = V(reidx);
 if(min(z)>0)
  imin = find(z==min(z));
  z = [0,z'];
  U = [U(imin),U];
  V = [V(imin),V];
 end%if
 if(nargin<4)
  order = 9;
 end%if
 [Ucoef,Ufit] = fitLegendre(z,U,order);
 [Vcoef,Vfit] = fitLegendre(z,V,order);
end%function
