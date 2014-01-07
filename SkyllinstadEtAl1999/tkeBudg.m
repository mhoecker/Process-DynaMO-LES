% figure 6
function tkeBudg(chmnc,adcpnc,sfxnc,dagnc,outdir)
 abrev = "tkeBudg";
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,SGPE,PEAdv,Diss] = DAGtkeprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 # calculate d/dt matrix in units of 1/sec
 ddtM = ddz(tdag)/(24*3600);
 size(ddtM)
 size(tkeavg)
 # calculate the rate of change of tke
 dtkedt = ddtM*tkeavg;
 #Scale by tke
 #tkeavg,
 notkeidx = find((tkeavg==0));
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
 SGPERate = SGPE./tkeavg;
 SGPERate(notkeidx) = 0;
 PEAdvRate = PEAdv./tkeavg;
 PEAdvRate(notkeidx)=0;
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
  binmatrix(tdag',zdag',tkeavg',[outdir abrev "a.dat"]);
  binmatrix(tdag',zdag',dtkedt',[outdir abrev "adt.dat"]);
  binmatrix(tdag',zdag',dtkedt',[outdir abrev "aR.dat"]);
  binmatrix(tdag',zdag',tkePTra',[outdir abrev "b.dat"]);
  binmatrix(tdag',zdag',tkePTraRate',[outdir abrev "bR.dat"]);
  binmatrix(tdag',zdag',tkeAdve',[outdir abrev "c.dat"]);
  binmatrix(tdag',zdag',tkeAdveRate',[outdir abrev "cR.dat"]);
  binmatrix(tdag',zdag',tkeSGTr',[outdir abrev "d.dat"]);
  binmatrix(tdag',zdag',tkeSGTrRate',[outdir abrev "dR.dat"]);
  binmatrix(tdag',zdag',BuoyPr',[outdir abrev "e.dat"]);
  binmatrix(tdag',zdag',BuoyPrRate',[outdir abrev "eR.dat"]);
  binmatrix(tdag',zdag',ShPr',[outdir abrev "f.dat"]);
  binmatrix(tdag',zdag',ShPrRate',[outdir abrev "fR.dat"]);
  binmatrix(tdag',zdag',StDr',[outdir abrev "g.dat"]);
  binmatrix(tdag',zdag',StDrRate',[outdir abrev "gR.dat"]);
  binmatrix(tdag',zdag',SGPE',[outdir abrev "h.dat"]);
  binmatrix(tdag',zdag',SGPERate',[outdir abrev "hR.dat"]);
  binmatrix(tdag',zdag',PEAdv',[outdir abrev "i.dat"]);
  binmatrix(tdag',zdag',PEAdvRate',[outdir abrev "iR.dat"]);
  binmatrix(tdag',zdag',Diss',[outdir abrev "j.dat"]);
  binmatrix(tdag',zdag',DissRate',[outdir abrev "jR.dat"]);
  # invoke gnuplot
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "tab.plt"]);
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev ".plt"]);
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "linR.plt"]);
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "logabs.plt"]);
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "logabsR.plt"]);
 end%if
 %
end%function
