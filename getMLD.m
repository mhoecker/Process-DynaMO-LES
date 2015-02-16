function [MLD,MLI,drho,rho,DRHO]=getMLD(S,T,Z,DRHO)
 if(nargin<4)
  DRHO=0.01;
 end%if
 vardims = size(T);
 zdim = find(vardims==length(Z));
 tdim = find(vardims!=length(Z));
 ZZ = cumsum(ones(vardims),zdim);
 findgsw;
 g = gsw_grav(0);
 % Calculate pressure
 P = gsw_p_from_z(-abs(Z),0);
 % Calculate Absolute Salinity
 SA = gsw_SA_from_SP(S,P,0,0);
 % Calculate Conservative Temperature
 CT = gsw_CT_from_t(SA,T,P);
 % Calculate density(S,T,Z)
 rho = gsw_rho(SA,CT,0*P);
 %rhobar = nanmean(nanmean(rho,2))
 nanidx = find(isnan(rho));
 drho = rho;
 Zsfc = zeros(vardims(tdim),1);
 for i=1:vardims(tdim)
  if(zdim==1)
   rhoi=rho(:,i);
  else
   rhoi=rho(i,:);
  end%if
  nanidx= find(isnan(rhoi));
  goodidx= find(~isnan(rhoi));
  rhomin = min(rhoi(goodidx));
  Zgood = abs(Z);
  Zgood(nanidx) = max(Zgood);
  izsfc = find(Zgood<min(Zgood)+10);
  Zsfc(i) = min(Zgood(izsfc));
  if(zdim==1)
   drho(:,i) = (rho(:,i).-mean(rho(izsfc,i)));
  else
   drho(i,:) = (rho(i,:).-rhomin);
  end%if
 end%for
 badidx = find(drho>DRHO);
 nanidx = find(isnan(drho));
 ZZ(badidx) = NaN;
 ZZ(nanidx) = NaN;
 if(mean(diff(abs(Z)))>0)
  MLI = max(ZZ,[],zdim);
 else
  MLI = min(ZZ,[],zdim);
 end%if
 MLD=Z(MLI);
 %for i=1:length(MLD)
 % MLI(i) = find(abs(Z)==-MLD(i),1);
 %end%for
end%
