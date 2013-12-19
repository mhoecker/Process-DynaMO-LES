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
 figRi(sfxnc,outdir);
 fig1(sfxnc,chmnc,outdir);
 fig2(chmnc,adcpnc,outdir);
 fig3(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig3diff(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig4(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig5(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig6(chmnc,adcpnc,sfxnc,dagnc,outdir);
 fig7(chmnc,adcpnc,sfxnc,dagnc,outdir);
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

function [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,SGPE,PEAdv,Diss] = DAGtkeprofiles(dagnc,trange,zrange)
 % Extract diagnostic profiles
 dag      = netcdf(dagnc,'r');
 tdag     = squeeze(dag{'time'}(:));
 if nargin()>1
  dagtidx = inclusiverange(tdag,trange);
 else
  dagtidx = 1:length(tdag);
 end%if
 % restict depth range
 zdag     = -squeeze(dag{'zzu'}(:));
 if nargin()>2
  dagzidx = inclusiverange(zdag,zrange);
 else
  dagzidx = 1:length(zdag);
 end%if
 tdag     = squeeze(dag{'time'}(dagtidx));
 zdag     = -squeeze(dag{'zzu'}(dagzidx));
 tkeavg   = squeeze(dag{'tke_ave'}(dagtidx,dagzidx,1,1));
 tkePTra  = squeeze(dag{'p_ave'}(dagtidx,dagzidx,1,1));
 tkeAdve  = squeeze(dag{'a_ave'}(dagtidx,dagzidx,1,1));
 BuoyPr  = squeeze(dag{'b_ave'}(dagtidx,dagzidx,1,1));
 tkeSGTr  = squeeze(dag{'sg_ave'}(dagtidx,dagzidx,1,1));
 ShPr  = -squeeze(dag{'sp_ave'}(dagtidx,dagzidx,1,1));
 StDr  = squeeze(dag{'sd_ave'}(dagtidx,dagzidx,1,1));
 SGPE  = squeeze(dag{'dpesg'}(dagtidx,dagzidx,1,1));
 PEAdv  = squeeze(dag{'dpea'}(dagtidx,dagzidx,1,1));
 Diss  = squeeze(dag{'disp_ave'}(dagtidx,dagzidx,1,1));
 ncclose(dag);
end%function

function [tdag,zdag,uavgdag,vavgdag,Tavgdag,Savgdag,tkeavg,tkePTra,tkeAdve,tkeBuoy,tkeSGTr,tkeSPro,tkeStDr,tkeSGPE,tkeDiss] = DAGprofiles(dagnc,trange,zrange)
 % Extract diagnostic profiles
 field = ['time';'zzu'];
 field = [field;'u_ave';'v_ave';'t_ave'];
 field = [field;'tke_ave';'p_ave';'a_ave'];
 field = [field;'b_ave';'sg_ave';'sp_ave'];
 field = [field;'sd_ave';'dpesg','disp_ave'];
 dag=dagvars(dagnc,field,trange,zrange)
 % Parse the output
 tdag     = dag.time;
 zdag     = dag.zzu;
 uavgdag  = dag.u_ave;
 vavgdag  = dag.v_ave;
 Tavgdag  = dag.t_ave;
 Savgdag  = dag.s_ave;
 tkeavg   = dag.tke_ave;
 tkePTra  = dag.p_ave;
 tkeAdve  = dag.a_ave;
 tkeBuoy  = dag.b_ave;
 tkeSGTr  = dag.sg_ave;
 tkeSPro  = dag.sp_ave;
 tkeStDr  = dag.sd_ave;
 tkeSGPE  = dag.dpesg;
 tkeDiss  = dag.disp_ave;
end%function

function testfig(outdir)
 [useoctplot,t0sim,dsim,tfsim] = plotparam(outdir);
 if(useoctplot!=1)
  testfile = [outdir "test.plt"];
  fid = fopen(testfile,"w");
  fprintf(fid,"load '%slimits.plt'\n",outdir);
  fprintf(fid,"set output outdir.'test'.termsfx\n");
  fprintf(fid,"test\n",tfsim);
  fclose(fid);
  unix(["gnuplot " testfile]);
 end%if
end%function

%figure 5
function fig5(chmnc,adcpnc,sfxnc,dagnc,outdir)
end%function

% figure Ri
function figRi(sfxnc,outdir)
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim-4,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange);
 # Calulatwe the Driven Richarson number
 [Ri,Jb]  = surfaceRi(stress,Jh,sst,sal);
 figure(1)
 subplot(3,1,1)
 plot(tsfx,Jb)
 axis([trange,0,max(Jb)])
 subplot(3,1,2)
 semilogy(tsfx,.25*stress.^2)
 axis([trange])
 subplot(3,1,3)
 plot(tsfx,sign(4*Ri)+sign(4*Ri-1))
 axis([trange,-2.5,2.5])
end%function

% figure 6
function fig6(chmnc,adcpnc,sfxnc,dagnc,outdir)
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange);
 # Calulatwe the Driven Richarson number
 [Ri,alpha,g,nu,kappaT]  = surfaceRi(stress,Jh,sst,sal);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,SGPE,PEAdv,Diss] = DAGtkeprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 #
 if(useoctplot==1)
  # Make co-ordinate 2-D arrays from lists
  [ttchm,zzchm] = meshgrid(tchm,zchm);
  #[ttadcp,zzadcp] = meshgrid(tadcp,zadcp);
  [ttdag,zzdag] = meshgrid(tdag,zdag);
  plotrows = 9;
  plotcols = 1;
  plotnumb = 0;
  commoncaxis = [-.005,.005];
  # Surface Ri#
  %plotnumb = plotnumb+1;
  %subplot(plotrows,plotcols,plotnumb)
  %plot(tsfx,4*Ri,tsfx,ones(size(tsfx)),"k",tsfx,0*ones(size(tsfx)),"k-",tsfx,-ones(size(tsfx)),"k")
  %ylabel("4Ri")
  %axis([trange,-2,2])
  #  tke #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,log(tkeavg'));
  shading flat
  ylabel("log_{10} tke")
  title("All plots (except tke) scaled by tke")
  caxis([-10,0]+log(max(max(tkeavg))))
  colorbar
  # Pressure Transport of tke #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkePTra'./tkeavg');
  shading flat
  ylabel("P trans.")
  caxis(commoncaxis)
  colorbar
  # Advection Transport of tke #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeAdve'./tkeavg');
  shading flat
  ylabel("Advect.")
  caxis(commoncaxis)
  colorbar
  # Buoyancy Production of tke #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeBuoy'./tkeavg');
  shading flat
  ylabel("Buoy. Prod.")
  caxis(commoncaxis)
  colorbar
  # Sub-gridscale tramsport of tke #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeSGTr'./tkeavg');
  shading flat
  caxis(commoncaxis)
  ylabel("SGS trans.")
  colorbar
  # Shear Production #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeSPro'./tkeavg');
  shading flat
  caxis(commoncaxis)
  ylabel("Shear Prod.")
  colorbar
  # Stokes Drift #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeStDr'./tkeavg');
  shading flat
  ylabel("Stokes Drift")
  caxis(commoncaxis)
  colorbar
  # Sub-gridscale potential energy #
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeSGPE'./tkeavg');
  shading flat
  ylabel("SGS PE")
  caxis(commoncaxis)
  colorbar
  # tkeDiss
  plotnumb = plotnumb+1;
  subplot(plotrows,plotcols,plotnumb)
  pcolor(ttdag,zzdag,tkeDiss'./tkeavg');
  shading flat
  ylabel("Dissipation")
  caxis(commoncaxis)
  colorbar
  # Print #
  print([outdir "fig6.png"],"-dpng","-S1280,1536")
 else
  # save files for gnuplot
  binmatrix(tdag',zdag',tkeavg',[outdir "fig6a.dat"]);
  binmatrix(tdag',zdag',tkePTra'./tkeavg',[outdir "fig6b.dat"]);
  binmatrix(tdag',zdag',tkeAdve'./tkeavg',[outdir "fig6c.dat"]);
  binmatrix(tdag',zdag',tkeSGTr'./tkeavg',[outdir "fig6d.dat"]);
  binmatrix(tdag',zdag',BuoyPr'./tkeavg',[outdir "fig6e.dat"]);
  binmatrix(tdag',zdag',ShPr'./tkeavg',[outdir "fig6f.dat"]);
  binmatrix(tdag',zdag',StDr'./tkeavg',[outdir "fig6g.dat"]);
  binmatrix(tdag',zdag',SGPE'./tkeavg',[outdir "fig6h.dat"]);
  binmatrix(tdag',zdag',PEAdv'./tkeavg',[outdir "fig6i.dat"]);
  binmatrix(tdag',zdag',Diss'./tkeavg',[outdir "fig6j.dat"]);
  # invoke gnuplot
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6.plt");
 end%if
 %
end%function
