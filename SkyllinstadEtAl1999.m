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
  dagnc = '/home/mhoecker/work/Dynamo/output/yellowstone10/dyn1024flx_s_dag.nc'
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
  outdir = '/home/mhoecker/work/Dynamo/plots/y10/';
 end%if
 if nargin()<6
   wavespecHL = "/home/mhoecker/work/Dynamo/output/surfspectra/wavespectraHSL.mat";
 end%if
 #
 longt = [315,336];
 ObsSurfEps(sfxnc,chmnc,[outdir 'long'],wavespecHL,longt);
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

function allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir,wavespecHL)
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam();
 [dagpath,dagname,dagext] = fileparts(dagnc)
 pyflowscript = [scriptdir "tkeflow.py"];
 Nfigs = 10;
 Ncur = 0;
 waithandle = waitbar(Ncur./Nfigs,["Generating ObsSurfEps figures in " outdir]);
 Ncur = Ncur+1;
 # Richardson Number Defined by Surface Flux
 #figRi(sfxnc,outdir);
 # Surface and dissipation observations
 ObsSurfEps(sfxnc,chmnc,outdir,wavespecHL);
 waitbar(Ncur./Nfigs,waithandle,["Generating initialTSUV figures in\n" outdir]);
 Ncur = Ncur+1;
 %# Initial Conditions
 initialTSUV(chmnc,adcpnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating ObsSimSideTSUVwSurf figures in\n" outdir]);
 Ncur = Ncur+1;
 # Model Obersvation Comparison
 ObsSimSideTSUVwSurf(chmnc,adcpnc,sfxnc,dagnc,outdir,wavespecHL);
 waitbar(Ncur./Nfigs,waithandle,["Generating figures ObsSimTSUVdiff in\n" outdir]);
 Ncur = Ncur+1;
 # Model Observation Difference
 ObsSimTSUVdiff(chmnc,adcpnc,sfxnc,dagnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating NSRi figures in\n" outdir]);
 Ncur = Ncur+1;
 # Stability Criterion
 NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir,wavespecHL);
 waitbar(Ncur./Nfigs,waithandle,["Generating Heatfluxcompare figures in\n" outdir]);
 Ncur = Ncur+1;
 # Heat flux comparison
 Heatfluxcompare(dagnc,sfxnc,outdir,wavespecHL);
 waitbar(Ncur./Nfigs,waithandle,["Generating HeatBudg figures in\n" outdir]);
 Ncur = Ncur+1;
 #Heat Budget
 HeatBudg(chmnc,adcpnc,sfxnc,dagnc,outdir,wavespecHL);
 waitbar(Ncur./Nfigs,waithandle,["Generating tkeBudg figures in\n" outdir]);
 Ncur = Ncur+1;
 # Momentum Budget
 momflux(dagnc,sfxnc,outdir,wavespecHL)
 # Turbulent Kinetic energy Budget plots
 tkeBudg(chmnc,adcpnc,sfxnc,dagnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating figures in\n" outdir]);
 Ncur = Ncur+1;
 # tke Budget
 # Hourly tke Budget
 dt = 3600
 imax = ceil(30*3600/dt);
 tkeframes(dt,imax,sfxnc,chmnc,outdir,dagnc,pyflowscript,wavespecHL);
 waitbar(Ncur./Nfigs,waithandle,["Generating figures in\n" outdir]);
 Ncur = Ncur+1;
 #
 close(waithandle);
end%function

function tkenc = tkeframes(dt,imax,sfxnc,chmnc,outdir,dagnc,pyflowscript,wavespecHL)
 [dagpath,dagname,dagext] = fileparts(dagnc)
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam();
 for i=1:imax
  trange = [-dt,0]+dt*i;
  obtrange = ([-dt,0]+dt*i)/(24*3600)+t0sim;
  namesfx = ["hourlytke" num2str(i,"%02i")];
  ObsSurfEps(sfxnc,chmnc,[outdir namesfx],wavespecHL,obtrange);
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
 [tscale,tunit] = timeunits(trange)
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
