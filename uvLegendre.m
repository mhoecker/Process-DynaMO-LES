function [Ulpcoef,Vlpcoef,Uhcoef,Vhcoef,z] = uvLegendre(adcpfile,wantdate,max_depth,order)
 nc = netcdf(adcpfile,"r");
 t = nc{'t'}(:);
 dateidx = find(abs(t-wantdate)==min(abs(t-wantdate)),1);
 dateused  = t(dateidx);
 clear t;
 U = squeeze(nc{'ulp'}(dateidx,:));
 V = squeeze(nc{'vlp'}(dateidx,:));
 z = abs(nc{'z'}(:));
 if(nargin<3)
  max_depth = max(abs(z));
 end%if
 good = (isnan(U)==0)&(isnan(V)==0)&(abs(z')<=abs(max_depth));
 idxgood = find(good);
 clear U V z
 z = abs(nc{'z'}(idxgood));
 Ulp = nc{'ulp'}(dateidx,idxgood);
 Vlp = nc{'vlp'}(dateidx,idxgood);
 Uh = nc{'uhp'}(dateidx,idxgood);
 Vh = nc{'vhp'}(dateidx,idxgood);
 ncclose(nc);
 [z,reidx] = sort(z,'ascend');
 Ulp = Ulp(reidx);
 Vlp = Vlp(reidx);
 Uh = Ulp(reidx);
 Vh = Vlp(reidx);
 if(min(z)>0)
  imin = find(z==min(z));
  z = [0,z'];
  Ulp = [Ulp(imin),Ulp];
  Vlp = [Vlp(imin),Vlp];
  Uh = [Uh(imin),Uh];
  Vh = [Vh(imin),Vh];
 end%if
 if(nargin<4)
  order = 9;
 end%if
 Ulpcoef = fitLegendre(z,Ulp,order);
 Vlpcoef = fitLegendre(z,Vlp,order);
 Uhcoef = fitLegendre(z,Uh,order);
 Vhcoef = fitLegendre(z,Vh,order);
end%function
