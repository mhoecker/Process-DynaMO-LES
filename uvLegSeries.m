function [Ucoef,Vcoef,Ulcoef,Vlcoef,datesused,z] = uvLegSeries(fileloc,adcpfile,wantdates,max_order,max_depth)
 ncfile = [fileloc adcpfile ".nc"];
 nc = netcdf(ncfile,"r");
 t = nc{'t'}(:);
 if(max(wantdates)>min(wantdates));
  gooddays = (t>=min(wantdates))&(t<=max(wantdates));
 else
  gooddays = ones(size(t));
 end%if
 datesidx = find(gooddays);
 datesused  = t(datesidx);
 clear t gooddays;
 z = abs(nc{'z'}(:));
 if(nargin<4)
  max_order = floor(length(z)/2);
 end%if
 if(nargin<5)
  max_depth = max(abs(z));
 end%if
 goodz = (abs(z')<=max_depth);
 depthidx = find(goodz);
 clear U V z goodz;
 z = abs(nc{'z'}(depthidx));
 Ul = nc{'ulp'}(:);
 Ul = Ul(datesidx,depthidx);
 Vl = nc{'vlp'}(:);
 Vl = Vl(datesidx,depthidx);
 U = nc{'uhp'}(:);
 U = U(datesidx,depthidx);
 V = nc{'vhp'}(:);
 V = V(datesidx,depthidx);
 ncclose(nc);
 Ucoef = [];
 Vcoef = [];
 Ulcoef = [];
 Vlcoef = [];
 for i=1:length(datesused);
  good = (isnan(U(i,:))==0)&(isnan(V(i,:))==0)&(abs(z')<=max_depth);
  idxgood = find(good);
  Ucoef = [Ucoef;fitLegendre(z(idxgood)',U(i,idxgood),max_order)];
  Vcoef = [Vcoef;fitLegendre(z(idxgood)',V(i,idxgood),max_order)];
  good = (isnan(Ul(i,:))==0)&(isnan(Vl(i,:))==0)&(abs(z')<=max_depth);
  idxgood = find(good);
  Ulcoef = [Ulcoef;fitLegendre(z(idxgood)',Ul(i,idxgood),max_order)];
  Vlcoef = [Vlcoef;fitLegendre(z(idxgood)',Vl(i,idxgood),max_order)];
 end%for
end%function
