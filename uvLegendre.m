function [Ucoef,Vcoef] = uvLegendre(fileloc,adcpfile,wantdate,max_depth)
 ncfile = [fileloc adcpfile ".nc"];
 nc = netcdf(ncfile,"r");
 t = nc{'t'}(:);
 dateidx = find(abs(t-wantdate)==min(abs(t-wantdate)),1);
 dateused  = t(dateidx);
 clear t;
 U = nc{'ulp'}(dateidx,:);
 V = nc{'vlp'}(dateidx,:);
 z = abs(nc{'z'}(:));
 if(nargin<4)
  max_depth = max(abs(z));
 end%if
 good = (isnan(U)==0)&(isnan(V)==0)&(abs(z')<=max_depth);
 idxgood = find(good);
 clear U V z
 z = abs(nc{'z'}(idxgood));
 U = nc{'ulp'}(dateidx,idxgood);
 V = nc{'vlp'}(dateidx,idxgood);
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
 Ucoef = fitLegendre(z,U,9);
 Vcoef = fitLegendre(z,V,9);
end%function
