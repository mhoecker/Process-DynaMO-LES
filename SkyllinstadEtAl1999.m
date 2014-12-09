function SkyllinstadEtAl1999(dagnc,sfxnc,chmnc,adcpnc,outdir,wavespecHL)
% function skyllinstad1999(dagnc,sfxnc,chmnc,outdir)
% dagnc - dag file from LES (netCDF)
% sfxnc - surface flux file (netCDF)
% chmnc - Chameleon data file (netCDF)
%
% inspired by analysis in
% Skyllingstad, E. D.; Smyth, W. D.; Moum, J. N. & Wijesekera, H.
% Upper-ocean turbulence during a westerly wind burst:
% A comparison of large-eddy simulation results and microstructure measurements
% Journal of physical oceanography, 1999, 29, 5-28
%
 ensureSkyllingstad1999;
 if nargin()<1
  dagnc = '/home/mhoecker/work/Dynamo/output/yellowstone12/d1024flxn_s_dag.nc'
 end%if
 if nargin()<2
  sfxnc = '/home/mhoecker/work/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc'
end%if
 if nargin()<3
  chmnc = '/home/mhoecker/work/Dynamo/Observations/netCDF/Chameleon/dn11b_sum_clean_v2.nc'
 end%if
 if nargin()<4
  adcpnc = "/home/mhoecker/work/Dynamo/Observations/netCDF/RAMA/uv_RAMA_0N80E.nc"
 end%if
 if nargin()<5
  outdir = '/home/mhoecker/work/Dynamo/plots/y12/';
 end%if
 if nargin()<6
   wavespecHL = "/home/mhoecker/work/Dynamo/output/surfspectra/wavespectraHSL.mat";
 end%if
 #
 %
 allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir,wavespecHL)
 #
 #
 # Test figure
 #testfig(outdir);
 #figRi(sfxnc,outdir);
 #fig1
 #ObsSurfEps(sfxnc,chmnc,outdir);
 #fig2
 #initialTSUV(chmnc,adcpnc,outdir);
 #fig3
 #ObsSimSideTSUVwSurf(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig3diff
 #ObsSimTSUVdiff(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig4
 #NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig6
 #tkeBudg(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig7
 #HeatBudg(chmnc,adcpnc,sfxnc,dagnc,outdir);
 % Remove the figure ploting commands from the PATH
 removeSkyllingstad1999;
end%function

function allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %
 %% Preliminaries
 %% Get plot parameters
 %% parse file names
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dirs] = plotparam();
 [dagpath,dagname,dagext] = fileparts(dagnc)
 pyflowscript = [dirs.script "tkeflow.py"];
 %
 %% Richardson Number Defined by Surface Flux
 %
 %figRi(sfxnc,outdir);

 %% Surface and dissipation observations
 %
 %ObsSurfEps(dagnc,chmnc,outdir);

 %% Initial Conditions
 %
 %initialTSUV(chmnc,adcpnc,outdir);

 %% Stability Criterion
 %
 %NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir);

 %% Heat flux comparison

 %Heatfluxcompare(dagnc,sfxnc,outdir);

 %% Heat Budget

 %HeatBudg(dagnc,outdir);

 %% Salt Budget

 %SalBudg(dagnc,outdir);

 %% Momentum Budget

 %momflux(dagnc,outdir)

 %% Richardson # histogram

 %[SPfile,pcval] = richistogram(dagnc,outdir);

 %% Turbulent Kinetic energy Budget plots

 %tkeBudg(dagnc,outdir,SPfile,pcval);

 % tke Budget
 % Hourly tke Budget
 dt = 2*3600;
 imax = ceil(30*3600/dt);
 %tkeframes(dt,imax,sfxnc,chmnc,outdir,dagnc,pyflowscript,wavespecHL);
end%function

function tkenc = tkeframes(dt,imax,sfxnc,chmnc,outdir,dagnc,pyflowscript,wavespecHL)
 [dagpath,dagname,dagext] = fileparts(dagnc)
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam();
 for i=1:imax
  trange = [-dt,0]+dt*i;
  obtrange = ([-dt,0]+dt*i)/(24*3600)+t0sim;
  namesfx = ["hourlytke" num2str(i,"%02i")];
  ObsSurfEps(dagnc,chmnc,[outdir namesfx],obtrange);
  outnc = [dagpath '/' dagname namesfx dagext];
  [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,outnc,trange);
  [tscale,tunit] = timeunits(trange);
  ti = num2str(trange(1)/tscale,"%03.1f");
  tf = num2str(trange(2)/tscale,"%03.1f");
  plotlab = ["'tke\ Budget\ " ti tunit "<t<" tf tunit "'"];
  unix(["python " pyflowscript ' ' outdat ' ' outdir namesfx " " plotlab]);
 end%for
 # Overall tke Budget
 trange = [0,dt*imax];
 tkenc = [dagpath '/' dagname "tke" dagext];
 [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,tkenc,trange);
 [tscale,tunit] = timeunits(trange);
 ti = num2str(trange(1)/tscale,"%03.1f");
 tf = num2str(trange(2)/tscale,"%03.1f");
 [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,tkenc,trange);
 [tkepath,tkename,tkeext] = fileparts(tkenc);
 tkezavgnc = [tkepath '/' tkename 'zavg' tkeext];
 tkebzavg(tkezavgnc,outdir);
 plotlab = ["'tke\ Budget\ " ti tunit "<t<" tf tunit "'"];
 unix(["python " pyflowscript " " outdat " " outdir "full " plotlab]);
end%function

function [tscale,tunit] = timeunits(trange)
  if(diff(trange)<6)
   tscale = 1;
   tunit = "sec";
  elseif(diff(trange)<360)
   tscale = 60;
   tunit = "min";
  elseif(diff(trange)<8640)
   tscale = 3600;
   tunit = "hr";
  else
   tscale = 86400;
   tunit = "day";
  end%if
end%function
