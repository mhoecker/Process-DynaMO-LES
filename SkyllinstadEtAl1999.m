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
 ModelDir = cstrcat(DynamoDir,'/output/yellowstone15/');
 ObserveDir = cstrcat(DynamoDir,'/Observations/netCDF/');
 dagnc  = cstrcat(ModelDir,'dag.nc');
 sfxnc  = cstrcat(ObserveDir,'RevelleMet/Revelle1minuteLeg3_r3.nc');
 chmnc  = cstrcat(ObserveDir,'Chameleon/dn11b_sum_clean_v2.nc');
 adcpnc = cstrcat(ObserveDir,'RAMA/uv_RAMA_0N80E.nc');
 TSUVnc = cstrcat(ModelDir,'UVinit.nc')
 outdir = cstrcat(DynamoDir,'plots/y15/')
 bcascii= cstrcat(ModelDir,'Surface_Flux_328-330.bc');
 bcdat = cstrcat(ModelDir,'Surface_Flux_328-330.dat');
 %
 % Add figure plotting comands to the PATH
 ensureSkyllingstad1999;
 %
 allfigs(chmnc,adcpnc,sfxnc,dagnc,bcdat,TSUVnc,outdir)
 % Remove the figure ploting commands from the PATH
 removeSkyllingstad1999;
end%function

function allfigs(chmnc,adcpnc,sfxnc,dagnc,bcdat,TSUVnc,outdir)
 %
 %% Preliminaries
 %% Get plot parameters
 %% parse file names
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dirs] = plotparam();
 [dagpath,dagname,dagext] = fileparts(dagnc)
 pyflowscript = [dirs.script,"tkeflow.py"];
 %
 %% Richardson Number Defined by Surface Flux
 %
 %figRi(sfxnc,outdir);

 %% Surface and dissipation observations
 %
 ObsSurfEps(dagnc,bcdat,outdir);

 %% Initial Conditions
 %
 initialTSUV(TSUVnc,outdir);

 % T,S,U plots
 %

 %ObsSimSideTSUVwSurf(chmnc,adcpnc,sfxnc,dagnc,outdir)

 %% Stability Criterion
 %
 NSRi(adcpnc,sfxnc,dagnc,outdir);

 %% Heat flux comparison

 Heatfluxcompare(dagnc,bcdat,outdir);

 %% Heat Budget

 HeatBudg(dagnc,bcdat,outdir);

 %% Salt Budget

 SalBudg(dagnc,bcdat,outdir);

 %% Momentum Budget

 momflux(dagnc,bcdat,outdir)

 %% Richardson # histogram

 [SPfile,pcval] = richistogram(dagnc,outdir);

 %% Turbulent Kinetic energy Budget plots

 tkeBudg(dagnc,outdir,SPfile,pcval);

 wplot

 [outtke,dagzavg,outAVG,outAVGdat] = tkeBudget(dagnc)
 %dagzavg = [dagpath,'/' dagname 'tkezavg.nc'];
 tkebzavg(dagzavg,dagnc,outdir);

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
