function tkebzavg(zavgnc,dagnc,outdir)
# Read vertical average tke budget and plot time sereis
 abrev = "tkebzavg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss] = DAGtkeprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
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
 fil  = squeeze(zavg{"f_ave"}(:));
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
 flx = [wtke,sgs,wp];
 src = [St,SP,wb,eps,fil];
 scale = sum(abs(src),2)/2;
 data = [tke,dtke,flx,src];
 binarray(t',data',[dir.dat abrev ".dat"]);
 binarray(t',abs(data./tke)',[dir.dat "tkescale" abrev ".dat"]);
 binarray(t',(data./scale)',[dir.dat "scaled" abrev ".dat"]);
 unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
end%function
