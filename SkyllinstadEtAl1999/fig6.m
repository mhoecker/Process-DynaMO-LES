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
  binmatrix(tdag',zdag',dtkedt',[outdir "fig6adt.dat"]);
  binmatrix(tdag',zdag',dtkedt',[outdir "fig6aR.dat"]);
  binmatrix(tdag',zdag',tkePTra',[outdir "fig6b.dat"]);
  binmatrix(tdag',zdag',tkePTraRate',[outdir "fig6bR.dat"]);
  binmatrix(tdag',zdag',tkeAdve',[outdir "fig6c.dat"]);
  binmatrix(tdag',zdag',tkeAdveRate',[outdir "fig6cR.dat"]);
  binmatrix(tdag',zdag',tkeSGTr',[outdir "fig6d.dat"]);
  binmatrix(tdag',zdag',tkeSGTrRate',[outdir "fig6dR.dat"]);
  binmatrix(tdag',zdag',BuoyPr',[outdir "fig6e.dat"]);
  binmatrix(tdag',zdag',BuoyPrRate',[outdir "fig6eR.dat"]);
  binmatrix(tdag',zdag',ShPr',[outdir "fig6f.dat"]);
  binmatrix(tdag',zdag',ShPrRate',[outdir "fig6fR.dat"]);
  binmatrix(tdag',zdag',StDr',[outdir "fig6g.dat"]);
  binmatrix(tdag',zdag',StDrRate',[outdir "fig6gR.dat"]);
  binmatrix(tdag',zdag',SGPE',[outdir "fig6h.dat"]);
  binmatrix(tdag',zdag',SGPERate',[outdir "fig6hR.dat"]);
  binmatrix(tdag',zdag',PEAdv',[outdir "fig6i.dat"]);
  binmatrix(tdag',zdag',PEAdvRate',[outdir "fig6iR.dat"]);
  binmatrix(tdag',zdag',Diss',[outdir "fig6j.dat"]);
  binmatrix(tdag',zdag',DissRate',[outdir "fig6jR.dat"]);
  # invoke gnuplot
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6tab.plt");
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6.plt");
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6linR.plt");
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6logabs.plt");
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6logabsR.plt");
 end%if
 %
end%function
