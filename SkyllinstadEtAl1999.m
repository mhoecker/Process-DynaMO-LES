function SkyllinstadEtAl1999(dagnc,sfxnc,chmnc,outdir)
% function skyllinstad1999(dagnc,sfxnc,chmnc,outdir)
% dagnc - dag file from LES (netCDF)
% sfxnc - surface flux file (netCDF)
% chmnc - Chameleon data file (netCDF)
%
% Recreate the figures in
% Skyllingstad, E. D.; Smyth, W. D.; Moum, J. N. & Wijesekera, H.
% Upper-ocean turbulence during a westerly wind burst: A comparison of large-eddy simulation results and microstructure measurements
% Journal of physical oceanography, 1999, 29, 5-28
%
 if nargin()<1
  dagnc = ''
 end%if
 if nargin()<2
  sfxnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/RevelleMetRev2/Revelle1minuteLeg3_r2.nc'
 end%if
 if nargin()<3
  chmnc = ''
 end%if
 if nargin()<4
  outdir = '/home/mhoecker/tmp/'
 end%if

 fig1(sfxnc,chmnc,outdir)
end%function

% figure 1
function fig1(sfxnc,chmnc,outdir)
%function fig1(sfxnc,chmnc,outdir)
%
% 4 plots stacked vertically with a common x-axis (yearday)
%
% 1st plot is Wind stress (tau~Pa) as a function of time
% 2nd plot is Precipitation (P~mm/h) as a function of time
% 3rd plot is Net Heat flux (J~W/m^2) as a function of time
% 4th plot is Turbulent dissipation (epsilon~W/kg) as a function of depth (m) and time
%
% The simulated time is bracketed by 2 days prior and 1 day after
% The simulated time is highlighted on the line plots
% line plots are filled
% epsilon is plotted on a log10 scale
t0sim = 328 % simulated start time is 2011 yearday 328
trange = [t0sim-2,t0sim+2]
sfx = netcdf(sfxnc,'r')
tsfx = sfx{'Yday'}(:);
sfxtidx = find(tsfx>=trange(1),1):find(tsfx>=trange(2),1);
tsfx = sfx{'Yday'}(sfxtidx);
stress = sfx{'stress'}(sfxtidx);
p = sfx{'P'}(sfxtidx);
precip = sfx{'Precip'}(sfxtidx);
Jh = sfx{'shf'}(sfxtidx)+sfx{'lhf'}(sfxtidx)+sfx{'rhf'}(sfxtidx)+sfx{'Solarup'}(sfxtidx)+sfx{'Solardn'}(sfxtidx)+sfx{'IRup'}(sfxtidx)+sfx{'IRdn'}(sfxtidx);
ncclose(sfx)
subplot(3,1,1)
plot(tsfx,stress)
subplot(3,1,2)
plot(tsfx,p)
% Add cumulative precip
%plot(tsfx,p,tsfx,precip-precip(1))
subplot(3,1,3)
plot(tsfx,-Jh)
%chm = netcdf(chmnc,'r')
%ncclose(chm)
print([outdir 'fig1.png'],'-dpng')
end%function

%figure 2

%figure 3

%figure 4
