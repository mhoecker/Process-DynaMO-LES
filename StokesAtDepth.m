function [Sz,dSdz] = StokesAtDepth(S0,waveL,z)
 k  = 2*pi./waveL;
 Sz = exp(2.*k.*z);
 dSdz = Sz.*(2*k.*S0);
end%function
