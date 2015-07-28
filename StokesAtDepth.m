function [Sz,dSdz] = StokesAtDepth(S0,waveL,z)
 k  = 2*bsxfun(@rdivide,pi,waveL);
 Sz = exp(2.*bsxfun(@times,k,z));
 dSdz = 2*bsxfun(@times,k,S0);
 dSdz = bsxfun(@times,Sz,dSdz);
end%function
