function SkyllinstadEtAl1999(dagnc,sfxnc,chmnc,adcpnc,outdir)
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
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/run8/dyno_328Rev_5-a_dag.nc'
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone1/o448_1-b_dag.nc'
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone2/o512_1_dag.nc'
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone3/o1024_1_dag.nc'
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone6/d1024_1_dag.nc'
  dagnc ='/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone7/dyntest-b_dag.nc'
 end%if
 if nargin()<2
  sfxnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc'
  %sfxnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/FluxTower/PSDflx_leg3.nc'
end%if
 if nargin()<3
  chmnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/Chameleon/dn11b_sum_clean_v2.nc'
 end%if
 if nargin()<4
  %adcpnc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140.nc"
  adcpnc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/RAMA/uv_RAMA_0N80E.nc"
 end%if
 if nargin()<5
  %outdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/'
  outdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/y7/';
 end%if
 #
 allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir)
 #
 #outdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/NWW/';
 #dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone5/o1024_nww-a_dag.nc';
 #allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir)
 #
 #[tkenc,tkezavgnc,tkeAVGnc] = tkeBudget(dagnc)
 #if(nargin<2)
 # tkenc = [dagpath '/' dagname "tke" dagext];
 #end%if
 #[tkepath,tkename,tkeext] = fileparts(tkenc);
 #tkezavgnc = [tkepath '/' tkename 'zavg' tkeext]
 #tkeAVGnc =  [tkepath '/' tkename 'AVG' tkeext]
 #tkebzavg(tkezavgnc,outdir);
 outdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/y6/';
 dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone6/d1024_1_dag.nc'
 allfigs(chmnc,adcpnc,sfxnc,dagnc,outdir)
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
 Nfigs = 8;
 Ncur = 0;
 waithandle = waitbar(Ncur./Nfigs,["Generating ObsSurfEps figures in " outdir]);
 Ncur = Ncur+1;
 # Richardson Number Defined by Surface Flux
 #figRi(sfxnc,outdir);
 # Surface and dissipation observations
 #ObsSurfEps(sfxnc,chmnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating initialTSUV figures in\n" outdir]);
 Ncur = Ncur+1;
 # Initial Conditions
 #initialTSUV(chmnc,adcpnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating ObsSimSideTSUVwSurf figures in\n" outdir]);
 Ncur = Ncur+1;
 # Model Obersvation Comparison
 #ObsSimSideTSUVwSurf(chmnc,adcpnc,sfxnc,dagnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating figures ObsSimTSUVdiff in\n" outdir]);
 Ncur = Ncur+1;
 # Model Observation Difference
 #ObsSimTSUVdiff(chmnc,adcpnc,sfxnc,dagnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating NSRi figures in\n" outdir]);
 Ncur = Ncur+1;
 # Stability Criterion
 #NSRi(chmnc,adcpnc,sfxnc,dagnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating Heatfluxcompare figures in\n" outdir]);
 Ncur = Ncur+1;
 # Heat flux comparison
 #Heatfluxcompare(dagnc,sfxnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating HeatBudg figures in\n" outdir]);
 Ncur = Ncur+1;
 #Heat Budget
 #HeatBudg(chmnc,adcpnc,sfxnc,dagnc,outdir);
 waitbar(Ncur./Nfigs,waithandle,["Generating tkeBudg figures in\n" outdir]);
 Ncur = Ncur+1;
 # Turbulent Kinetic energy Budget plots
 tkeBudg(chmnc,adcpnc,sfxnc,dagnc,outdir);
 [dagpath,dagname,dagext] = fileparts(dagnc);
 tkenc = [dagpath '/' dagname "tke" dagext];
 [tkepath,tkename,tkeext] = fileparts(tkenc);
 tkezavgnc = [tkepath '/' tkename 'zavg' tkeext];
 tkebzavg(tkezavgnc,outdir);
 [outtke,outzavg,outAVG,outpypath]=tkeBudget(dagnc);
 unix(["mv " outpypath ".* " outdir]);
 waitbar(Ncur./Nfigs,waithandle,["Generating figures in\n" outdir]);
 Ncur = Ncur+1;
 close(waithandle);
end%function
