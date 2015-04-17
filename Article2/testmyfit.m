# Test using fit
ncdir = "/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/";
ncroot = [ncdir "MIMOC_Z_GRID_v2.2_CT_SA_month"];
outdir = "/home/mhoecker/work/Dynamo/plots/MIMOC/";
prefix = "tanhfits";
dir = plotparam(outdir,prefix)
outdat  = [dir.dat prefix];
pofz = @(z,p) p(1)*tanh((z-p(2))/abs(p(3)))+p(4);
# p = Delta/2 , Zmid , DZ/2, AVG
pT0 = [8,-100,30,20];
pS0 = [1,-100,20,30];
Niter = 25;
SumTol = 7e-3;
Dwt = 300;
for i=1:12
 ncfile = [ncroot num2str(i,"%02i") "_new.nc"];
 datsfx = [num2str(i,"%02i") ".dat"];
 nc = netcdf(ncfile,'r');
 lat = nc{"LATITUDE"}(:);
 lon = nc{"LONGITUDE"}(:)';
 idxeq = find(lat==0);
 Z = squeeze(nc{"Z"}(:,idxeq))';
 T = squeeze(nc{"CONSERVATIVE_TEMPERATURE"}(:,idxeq,:));
 Tfit = T;
 S = squeeze(nc{"ABSOLUTE_SALINITY"}(:,idxeq,:));
 Sfit = S;
 ncclose(nc);
 pT = NaN+zeros(length(pT0),length(lon));
 pS = NaN+zeros(length(pS0),length(lon));
 for j=1:length(lon);
  idxgood = find((~isnan(T(:,j).*S(:,j))));
  Tgood = T(idxgood,j);
  Sgood = S(idxgood,j);
  Zgood = Z(idxgood);
  if(length(Zgood)>20)
   pTj = pT0;
   pTj(4) = mean(Tgood);
   pTj(1) = (max(Tgood)-min(Tgood))/2;
   [Tj,pTj,cvg]=leasqr(Zgood,Tgood',pTj,pofz,SumTol,Niter,exp(Zgood/Dwt));
   if(cvg==0)
    pTj=pTj*NaN;
   end%if
   %
   pSj = pS0;
   pSj(4) = mean(Sgood);
   pSj(1) = (max(Sgood)-min(Sgood))/2;
   [Sj,pSj,cvg]=leasqr(Zgood,Sgood',pSj,pofz,SumTol,Niter,exp(Zgood/Dwt));
   if(cvg==0)
    pSj=pSj*NaN;
   end%if
  else
   pTj = NaN*pT0;
   pSj = NaN*pS0;
  end%if
  pT(:,j)= pTj;
  pS(:,j)= pSj;
 end%for
 pT(3,:) = abs(pT(3,:));
 pS(3,:) = abs(pS(3,:));
 # 3 sigma filter
 ptbad  = find((pT(2,:)<-2000)|(pT(2,:)>0)|(abs(pT(3,:))>2000));
 pT(:,ptbad) = NaN;
 ptgood = find(~isnan(pT(1,:)));
 ptmean = mean(pT(:,ptgood),2);
 ptstd  = std(pT(:,ptgood),0,2);
 pt3sig = find(abs(pT-ptmean)>3*ptstd);
 pT(pt3sig) = NaN;
 # 3 sigma filter of S fit
 psbad  = find((pS(2,:)<-2000)|(pS(2,:)>0)|(abs(pS(3,:))>2000)|(pS(4,:)<0)|(abs(pS(1,:))>pS(4,:)));
 pS(:,psbad) = NaN;
 psgood = find(~isnan(pS(1,:)));
 psmean = mean(pT(:,psgood),2);
 psstd  = std(pT(:,psgood),0,2);
 ps3sig = find(abs(pS-psmean)>3*psstd);
 pS(ps3sig) = NaN;
 # Calulate fit profiles
 for j=1:length(lon)
  if(~isnan(pT(1,j)))
   Tfit(:,j) = pofz(Z,pT(:,j));
  end%if
  if(~isnan(pS(1,j)))
   Sfit(:,j) = pofz(Z,pS(:,j));
  end%if
 end%for
 binarray(lon,pT,[outdat "Tfitparams" datsfx]);
 binarray(lon,pS,[outdat "Sfitparams" datsfx]);
 binmatrix(lon,Z,Tfit,[outdat "Tfit" datsfx]);
 binmatrix(lon,Z,Sfit,[outdat "Sfit" datsfx]);
end%for
