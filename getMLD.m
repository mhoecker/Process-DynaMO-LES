function [MLD,MLI,drho,rho,DRHO]=getMLD(S,T,Z,DRHO)
 if(nargin<4)
  DRHO=0.125;
 end%if
 vardims = size(T);
 zdim = find(vardims==length(Z));
 tdim = find(vardims!=length(Z));
 ZZ = ones(vardims).*Z';
 findgsw;
 findgsw;
 g = gsw_grav(0);
 % Calculate pressure
 P = gsw_p_from_z(Z,0);
 % Calculate Absolute Salinity
 SA = gsw_SA_from_SP(S,P,0,0);
 % Calculate Conservative Temperature
 CT = gsw_CT_from_t(SA,T,P);
 % Calculate density(S,T,Z)
 rho = gsw_rho(SA,CT,P);
 %rhobar = nanmean(nanmean(rho,2))
 drho = (rho.-min(rho,[],zdim));
 badidx = find(drho>DRHO);
 ZZ(badidx) = 0;
 MLD = min(ZZ,[],zdim);
 MLI=MLD;
 for i=1:length(MLD)
  MLI(i) = find(Z==MLD(i),1);
 end%for
end%
