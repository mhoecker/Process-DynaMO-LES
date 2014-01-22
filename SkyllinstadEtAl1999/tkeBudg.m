% figure 6
function tkeBudg(chmnc,adcpnc,sfxnc,dagnc,outdir)
 abrev = "tkeBudg";
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 #[tsfx,stress,p,Jh,wdir] = surfaceflux(sfxnc,trange);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss] = DAGtkeprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 # calculate d/dt matrix in units of 1/sec
 ddtM = ddz(tdag)/(24*3600);
 # calculate dz for integrals
 dz = trapdiff(zdag)';
 # Find the zeros of tke
 notkeidx = find((tkeavg==0));
 # calculate the rate of change of tke
 dtkedt = ddtM*tkeavg;
 #Calculate Fluxes (integrate fluxes  )
 wpi = backcumsum(tkePTra,2).*dz;
 wpiR = wpi./tkeavg;
 wpiR(notkeidx) = 0;
 wtke = backcumsum(tkeAdve,2).*dz;
 wtkeR = wtke./tkeavg;
 wtkeR(notkeidx) = 0;
 sgs = backcumsum(tkeSGTr,2).*dz;
 sgsR = sgs./tkeavg;
 sgsR(notkeidx) = 0;
 #Scale by tke
 dtkedtRate = dtkedt./tkeavg;
 dtkedtRate(notkeidx) = 0;
 tkePTraRate = tkePTra./tkeavg;
 tkePTraRate(notkeidx) = 0;
 tkeAdveRate = tkeAdve./tkeavg;
 tkeAdveRate(notkeidx) = 0;
 BuoyPrRate = BuoyPr./tkeavg;
 BuoyPrRate(notkeidx)=0;
 tkeSGTrRate = tkeSGTr./tkeavg;
 tkeSGTrRate(notkeidx)=0;
 ShPrRate = ShPr./tkeavg;
 ShPrRate(notkeidx)=0;
 StDrRate = StDr./tkeavg;
 StDrRate(notkeidx)=0;
 DissRate = Diss./tkeavg;
 DissRate(notkeidx)=0;
 if(useoctplot==1)
  # Make co-ordinate 2-D arrays from lists
  [ttchm,zzchm] = meshgrid(tchm,zchm);
  #[ttadcp,zzadcp] = meshgrid(tadcp,zadcp);
  [ttdag,zzdag] = meshgrid(tdag,zdag);
  plotrows = 9;
  plotcols = 1;
  plotnumb = 0;
  commoncaxis = [-.005,.005];
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
  print([outdir abrev ".png"],"-dpng","-S1280,1536")
 else
  # save files for gnuplot
  # tke
  binmatrix(tdag',zdag',tkeavg',[outdir abrev "tke.dat"]);
  # d tke d t
  binmatrix(tdag',zdag',dtkedt',[outdir abrev "dtkedt.dat"]);
  binmatrix(tdag',zdag',dtkedt',[outdir abrev "dtkedtR.dat"]);
  # d w' pi'd z
  binmatrix(tdag',zdag',tkePTra',[outdir abrev "dwpidz.dat"]);
  binmatrix(tdag',zdag',tkePTraRate',[outdir abrev "dwpidzR.dat"]);
  # w' pi'
  binmatrix(tdag',zdag',tkePTra',[outdir abrev "wpi.dat"]);
  binmatrix(tdag',zdag',tkePTraRate',[outdir abrev "wpiR.dat"]);
  # d w' tke d z
  binmatrix(tdag',zdag',tkeAdve',[outdir abrev "dwtkedz.dat"]);
  binmatrix(tdag',zdag',tkeAdveRate',[outdir abrev "dwtkedzR.dat"]);
  # w' tke
  binmatrix(tdag',zdag',tkeAdve',[outdir abrev "wtke.dat"]);
  binmatrix(tdag',zdag',tkeAdveRate',[outdir abrev "wtkeR.dat"]);
  # d sgs dz
  binmatrix(tdag',zdag',tkeSGTr',[outdir abrev "dsgsdz.dat"]);
  binmatrix(tdag',zdag',tkeSGTrRate',[outdir abrev "dsgsdzR.dat"]);
  # sgs
  binmatrix(tdag',zdag',tkeSGTr',[outdir abrev "sgs.dat"]);
  binmatrix(tdag',zdag',tkeSGTrRate',[outdir abrev "sgsR.dat"]);
  # b' w'
  binmatrix(tdag',zdag',BuoyPr',[outdir abrev "bw.dat"]);
  binmatrix(tdag',zdag',BuoyPrRate',[outdir abrev "bwR.dat"]);
  # u' u' d U d z
  binmatrix(tdag',zdag',ShPr',[outdir abrev "uudUdz.dat"]);
  binmatrix(tdag',zdag',ShPrRate',[outdir abrev "uudUdzR.dat"]);
  # u' u' d S d z
  binmatrix(tdag',zdag',StDr',[outdir abrev "uudSdz.dat"]);
  binmatrix(tdag',zdag',StDrRate',[outdir abrev "uudSdzR.dat"]);
  # dissipation
  binmatrix(tdag',zdag',Diss',[outdir abrev "diss.dat"]);
  binmatrix(tdag',zdag',DissRate',[outdir abrev "dissR.dat"]);
  # invoke gnuplot
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "tab.plt"]);
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev ".plt"]);
  #unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "linR.plt"]);
  #unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "logabs.plt"]);
  #unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "logabsR.plt"]);
 end%if
 %
end%function
