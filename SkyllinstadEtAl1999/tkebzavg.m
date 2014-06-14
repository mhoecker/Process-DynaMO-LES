function tkebzavg(zavgnc,outdir)
# Read vertical average tke budget and plot time sereis
 abrev = "tkebzavg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 zavg = netcdf(zavgnc,'r');
 t    = t0sim+zavg{"t"}(:)./(60*60*24);
 tke  = squeeze(zavg{"tke"}(:));
 wp   = squeeze(zavg{"wP"}(:));
 wtke = squeeze(zavg{"wtke"}(:));
 wb   = squeeze(zavg{"wb"}(:));
 sgs  = squeeze(zavg{"sgs"}(:));
 SP   = squeeze(zavg{"SP"}(:));
 St   = squeeze(zavg{"St"}(:));
 eps  = squeeze(zavg{"eps"}(:));
 ncclose(zavg);
 dtmatrix = ddz(t)./(60*60*24);
 dtke = dtmatrix*tke;
 if(useoctplot==1)
  allflx = wtke+sgs+wp;
  allsrc = wb+SP+eps+St;
  alltrm = allflx+allsrc;
  plotrange = [1./24,max(t),-5e-7,5e-7];
  logplotrange = [3600,max(t),1e-9,1e-5];
  subplot(7,1,1)
  plot(t,dtke,"k;dtke/dt;",t,wtke,";wtke;")
  axis(plotrange)
  subplot(7,1,2)
  plot(t,dtke,"k;dtke/dt;",t,sgs,";sgs;")
  axis(plotrange)
  subplot(7,1,3)
  plot(t,dtke,"k;dtke/dt;",t,wp)
  axis(plotrange)
  subplot(7,1,4)
  plot(t,dtke,"k;dtke/dt;")
  axis(plotrange)
  subplot(7,1,5)
  plot(t,dtke,"k;dtke/dt;")
  axis(plotrange)
  subplot(7,1,6)
  plot(t,dtke,"k;dtke/dt;")
  axis(plotrange)
  subplot(7,1,7)
  plot(t,dtke,"k;dtke/dt;")
  axis(plotrange)
 end%if
 binarray(t',[tke,dtke,wtke,sgs,wp,St,SP,wb,eps]',[outdir "/" abrev ".dat"])
 unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
end%function
