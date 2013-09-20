function SkyllinstadEtAl1999(dagnc,sfxnc,chmnc,adcpnc,outdir)
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
  dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/run8/dyno_328Rev_5-a_dag.nc'
 end%if
 if nargin()<2
  sfxnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/RevelleMetRev2/Revelle1minuteLeg3_r2.nc'
 end%if
 if nargin()<3
  chmnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/Chameleon/dn11b_sum_clean_v2.nc'
 end%if
 if nargin()<4
  adcpnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140_filtered_1hr_3day.nc'
 end%if
 if nargin()<5
  outdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/'
 end%if

% fig1(sfxnc,chmnc,outdir)
% fig2(chmnc,adcpnc,outdir)
 fig3(chmnc,adcpnc,sfxnc,dagnc,outdir)
end%function

function [tsfx,stress,p,Jh,wdir] = surfaceflux(sfxnc,trange)
 % Extract Flux data
 sfx = netcdf(sfxnc,'r');
 tsfx = sfx{'Yday'}(:);
 sfxtidx = find(tsfx>=trange(1),1):find(tsfx>=trange(2),1);
 tsfx = squeeze(sfx{'Yday'}(sfxtidx));
 stress = squeeze(sfx{'stress'}(sfxtidx));
 p = squeeze(sfx{'P'}(sfxtidx));
 Jh = squeeze(sfx{'shf'}(sfxtidx)+sfx{'lhf'}(sfxtidx)+sfx{'rhf'}(sfxtidx)+sfx{'Solarup'}(sfxtidx)+sfx{'Solardn'}(sfxtidx)+sfx{'IRup'}(sfxtidx)+sfx{'IRdn'}(sfxtidx));
 wdir = squezze(sfx{'wdir'}(sfxtidx));
 % Some other things to extract
 #precip = squeeze(sfx{'Precip'}(sfxtidx));
 ncclose(sfx);
end%function

function [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange)
 % Extract profile data from Chameleon
 chm = netcdf(chmnc,'r');
 % Restrict time index
 tchm = chm{'t'}(:);
 if nargin()>1
  chmtidx = sort(find(tchm>=min(trange),1):find(tchm>=max(trange),1));
 else
  chmtidx = 1:length(tchm);
 end%if
 % restict depth range
 zchm = chm{'z'}(:);
 if nargin()>2
  chmzidx = sort(find(zchm>=min(zrange),1):find(zchm<=max(zrange),1));
 else
  chmzidx = 1:length(zchm);
 end%if
 % Extract desired data
 tchm   = squeeze(chm{'t'}(chmtidx));
 zchm   = squeeze(chm{'z'}(chmzidx));
 epschm = squeeze(chm{'epsilon'}(chmtidx,chmzidx));
 Tchm   = squeeze(chm{'T'}(chmtidx,chmzidx));
 Schm   = squeeze(chm{'S'}(chmtidx,chmzidx));
 ncclose(chm);
end%function

function ADCPprofiles(adcpnc,trange,zrange)
 % Extract ADCP profiles
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
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 trange = [t0sim-2,t0sim+2];
 % Extract Flux data
 [tsfx,stress,p,Jh] = surfaceflux(sfxnc,trange)
 # Save Flux data
 binarray(tsfx',[stress;p;Jh],[outdir "fig1abc.dat"]);
 # Extract epsilon profiles
 [tchm,zchm,epschm]=ChameleonProfiles(chmnc,trange)
 # Save epsilon profiles
 binmatrix(tchm',zchm,epschm',[outdir "fig1d.dat"]);
 # Plot using octave or Gnuplot
 if(useoctplot==1)
  figure(1)
  subplot(4,1,1)
  plot(tsfx,stress)
  ylabel("Wind Stress (Pa)")
  subplot(4,1,2)
  plot(tsfx,p)
  ylabel("Precipitation rate (mm/hour)")
  subplot(4,1,3)
  plot(tsfx,Jh)
  ylabel("Heat Flux (W/m^2)")
  [tt,zz] = meshgrid(tchm,zchm);
  subplot(4,1,4)
  pcolor(tt,zz,log(epschm')/log(10)); shading flat
  axis([trange,-120,-20])
  colorbar()
  xlabel("2011 Year Day")
  ylabel("Depth (m)")
  print([outdir 'fig1.png'],'-dpng')
 else
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig1.plt")
 end%if
end%function
%
%
%figure 2
function  fig2(chmnc,adcpnc,outdir)
 %
 % two side by side plots with a common y axis (depth)
 %
 % 1st plot on upper x-axis Salinity (psu) on lower x-axis Potential Temperature (C) at simulation start
 % 2nd plot E/W (u) and N/S (v) velocity at simulation start
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 dsim = 100; % Maximum simulation depth
 % read ADCP file
 adcp = netcdf(adcpnc,'r');
 adcpt = adcp{'t'}(:);
 adcpz = adcp{'z'}(:);
 adcptidx = find(adcpt>tsim0,1);
 adcpzidx = find(adcpz>-dsim);
 adcpt = squeeze(adcp{'t'}(adcptidx));
 adcpz = squeeze(adcp{'z'}(adcpzidx));
 adcpulp = squeeze(adcp{'ulp'}(adcptidx,adcpzidx));
 adcpvlp = squeeze(adcp{'vlp'}(adcptidx,adcpzidx));
 ncclose(adcp);
 # Extract Legendre coefficients from adcp file
 [Ulpcoef,Vlpcoef,Uhcoef,Vhcoef,zfit] = uvLegendre(adcpnc,tsim0,dsim,5);
 adcpx = (2*abs(adcpz)-(min(zfit)+max(zfit)))/(max(zfit)-min(zfit));
 adcpx(find(adcpx>1))=1;
 adcpx(find(adcpx<-1))=-1;
 ULlp = zeros(size(adcpz'));
 VLlp = zeros(size(adcpz'));
 for i=1:length(Ulpcoef)
  ULlp = ULlp+Ulpcoef(i).*legendre(i-1,adcpx)(1,:);
  VLlp = VLlp+Vlpcoef(i).*legendre(i-1,adcpx)(1,:);
 end%for
 # save U,V profiles
 binarray(adcpz',[adcpulp;adcpvlp;ULlp;VLlp],[outdir "fig2b.dat"])
 # read Chameleon file
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange)
 # Save T,S profiles
 binarray(zchm',[Tchm;Schm],[outdir "fig2a.dat"]);
 # Plot using octave or gnuplot script
 if(useoctplot==1)
  figure(2)
  subplot(1,2,1)
  plot(Tchm,zchm,Schm,zchm)
  subplot(1,2,2)
  plot(adcpulp,adcpz,adcpvlp,adcpz)
  print([outdir 'fig2.png'],'-dpng')
 else
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig2.plt")
 end%if
end%function

%figure 3
function  fig3(chmnc,adcpnc,sfxnc,dagnc,outdir)
 % Comparison of Temperature, Salinity, and Velocity in observations
 % and model.  The surface heat and momentum forcings are also shown
 %
 useoctplot=1; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 dsim = 100; % Maximum simulation depth
 if(useoctplot==1)
  subplot(5,2,1)
 else
 unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig3.plt")
 end%if
end%function

%figure 4
