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
 gswpath = "/home/mhoecker/work/TEOS-10/";
 addpath(gswpath);
 gswpath = "/home/mhoecker/work/TEOS-10/library/";
 addpath(gswpath);
 if nargin()<1
%  dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/run8/dyno_328Rev_5-a_dag.nc'
%  dagnc = '/media/mhoecker/20130916External/o448_1-a_dag.nc'
  dagnc = '/media/mhoecker/20130916External/o448_1-b_dag.nc'
 end%if
 if nargin()<2
  sfxnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc'
  %sfxnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/FluxTower/PSDflx_leg3.nc'
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
 fig2(chmnc,adcpnc,outdir);
 fig3(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig4(chmnc,adcpnc,sfxnc,dagnc,outdir);
end%function

function [useoctplot,t0sim,dsim,tfsim] = simparam(outdir)
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 dsim = 80; % Maximum simulation depth
 tfsim = t0sim+1; % Simulated stop time 2011 yearday
 if(useoctplot!=1)
  limitsfile = [outdir "limits.plt"];
  fid = fopen(limitsfile,"w");
  fprintf(fid,"t0sim=%f\n",t0sim);
  fprintf(fid,"tfsim=%f\n",tfsim);
  fprintf(fid,"dsim=%f\n",dsim);
  fclose(fid);
 end%if
end%function

function idx = inclusiverange(variable,limits)
  a=(abs(variable-min(limits)));
  b=(abs(variable-max(limits)));
  abidx = sort([find(a==min(a),1),find(b==min(b),1)]);
  idx = abidx(1):abidx(2);
end%function

function [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet] = surfaceflux(sfxnc,trange)
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
 sst = squeeze(sfx{'SST'}(sfxtidx));
 SalTSG = squeeze(sfx{'SalTSG'}(sfxtidx));
 SolarNet = squeeze(sfx{'Solarup'}(sfxtidx)+sfx{'Solardn'}(sfxtidx));
 % Some other things to extract
 #precip = squeeze(sfx{'Precip'}(sfxtidx));
 ncclose(sfx);
end%function

function [Ri,alpha,g,nu,kappaT] = surfaceRi(stress,Jh,sst,sss)
 % Convert surface stress and heat flux into a richardson number
 %
 % Ri = g * alpha * ( Jh / kappaT ) * / (stress/nu rho)^2
 %
 nu = 1.05e-6; %
 kappaT = 1.46e-7; %
 % from
 % Tables of Physical & Chemical Constants (16th edition 1995).
 % 2.7.9 Physical properties of sea water.
 % Kaye & Laby Online. Version 1.0 (2005) www.kayelaby.npl.co.uk
 sssa = gsw_SA_from_SP(sss,80.5+0*sss,0*sss,0*sss);
 alpha = gsw_alpha(sst,sssa,0*sst );
 rho0 = gsw_rho(sst,sssa,0*sst);
 g = grav = gsw_grav(0);
 Ri = -(nu.^2).*g.*rho0.*alpha.*Jh./(kappaT.*stress.^2);
end%function

function [Ri,rho,Sh,Nsq] profileRi(U,V,zuv,T,Sal,zTS)
 % Calculate the Richardson given a velocity and TS profile
 ddzuv = ddz(zuv);
 ddzTS = ddz(zTS);
 pTS = gsw_p_from_z(zTS,0);
 pref = mean(PTS)
 SA = gsw_SA_from_SP(sss,80.5+0*sss,0*sss,0*sss);
 rho = gsw_rho(T,SA,0);

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

function [tdag,zdag,uavgdag,vavgdag,Tavgdag,Savgdag]=DAGprofiles(dagnc,trange,zrange)
 % Extract diagnostic profiles
 dag = netcdf(dagnc,'r');
 tdag = squeeze(dag{'time'}(:));
 if nargin()>1
  dagtidx = inclusiverange(tdag,trange);
 else
  dagtidx = 1:length(tdag);
 end%if
 % restict depth range
 zdag = -squeeze(dag{'zzu'}(:));
 if nargin()>2
  dagzidx = inclusiverange(zdag,zrange);
 else
  dagzidx = 1:length(zdag);
 end%if
 tdag = squeeze(dag{'time'}(dagtidx));
 zdag = -squeeze(dag{'zzu'}(dagzidx));
 uavgdag = squeeze(dag{'u_ave'}(dagtidx,dagzidx,1,1));
 vavgdag = squeeze(dag{'v_ave'}(dagtidx,dagzidx,1,1));
 Tavgdag = squeeze(dag{'t_ave'}(dagtidx,dagzidx,1,1));
 Savgdag = squeeze(dag{'s_ave'}(dagtidx,dagzidx,1,1));
 ncclose(dag);
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
 [useoctplot,t0sim,dsim,tfsim]=simparam(outdir);
 trange = [t0sim-1,tfsim+1];
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
 [useoctplot,t0sim,dsim]=simparam(outdir);
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
 [useoctplot,t0sim,dsim]=simparam(outdir);
 trange = [t0sim,t0sim+1];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir] = surfaceflux(sfxnc,trange);
 # Decomplse Stress into components
 stressm = -stress.*sin(wdir*pi/180);
 stressz = -stress.*cos(wdir*pi/180);
 # Save surface flux profiles
 binarray(tsfx',[Jh,p,stressm,stressz]',[outdir "fig3ab.dat"]);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Save T,S profiles
 binmatrix(tchm',zchm',Tchm',[outdir "fig3c.dat"]);
 binmatrix(tchm',zchm',Schm',[outdir "fig3e.dat"]);
 # extract ADCP data
 [tadcp,zadcp,ulpadcp,vlpadcp]=ADCPprofiles(adcpnc,trange,zrange);
 # save U,V profiles
 binmatrix(tadcp',zadcp',ulpadcp',[outdir "fig3g.dat"]);
 binmatrix(tadcp',zadcp',vlpadcp',[outdir "fig3i.dat"]);
 # Extract simulation data
 [tdag,zdag,uavgdag,vavgdag,Tavgdag,Savgdag]=DAGprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 # save Simulated profiles
 binmatrix(tdag',zdag',Tavgdag',[outdir "fig3d.dat"]);
 binmatrix(tdag',zdag',Savgdag',[outdir "fig3f.dat"]);
 binmatrix(tdag',zdag',uavgdag',[outdir "fig3h.dat"]);
 binmatrix(tdag',zdag',vavgdag',[outdir "fig3j.dat"]);
 if(useoctplot==1)
  # Make co-ordinate 2-D arrays from lists
  [ttchm,zzchm] = meshgrid(tchm,zchm);
  [ttadcp,zzadcp] = meshgrid(tadcp,zadcp);
  [ttdag,zzdag] = meshgrid(tdag,zdag);
  # Picture time!
  figure(3)
  subplot(5,2,1)
  plot(tsfx,Jh,tsfx,p)
  subplot(5,2,2)
  plot(tsfx,stressz,tsfx,stressm)
  axis([trange])
  subplot(5,2,3)
  pcolor(ttchm,zzchm,Tchm')
  shading flat
  axis([trange])
  subplot(5,2,4)
  pcolor(ttdag,zzdag,Tavgdag')
  shading flat
  subplot(5,2,5)
  pcolor(ttchm,zzchm,Schm')
  shading flat
  axis([trange])
  axis([trange])
  subplot(5,2,6)
  pcolor(ttdag,zzdag,Savgdag')
  shading flat
  subplot(5,2,7)
  pcolor(ttadcp,zzadcp,ulpadcp')
  shading flat
  axis([trange])
  subplot(5,2,8)
  pcolor(ttdag,zzdag,uavgdag')
  shading flat
  subplot(5,2,9)
  pcolor(ttadcp,zzadcp,vlpadcp')
  shading flat
  axis([trange])
  subplot(5,2,10)
  pcolor(ttdag,zzdag,vavgdag')
  shading flat
  print([outdir 'fig3.png'],'-dpng')
 else
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig3.plt")
 end%if
end%function

%figure 4
function fig4(chmnc,adcpnc,sfxnc,dagnc,outdir)
 % Plot time series of N^2 S^2 and Ri
 [useoctplot,t0sim,dsim,tfsim]=simparam(outdir);
 useoctplot=1;
 trange = [t0sim-3,tfsim+3];
 zrange = sort([0,-dsim]);
 useoctplot = 1;
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,uavgdag,vavgdag,Tavgdag,Savgdag]=DAGprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # Calulatwe the Driven Richarson number
 [Ri,alpha,g,nu,kappaT]  = surfaceRi(stress,Jh,sst,sal);
 #
 if(useoctplot==1)
  subplot(4,1,1)
%  plot(tsfx,Jh,tsfx,0*ones(size(tsfx)),"k")
%  ylabel("Jh")
%  subplot(4,1,2)
%  plot(tsfx,stress)
%  ylabel("stress")
%  subplot(4,1,3)
%  semilogy(tsfx,4*Ri,tsfx,ones(size(tsfx)),"k")
%  ylabel("+4Ri")
%  subplot(4,1,4)
%  semilogy(tsfx,-4*Ri,tsfx,ones(size(tsfx)),"k")
%  ylabel("-4Ri")
  subplot(2,1,1)
  semilogy(tsfx,4*Ri,tsfx,ones(size(tsfx)),"k")
  ylabel("+4Ri")
  subplot(2,1,2)
  semilogy(tsfx,-4*Ri,tsfx,ones(size(tsfx)),"k")
  ylabel("-4Ri")
  print([outdir "fig4.png"],"-dpng")
 else
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig4.plt")
 end%if
 %
end%function
