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
 #Scale by tke
 #tkeavg,
 tkePTraRate = tkePTra./tkeavg;
 tkeAdveRate = tkeAdve./tkeavg;
 BuoyPrRate = BuoyPr./tkeavg;
 tkeSGTrRate = tkeSGTr./tkeavg;
 ShPrRate = ShPr./tkeavg;
 StDrRate = StDr./tkeavg;
 SGPERate = SGPE./tkeavg;
 PEAdvRate = PEAdv./tkeavg;
 DissRate = Diss./tkeavg;
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
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig6.plt");
 end%if
 %
end%function
