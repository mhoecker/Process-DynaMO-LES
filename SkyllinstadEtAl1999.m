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

 fig1(sfxnc,chmnc,outdir);
 fig2(chmnc,adcpnc,outdir)
 fig3(chmnc,adcpnc,sfxnc,dagnc,outdir)
end%function

function idx = inclusiverange(variable,limits)
  a=(abs(variable-min(limits)));
  b=(abs(variable-max(limits)));
  abidx = sort([find(a==min(a),1),find(b==min(b),1)]);
  idx = abidx(1):abidx(2);
end%function
function [tsfx,stress,p,Jh,wdir] = surfaceflux(sfxnc,trange)
 % Extract Flux data
 sfx = netcdf(sfxnc,'r');
 tsfx = squeeze(sfx{'Yday'}(:));
 if nargin()>1
  sfxtidx = inclusiverange(tsfx,trange);
 else
  sfxtidx = 1:length(tsfx);
 end%if
 tsfx = squeeze(sfx{'Yday'}(sfxtidx));
 stress = squeeze(sfx{'stress'}(sfxtidx));
 p = squeeze(sfx{'P'}(sfxtidx));
 Jh = squeeze(sfx{'shf'}(sfxtidx)+sfx{'lhf'}(sfxtidx)+sfx{'rhf'}(sfxtidx)+sfx{'Solarup'}(sfxtidx)+sfx{'Solardn'}(sfxtidx)+sfx{'IRup'}(sfxtidx)+sfx{'IRdn'}(sfxtidx));
 wdir = squeeze(sfx{'Wdir'}(sfxtidx));
 % Some other things to extract
 #precip = squeeze(sfx{'Precip'}(sfxtidx));
 ncclose(sfx);
end%function

function [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange)
 % Extract profile data from Chameleon
 chm = netcdf(chmnc,'r');
 % Restrict time index
 tchm = squeeze(chm{'t'}(:));
 if nargin()>1
  chmtidx = inclusiverange(tchm,trange);
 else
  chmtidx = 1:length(tchm);
 end%if
 % restict depth range
 zchm = squeeze(chm{'z'}(:));
 if nargin()>2
  chmzidx = inclusiverange(zchm,zrange);
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

function [tadcp,zadcp,ulpadcp,vlpadcp]=ADCPprofiles(adcpnc,trange,zrange)
 % Extract ADCP profiles
 adcp = netcdf(adcpnc,'r');
 tadcp = squeeze(adcp{'t'}(:));
 zadcp = squeeze(adcp{'z'}(:));
 if nargin()>1
  adcptidx = inclusiverange(tadcp,trange);
 else
  adcptidx = 1:length(tadcp);
 end%if
 % restict depth range
 zadcp = squeeze(adcp{'z'}(:));
 if nargin()>2
  adcpzidx = inclusiverange(zadcp,zrange);
 else
  adcpzidx = 1:length(zadcp);
 end%if
 tadcp = squeeze(adcp{'t'}(adcptidx));
 zadcp = squeeze(adcp{'z'}(adcpzidx));
 ulpadcp = squeeze(adcp{'ulp'}(adcptidx,adcpzidx));
 vlpadcp = squeeze(adcp{'vlp'}(adcptidx,adcpzidx));
 ncclose(adcp);
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
 dsim = 100; % Maximum simulation depth
 trange = [t0sim-2,t0sim+2];
 zrange = sort([0,-dsim]);
 % Extract Flux data
 [tsfx,stress,p,Jh] = surfaceflux(sfxnc,trange);
 # Save Flux data
 binarray(tsfx',[stress,p,Jh]',[outdir "fig1abc.dat"]);
 # Extract epsilon profiles
 [tchm,zchm,epschm]=ChameleonProfiles(chmnc,trange,zrange);
 # Save epsilon profiles
 binmatrix(tchm',zchm',epschm',[outdir "fig1d.dat"]);
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
  pcolor(tt,zz,log(epschm')/log(10));
  shading flat;
  axis([trange,zrange]);
  colorbar()
  xlabel("2011 Year Day")
  ylabel("Depth (m)")
  print([outdir 'fig1.png'],'-dpng')
 else
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig1.plt");
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
 trange = [t0sim,t0sim];
 zrange = sort([0,-dsim]);
 % read ADCP file
 [tadcp,zadcp,ulpadcp,vlpadcp]=ADCPprofiles(adcpnc,trange,zrange);
 # Extract Legendre coefficients from adcp file
 [Ulpcoef,Vlpcoef,Uhcoef,Vhcoef,zfit] = uvLegendre(adcpnc,t0sim,dsim,5);
 xadcp = (2*abs(zadcp)-(min(zfit)+max(zfit)))/(max(zfit)-min(zfit));
 xadcp(find(xadcp>1))=1;
 xadcp(find(xadcp<-1))=-1;
 ULlp = zeros(size(zadcp'));
 VLlp = zeros(size(zadcp'));
 for i=1:length(Ulpcoef)
  ULlp = ULlp+Ulpcoef(i).*legendre(i-1,xadcp)(1,:);
  VLlp = VLlp+Vlpcoef(i).*legendre(i-1,xadcp)(1,:);
 end%for
 # save U,V profiles
 binarray(zadcp',[ulpadcp;vlpadcp;ULlp;VLlp],[outdir "fig2b.dat"]);
 # read Chameleon file
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Save T,S profiles
 binarray(zchm',[Tchm;Schm],[outdir "fig2a.dat"]);
 # Plot using octave or gnuplot script
 if(useoctplot==1)
  figure(2)
  subplot(1,2,1)
  plot(Tchm,zchm,Schm,zchm)
  axis([min([Tchm,Schm]),max([Tchm,Schm]),zrange])
  subplot(1,2,2)
  plot(ulpadcp,zadcp,vlpadcp,zadcp)
  axis([min([ulpadcp,vlpadcp]),max([ulpadcp,vlpadcp]),zrange])
  print([outdir 'fig2.png'],'-dpng')
 else
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig2.plt");
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
 trange = [t0sim,t0sim+1];
 zrange = sort([0,-dsim]);
 [tsfx,stress,p,Jh,wdir] = surfaceflux(sfxnc,trange);
 stressm = stress.*sin(wdir*pi/180);
 stressz = stress.*cos(wdir*pi/180);
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 [ttchm,zzchm] = meshgrid(tchm,zchm);
 [tadcp,zadcp,ulpadcp,vlpadcp]=ADCPprofiles(adcpnc,trange,zrange);
 [ttadcp,zzadcp] = meshgrid(tadcp,zadcp);
 if(useoctplot==1)
  figure(3)
  subplot(4,1,1)
  plot(tsfx,Jh)
  subplot(4,1,2)
  plot(tsfx,stressz,tsfx,stressm)
  axis([trange])
  subplot(4,1,3)
  pcolor(ttchm,zzchm,Tchm')
  shading flat
  axis([trange])
  subplot(4,1,4)
  pcolor(ttadcp,zzadcp,ulpadcp')
  shading flat
  axis([trange])
 else
 unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig3.plt")
 end%if
end%function

%figure 4
