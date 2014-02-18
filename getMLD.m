function [MLD,MLI,drho,rho]=getMLD(S,T,Z,DRHO)
 if(nargin<4)
  DRHO=0.01;
 end%if
 vardims = size(T);
 zdim = find(vardims==length(Z));
 tdim = find(vardims!=length(Z));
 ZZ = ones(vardims).*Z';
 findgsw;
 rho = gsw_rho(S,T,0);
 drho = (rho.-min(rho,[],zdim));
 badidx = find(drho>DRHO);
 ZZ(badidx) = 0;
 MLD = min(ZZ,[],zdim);
 MLI=MLD;
 for i=1:length(MLD)
  MLI(i) = find(Z==MLD(i),1);
 end%for
end%
