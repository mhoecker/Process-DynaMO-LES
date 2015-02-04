function [MLD,MLI,drho,rho,DRHO]=getMLD(S,T,Z,DRHO,min)
 if(nargin<4)
  DRHO=0.01;
 end%if
 vardims = size(T);
 zdim = find(vardims==length(Z));
 tdim = find(vardims!=length(Z));
 ZZ = ones(vardims).*abs(Z)';
 findgsw;
 g = gsw_grav(0);
 % Calculate pressure
 P = gsw_p_from_z(Z,0);
 % Calculate Absolute Salinity
 SA = gsw_SA_from_SP(S,P,0,0);
 % Calculate Conservative Temperature
 CT = gsw_CT_from_t(SA,T,P);
 % Calculate density(S,T,Z)
 rho = gsw_rho(SA,CT,P*0);
 %rhobar = nanmean(nanmean(rho,2))
 nanidx = find(isnan(rho));
 ZZ(nanidx) = max(abs(Z));
 drho = rho;
 Zsfc = zeros(vardims(tdim),1);
 for i=1:vardims(tdim)
  if(zdim==1)
   rhoi=rho(:,i);
   nanidx= find(isnan(rhoi));
   Zgood = abs(Z);
   Zgood(nanidx) = max(Zgood);
   izsfc = find(Zgood==min(Zgood),1);
   Zsfc(i) = Zgood(izsfc);
   drho(:,i) = (rho(:,i).-rho(izsfc,i));
  else
   rhoi=rho(i,:);
   nanidx= find(isnan(rhoi));
   Zgood = abs(Z);
   Zgood(nanidx) = max(Zgood);
   izsfc = find(Zgood==min(Zgood));
   Zsfc(i) = Zgood(izsfc);
   drho(i,:) = (rho(i,:).-rho(i,izsfc));
  end%if
 end%for
 badidx = find(drho>DRHO);
 nanidx = find(isnan(drho));
 ZZ(badidx) = 0;
 ZZ(nanidx) = max(abs(Z));
 MLD = min(-ZZ,[],zdim);
 MLI=MLD;
 for i=1:length(MLD)
  MLI(i) = find(abs(Z)==-MLD(i),1);
 end%for
end%
