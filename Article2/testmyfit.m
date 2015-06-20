# Test using fit
Obsdir   = "/home/mhoecker/work/Dynamo/Observations/netCDF";
MIMOCdir = [Obsdir "/MIMOC/"];
ncroot   = [MIMOCdir "MIMOC_Z_GRID_v2.2_CT_SA_month"];
Unc      = [Obsdir "/monthly/RAMA_TAO.nc"];
outdir   = "/home/mhoecker/work/Dynamo/plots/MIMOC/";
prefix   = "tanhfits";
dir = plotparam(outdir,prefix);
outdat  = [dir.dat prefix];
findgsw;
% Move to it's ownm function so Velocity can use it too
%pofz = @(z,p) p(1)*tanh((z-p(2))/abs(p(3)))+p(4);
% p = Delta/2 , Zmid , DZ/2, AVG
pT0 = [8,-100,40,20];
pS0 = [.5,-100,20,35];
Niter = 25;
SumTol = 7e-3;
Dwt = -350;
for i=1:12
 ncfile = [ncroot num2str(i,"%02i") "_new.nc"];
 datsfx = [num2str(i,"%02i") ".dat"];
 nc = netcdf(ncfile,'r');
 lat = nc{"LATITUDE"}(:);
 lon = nc{"LONGITUDE"}(:)';
 idxeq = find(lat==0);
 Z = squeeze(nc{"Z"}(:,idxeq))';
 zidx = find(Z>Dwt);
 Z = squeeze(nc{"Z"}(zidx,idxeq))';
 T = squeeze(nc{"CONSERVATIVE_TEMPERATURE"}(zidx,idxeq,:));
 Tfit = T;
 S = squeeze(nc{"ABSOLUTE_SALINITY"}(zidx,idxeq,:));
 Sfit = S;
 ncclose(nc);
 pT = NaN+zeros(length(pT0)+1,length(lon));
 pS = NaN+zeros(length(pS0)+1,length(lon));
 for j=1:length(lon);
  idxgood = find((~isnan(T(:,j).*S(:,j))));
  Tgood = T(idxgood,j);
  Sgood = S(idxgood,j);
  Zgood = Z(idxgood);
  if(length(Zgood)>20)
   dz = (max(Zgood)-min(Zgood))/length(Zgood);
   Wt = sqrt(1-(Zgood./Dwt).^2);
   pTj = pT0;
   pTj(4) = mean(Tgood);
   pTj(1) = (Tgood(1)-Tgood(end))/(2*sign(Zgood(1)-Zgood(end)));
   if(pTj(1)==0)
    pTj(1) = (max(Tgood)-min(Tgood))/2;
   end%if
   [Tj,pTj,cvg]=leasqr(Zgood,Tgood',pTj,"pofz",SumTol,Niter,Wt);
   if(cvg==0)
    pTj=pTj*NaN;
    "Temperature did not converge"
    [i,lon(j)]
   elseif((abs(pTj(3))<dz)||(pTj(2)>0)||(pTj(2)<Dwt)||(pTj(3)+Dwt>0)||(pTj(3)>-2*pTj(2)))
    pTj=NaN*pTj;
   end%if
   %
   pSj     = pS0;
   pSj(4)  = mean(Sgood);
   pSj(1)  = (Sgood(1)-Sgood(end))/(2*sign(Zgood(1)-Zgood(end)));
   if(pSj(1)==0)
    pSj(1) = (max(Sgood)-min(Sgood))/2;
   end%if
   [Sj,pSj,cvg]=leasqr(Zgood,Sgood',pSj,"pofz",SumTol,Niter,Wt);
   if(cvg==0)
    pSj=pSj*NaN;
    "Salinity did not converge"
    [i,lon(j)]
   elseif((abs(pSj(3))<dz)||(pSj(2)>0)||(pSj(2)<Dwt)||(pSj(3)+Dwt>0)||(pSj(3)>-2*pSj(2)))
    pSj=NaN*pSj;
   end%if
  else
   pTj = NaN*pT0;
   pSj = NaN*pS0;
  end%if
  % Calculate pressure at thermo- and halo-clines
  if((pTj(2)<0)&&(pSj(2)<0))
   Pbar   = gsw_p_from_z(pTj(2),0);
   Pbar   = (Pbar+gsw_p_from_z(pSj(2),0))/2;
  else
   Pbar = NaN;
  end%if
  Tbar   = pTj(4);
  Sbar   = pSj(4);
  % Check that mean values are in the "Oceanographic Funnel"
  if(gsw_infunnel(Sbar,Tbar,Pbar)==1)
   rhobar = gsw_rho(Sbar,Tbar,Pbar);
   drhoTj = rhobar*pTj(1)*gsw_alpha(Sbar,Tbar,Pbar);
   drhoSj = -rhobar*pSj(1)*gsw_beta(Sbar,Tbar,Pbar);
  % If not reject the fits
  else
   rhobar = NaN;
   drhoTj = NaN;
   drhoSj = NaN;
  end%if
  pT(1:4,j)= pTj;
  pT(5,j) = drhoTj;
  pS(1:4,j)= pSj;
  pS(5,j)= drhoSj;
 end%for
  pT(3,:) = abs(pT(3,:));
  pS(3,:) = abs(pS(3,:));
 % Calulate fit profiles
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
