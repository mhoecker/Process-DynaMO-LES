function LESsummary()
% function skyllinstad1999()
% dagnc     - dag file from LES (netCDF)
% bcnc      - surface flux file (netCDF)
% ic1nc     - initial condition file (netCDF)
% ic2nc     - UVTS initial condition files (netCDF)
% DynamoDir - Root directory of Dynamo work
% ModelDir  - Location of model output
% ICBCDir   - Location of model inputs
% outdir    - path where data, image and script files will be generated
%             contains "dat", "plt", and "png" subdirectories
%
% inspired by analysis in
% Skyllingstad, E. D.; Smyth, W. D.; Moum, J. N. & Wijesekera, H.
% Upper-ocean turbulence during a westerly wind burst:
% A comparison of large-eddy simulation results and microstructure measurements
% Journal of physical oceanography, 1999, 29, 5-28
 %rstnc     = cstrcat(ModelDir,'test_1200_rst.nc');
 %
 % Add figure plotting comands to the PATH
 %
 %mergedagfiles = "ncrcat -O ";
 %mergedagfiles =  [mergedagfiles ModelDir "001_dag.nc "];
 %mergedagfiles =  [mergedagfiles ModelDir "testing_2_dag_trim.nc "];
 %mergedagfiles =  [mergedagfiles ModelDir "testing_3_dag_trim.nc "];
 %mergedagfiles =  [mergedagfiles ModelDir "testing_4_dag.nc "];
 %mergedagfiles =  [mergedagfiles "-o " ModelDir "dag.nc "];
 %unix(mergedagfiles)
 ensurepath("/home/mhoecker/work/Dynamo/octavescripts/LESsummaries/")
 DynamoDir = '/home/mhoecker/work/Dynamo/output/EricCompare/20150717/';
 %
 RunDir    = cstrcat(DynamoDir,'080.5DYNAMO/');
 outdir    = cstrcat(RunDir,'plots/');
 ICBCDir   = cstrcat(RunDir,'data/');
 icnc      = cstrcat(ICBCDir,'UVinit.nc');
 ModelDir  = cstrcat(RunDir,'');
 dagnc     = cstrcat(ModelDir,'080_5dyn-a_dag.nc');
 allfigs(outdir,icnc,dagnc)
 %
 RunDir    = cstrcat(DynamoDir,'080.5TOGACOARE/');
 outdir    = cstrcat(RunDir,'plots/');
 ICBCDir   = cstrcat(RunDir,'data/');
 icnc      = cstrcat(ICBCDir,'UVinit.nc');
 ModelDir  = cstrcat(RunDir,'');
 dagnc     = cstrcat(ModelDir,'080_5tog-a_dag.nc');
 allfigs(outdir,icnc,dagnc)
 %
 RunDir    = cstrcat(DynamoDir,'090.0DYNAMO/');
 outdir    = cstrcat(RunDir,'plots/');
 ICBCDir   = cstrcat(RunDir,'data/');
 icnc      = cstrcat(ICBCDir,'UVinit.nc');
 ModelDir  = cstrcat(RunDir,'');
 dagnc     = cstrcat(ModelDir,'090_0dyn-a_dag.nc');
 allfigs(outdir,icnc,dagnc)
 %
 RunDir    = cstrcat(DynamoDir,'090.0TOGACOARE/');
 outdir    = cstrcat(RunDir,'plots/');
 ICBCDir   = cstrcat(RunDir,'data/');
 icnc      = cstrcat(ICBCDir,'UVinit.nc');
 ModelDir  = cstrcat(RunDir,'');
 dagnc     = cstrcat(ModelDir,'090_0tog-a_dag.nc');
 allfigs(outdir,icnc,dagnc)
 % Remove the figure ploting commands from the PATH
 rmpath("/home/mhoecker/work/Dynamo/octavescripts/LESsummaries/");
end%function

function allfigs(outdir,icnc,dagnc,rstnc)
 %
 %% Preliminaries
 %% Get plot parameters
 %% parse file names
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dirs] = plotparam(outdir);
 pyflowscript = cstrcat(dirs.script,"tkeflow.py");
 %
 %% Richardson Number Defined by Surface Flux
 %
 %figRi(sfxnc,outdir);

 %% Initial Conditions
 %
 if(strcmp(icnc,'')!=1)
  plotLESIC(outdir,icnc);

 %% Surface and dissipation observations
 %
  plotLESBC(outdir,icnc);
 end%if

 if(nargin>2)
  [dagpath,dagname,dagext] = fileparts(dagnc);
 %% Heat flux comparison

  LESHeatFlx(outdir,dagnc);

 %% Stability Criterion
 %
  LESNSRi(dagnc,outdir);

 %% Heat Budget

  LESHeatBudg(outdir,dagnc);

 %% Salt Budget

  LESSalBudg(outdir,dagnc);

 %% Momentum Budget

  LESmomflux(outdir,dagnc)

 %% Richardson # histogram

  [SPfile,pcval] = richistogram(dagnc,outdir);

 %% Turbulent Kinetic energy Budget plots

  tkeBudg(dagnc,outdir,SPfile,pcval);

 %% Hourly tke Budget
 %dt = 2*3600;
 %imax = ceil(30*3600/dt);
 %tkeframes(dt,imax,outdir,dagnc,SPfile,pcval,pyflowscript);
  if(nargin>3)
%   wplot(rstnc,outdir)
  end%if
 end%if
end%function

function tkenc = tkeframes(dt,imax,outdir,dagnc,SPfile,pcval,pyflowscript);
 [dagpath,dagname,dagext] = fileparts(dagnc)
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam(outdir);
 %for i=1:1
 % trange = [-dt,0]+dt*i;
 % obtrange = ([-dt,0]+dt*i)/(24*3600)+t0sim;
 % namesfx = ["hourlytke" num2str(i,"%02i")];
 % outnc = [outdir '/dat/' dagname namesfx dagext];
 % [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,outnc,trange);
 % [tscale,tunit] = timeunits(trange);
 % ti = num2str(trange(1)/tscale,"%03.1f");
 % tf = num2str(trange(2)/tscale,"%03.1f");
 % plotlab = ["'tke\ Budget\ " ti tunit "<t<" tf tunit "'"];
 % unix(["python " pyflowscript ' ' outdat ' ' outdir "png/" namesfx " " plotlab]);
 %end%for
 %% Overall tke Budget
 trange = [0,dt*imax];
 tkenc = [outdir '/dat/' dagname "tke" dagext];
 [outtke,outzavg,outAVG,outdat] = tkeBudget(dagnc,outdir,SPfile,pcval);
 [tscale,tunit] = timeunits(trange);
 ti = num2str(trange(1)/tscale,"%03.1f");
 tf = num2str(trange(2)/tscale,"%03.1f");
 [tkepath,tkename,tkeext] = fileparts(tkenc);
 tkezavgnc = [tkepath '/' tkename 'zavg' tkeext];
 tkebzavg(tkezavgnc,dagnc,outdir);
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
