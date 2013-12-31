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
 ensureSkyllingstad1999;
 if nargin()<1
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/run8/dyno_328Rev_5-a_dag.nc'
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone1/o448_1-b_dag.nc'
  %dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone2/o512_1_dag.nc'
  dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone3/o1024_1_dag.nc'
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
  adcpnc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140.nc";
%  adcpvarnames = ["t";"z";"u";"v"];
 end%if
 if nargin()<5
  outdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/'
 end%if

 #testfig(outdir);
 #figRi(sfxnc,outdir);
 #fig1(sfxnc,chmnc,outdir);
 #fig2(chmnc,adcpnc,outdir);
 #fig3(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig3diff(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig4(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig5(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig6(chmnc,adcpnc,sfxnc,dagnc,outdir);
 #fig7(chmnc,adcpnc,sfxnc,dagnc,outdir);
 % Remove the figure ploting commands from the PATH
 removeSkyllingstad1999;
end%function

function ensureSkyllingstad1999
 % Ensure Skyllingstad1999 is in the path,
 % return the version number and date
 testpath = "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/";
 if((exist(testpath,"dir")==7).*(length(findstr(path,testpath))==0))
  addpath(testpath);
 end%if
end%function

function removeSkyllingstad1999
 % Ensure Skyllingstad1999 is in the path,
 % return the version number and date
 testpath = "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/";
 if((exist(testpath,"dir")==7).*(length(findstr(path,testpath))==0))
  rmpath(testpath);
 end%if
end%function

%figure 5
function fig5(chmnc,adcpnc,sfxnc,dagnc,outdir)
end%function


