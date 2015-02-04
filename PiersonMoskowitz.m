function [wave,spectra,wind] = PiersonMoskowitz(U,t)
# Fake Pierson Moskowitz spectrum
#
alpha  = 8.10e-3;
beta   = 0.74;
# from NIST http://physics.nist.gov/cgi-bin/cuu/Value?gn
g      = 9.80665;
#
if(nargin<1)
# Load wind speed data
 sfxnc = '/home/mhoecker/work/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc';
 sfx = netcdf(sfxnc,'r');
 t = sfx{'Yday'}(:);
 idx = find((t>=328)&(t<=329));
 clear t
 wind.t = sfx{'Yday'}(idx(1:end));
 wind.U = sfx{'U10'}(idx(1:end));
 ncclose(sfx)
elseif(nargin<2)
 wind.U = U;
else
 wind.U = U;
 wind.t = t;
end
#
#Correct the wind to 19.5 m
# the hight of the weather ship in Pierson Moskowitz
wind.UPM = uofy(wind.U,19.5);
#
if(nargin!=1)
 spectra.t = wind.t;
 spectra.f = .05:.01:1;
 spectra.Sf = zeros(length(spectra.f),length(wind.U));
 spectra.f0 = g./(2*pi*wind.U);
 wave.t = wind.t;
end%if
# Calculate wave charachteristics
# Following Li & Garrett 1993
wave.Us = 0.015*wind.UPM;
wave.k = 1./(.24 *(wind.UPM.^2)/g);
wave.L = 2*pi./wave.k;
wave.cp = sqrt(g./wave.k);
wave.A = sqrt(wave.Us./wave.cp)./wave.k;
wave.fs = sqrt(g*wave.k)/(2*pi);
wave.T = 1./wave.fs;
#
 if(nargin!=1)
  for i=1:length(wind.U)
   # Calculate peak frequency
   spectra.Sf(:,i) = 2*pi*(alpha*g^2).*exp(-beta*(spectra.f0(i)./spectra.f).^4)./(2*pi*spectra.f).^5;
 end%for
 end%if
if(nargin<1)
 figure(1)
 [tt,ff] = meshgrid(wind.t,spectra.f);
 subplot(2,1,1)
 plot(wind.t,wind.U,"k;U_w (m/s);",wind.t,100*wave.Us,"b;U_s (cm/s);"); ylabel("U")
 subplot(2,1,2)
 pcolor(tt,1./ff,spectra.Sf); shading flat; ylabel("Period");xlabel("UTC Yearday")
 hold on
 plot(wave.t,wave.T,"k;T Stokes;")
 hold off
 print("/home/mhoecker/tmp/PMspectra.pdf","-dpdf")
end
end
