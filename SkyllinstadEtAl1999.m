function SkyllinstadEtAl1999()
% function skyllinstad1999()
% dagnc     - dag file from LES (netCDF)
% sfxnc     - surface flux file (netCDF)
% chmnc     - Chameleon data file (netCDF)
% adcpnc    - Acoustic Doppler Current Profiler data file (netCDF)
% bcascii   - Boundary condition file (ASCII)
%
% outdir    - path where data, image and script files will be generated
%             contains "dat", "plt", and "png" subdirectories
%
% inspired by analysis in
% Skyllingstad, E. D.; Smyth, W. D.; Moum, J. N. & Wijesekera, H.
% Upper-ocean turbulence during a westerly wind burst:
% A comparison of large-eddy simulation results and microstructure measurements
% Journal of physical oceanography, 1999, 29, 5-28
 DynamoDir = '/home/mhoecker/work/Dynamo/';
 ModelDir = [DynamoDir '/output/yellowstone12/'];
 ObserveDir = [DynamoDir '/Observations/netCDF/'];
 dagnc  = [ModelDir 'd1024flxn_s_dag.nc']
 sfxnc  = [ObserveDir 'RevelleMet/Revelle1minuteLeg3_r3.nc']
 chmnc  = [ObserveDir 'Chameleon/dn11b_sum_clean_v2.nc']
 adcpnc = [ObserveDir 'RAMA/uv_RAMA_0N80E.nc']
 outdir = [DynamoDir 'plots/y12/']
 bcascii= [ModelDir 'Surface_Flux_328-330.bc']
 wavespecHL = [DynamoDir '/output/surfspectra/wavespectraHSL.mat'];
 %
 % Add figure plotting comands to the PATH
 ensureSkyllingstad1999;
 %
 allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir)
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
 ObsSurfEps(dagnc,chmnc,outdir);

 %% Initial Conditions
 %
 initialTSUV(chmnc,adcpnc,outdir);

 %
 %
 ObsSimSideTSUVwSurf(chmnc,adcpnc,sfxnc,dagnc,outdir)

 %% Stability Criterion
 %
 NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir);

 %% Heat flux comparison

 Heatfluxcompare(dagnc,sfxnc,outdir);

 %% Heat Budget

 HeatBudg(dagnc,outdir);

 %% Salt Budget

 SalBudg(dagnc,outdir);

 %% Momentum Budget

 momflux(dagnc,outdir)

 %% Richardson # histogram

 [SPfile,pcval] = richistogram(dagnc,outdir);

 %% Turbulent Kinetic energy Budget plots

 tkeBudg(dagnc,outdir,SPfile,pcval);

 %% Hourly tke Budget
 dt = 2*3600;
 imax = ceil(30*3600/dt);
 tkeframes(dt,imax,sfxnc,chmnc,outdir,dagnc,pyflowscript);

end%function

function tkenc = tkeframes(dt,imax,sfxnc,chmnc,outdir,dagnc,pyflowscript)
 [dagpath,dagname,dagext] = fileparts(dagnc)
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam();
 for i=1:imax
  trange = [-dt,0]+dt*i;
  obtrange = ([-dt,0]+dt*i)/(24*3600)+t0sim;
  namesfx = ["hourlytke" num2str(i,"%02i")];
  outnc = [outdir '/dat/' dagname namesfx dagext];
  [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,outnc,trange);
  [tscale,tunit] = timeunits(trange);
  ti = num2str(trange(1)/tscale,"%03.1f");
  tf = num2str(trange(2)/tscale,"%03.1f");
  plotlab = ["'tke\ Budget\ " ti tunit "<t<" tf tunit "'"];
  unix(["python " pyflowscript ' ' outdat ' ' outdir "png/" namesfx " " plotlab]);
 end%for
 %% Overall tke Budget
 trange = [0,dt*imax];
 tkenc = [outdir '/dat/' dagname "tke" dagext];
 [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,tkenc,trange);
 [tscale,tunit] = timeunits(trange);
 ti = num2str(trange(1)/tscale,"%03.1f");
 tf = num2str(trange(2)/tscale,"%03.1f");
 [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,tkenc,trange);
 [tkepath,tkename,tkeext] = fileparts(tkenc);
 tkezavgnc = [tkepath '/' tkename 'zavg' tkeext];
 tkebzavg(tkezavgnc,outdir);
 plotlab = ["'tke\ Budget\ " ti tunit "<t<" tf tunit "'"];
 unix(["python " pyflowscript " " outdat " " outdir "png/full " plotlab]);
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
