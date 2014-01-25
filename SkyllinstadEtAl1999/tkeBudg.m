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
 # Calculate the time rate of change of tke
 dtkedt = ddtM*tkeavg;
 # Calculate Integrated Fluxes
 wpi = backcumsum(tkePTra,2).*dz;
 wtke = backcumsum(tkeAdve,2).*dz;
 sgs = backcumsum(tkeSGTr,2).*dz;
 # Scale by tke
 # Find the zeros of tke
 #notkeidx = find((tkeavg==0));
 #wtkeR = noNaNdiv(wtke,tke,notkeidx);
 #sgsR = noNaNdiv(sgs,tke,notkeidx);
 #dtkedtRate = noNaNdiv(dtkedt,tke,notkeidx);
 #tkePTraRate = = noNaNdiv(tkePTra,tke,notkeidx);
 #tkeAdveRate = noNaNdiv(tkeAdve,tke,notkeidx);
 #BuoyPrRate = noNaNdiv(BuoyPr,tke,notkeidx);
 #tkeSGTrRate = noNaNdiv(tkeSGTr,tke,notkeidx);
 #ShPrRate = noNaNdiv(ShPr,tke,notkeidx);
 #StDrRate = noNaNdiv(StDr,tke,notkeidx);
 #DissRate = noNaNdiv(Diss,tke,notkeidx);
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
  binmatrix(zdag',tdag',dtkedt,[outdir abrev "dtkedtT.dat"]);
  # d w' pi'd z
  binmatrix(tdag',zdag',tkePTra',[outdir abrev "dwpidz.dat"]);
  binmatrix(zdag',tdag',tkePTra,[outdir abrev "dwpidzT.dat"]);
  # w' pi'
  binmatrix(tdag',zdag',tkePTra',[outdir abrev "wpi.dat"]);
  binmatrix(zdag',tdag',tkePTra,[outdir abrev "wpiT.dat"]);
  # d w' tke d z
  binmatrix(tdag',zdag',tkeAdve',[outdir abrev "dwtkedz.dat"]);
  binmatrix(zdag',tdag',tkeAdve,[outdir abrev "dwtkedzT.dat"]);
  # w' tke
  binmatrix(tdag',zdag',tkeAdve',[outdir abrev "wtke.dat"]);
  binmatrix(zdag',tdag',tkeAdve,[outdir abrev "wtkeT.dat"]);
  # d sgs dz
  binmatrix(tdag',zdag',tkeSGTr',[outdir abrev "dsgsdz.dat"]);
  binmatrix(zdag',tdag',tkeSGTr,[outdir abrev "dsgsdzT.dat"]);
  # sgs
  binmatrix(tdag',zdag',tkeSGTr',[outdir abrev "sgs.dat"]);
  binmatrix(zdag',tdag',tkeSGTr,[outdir abrev "sgsT.dat"]);
  # b' w'
  binmatrix(tdag',zdag',BuoyPr',[outdir abrev "bw.dat"]);
  binmatrix(zdag',tdag',BuoyPr,[outdir abrev "bwT.dat"]);
  # u' u' d U d z
  binmatrix(tdag',zdag',ShPr',[outdir abrev "uudUdz.dat"]);
  binmatrix(zdag',tdag',ShPr,[outdir abrev "uudUdzT.dat"]);
  # u' u' d S d z
  binmatrix(tdag',zdag',StDr',[outdir abrev "uudSdz.dat"]);
  binmatrix(zdag',tdag',StDr,[outdir abrev "uudSdzT.dat"]);
  # dissipation
  binmatrix(tdag',zdag',Diss',[outdir abrev "diss.dat"]);
  binmatrix(zdag',tdag',Diss,[outdir abrev "dissT.dat"]);
  # write out profile plots
  fid = fopen([outdir abrev "profiles.plt"],"w");
  # Setup spacing
  plt = "rows = 1";
  fprintf(fid,"%s\n",plt);
  plt = "row = 0";
  fprintf(fid,"%s\n",plt);
  plt = "cols = 1";
  fprintf(fid,"%s\n",plt);
  plt = "col = 0";
  fprintf(fid,"%s\n",plt);
  plt = ["load " '"/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"'];
  fprintf(fid,"%s\n",plt);
  plt = "set clip one";
  fprintf(fid,"%s\n",plt);
  plt = "set ylabel 'Z(m)'";
  fprintf(fid,"%s\n",plt);
  plt = "set tmargin at screen tloc(row)";
  fprintf(fid,"%s\n",plt);
  plt = "set bmargin at screen bloc(row)";
  fprintf(fid,"%s\n",plt);
  plt = "set xlabel 'Turbulent Kinetic Energy Production/Dissipation (W/kg)'";
  fprintf(fid,"%s\n",plt);
  plt = "unset mxtics";
  fprintf(fid,"%s\n",plt);
  plt = "set style data lines";
  fprintf(fid,"%s\n",plt);
  plt = "set yzeroaxis lc rgbcolor 'grey'";
  fprintf(fid,"%s\n",plt);
  plt = "set key b r";
  fprintf(fid,"%s\n",plt);
  plt = "field1 = 'uudUdzT'";
  fprintf(fid,"%s\n",plt);
  plt = "field2 = 'uudSdzT'";
  fprintf(fid,"%s\n",plt);
  plt = "field3 = 'bwT'";
  fprintf(fid,"%s\n",plt);
  plt = "field4 = 'dissT'";
  fprintf(fid,"%s\n",plt);
  plt = "field5 = 'dwtkedzT'";
  fprintf(fid,"%s\n",plt);
  plt = "field6 = 'dwpidzT'";
  fprintf(fid,"%s\n",plt);
  plt = "field7 = 'dsgsdzT'";
  fprintf(fid,"%s\n",plt);
  %
  % Choose scaling by x/(1e-6+abs(x))
  scaled = true;
  % or none
  %scaled = false;
  %
  if(scaled)
   plt = "phi(x) = x/(10e-6+abs(x))";
   fprintf(fid,"%s\n",plt);
   plt = "set xrange[-1:1]";
   fprintf(fid,"%s\n",plt);
   plt = 'set xtics ( "-3e^{-6}" -3./4 , "-1e^{-6}" -1./2, "-3e^{-7}" -1./4, "0" 0, "+3e^{-7}" 1./4, "+1e^{-6}" 1./2, "+3e^{-6}" 3./4 ) offset 0,xtoff/2';
   fprintf(fid,"%s\n",plt);
  else
   plt = "phi(x) = x";
   fprintf(fid,"%s\n",plt);
   plt = "set xrange[dtkemin:dtkemax]";
   fprintf(fid,"%s\n",plt);
   plt = "set xtics auto";
   fprintf(fid,"%s\n",plt);
  end%if
  %
  %
  %
  pltSP = 'datdir.abrev.field1.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "SP" lc rgbcolor "red"';
  pltSt = 'datdir.abrev.field2.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "St" lc rgbcolor "green"';
  pltbw = ['datdir.abrev.field3.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "' "b'w'" '" lc rgbcolor "blue"'];
  pltep = 'datdir.abrev.field4.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "{/Symbol e}" lc rgbcolor "grey20"';
  pltwtke = ['datdir.abrev.field5.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "{/Symbol \266}_{z}' "w'tke" '" lc rgbcolor "cyan"'];
  pltwp = ['datdir.abrev.field6.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "{/Symbol \266}_{z}' "w'P'" '" lc rgbcolor "orange"'];
  pltsgs = ['datdir.abrev.field7.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "{/Symbol \266}_{z}' "sgs" '" lc rgbcolor "magenta"'];
  %
  %
%  for i=1:length(tdag)
  for i=1:length(tdag)-1
   days = floor(tdag(i));
   hours = floor((tdag(i)-days)*24);
   minutes = floor(60*(((tdag(i)-days)*24)-hours));
   seconds = floor(60*(60*(((tdag(i)-days)*24)-hours)-minutes));
   # Set save file
   plt = ["tidx = " int2str(i)];
   fprintf(fid,"%s\n",plt);
   plt = ["tval = " num2str(tdag(i))];
   fprintf(fid,"%s\n",plt);
   plt = ["ttxt = " '"' num2str(days,"%03i") '-' num2str(hours,"%02i") '-' num2str(minutes,"%02i") '-' num2str(seconds,"%02i") '"'];
   fprintf(fid,"%s\n",plt);
   %
   plt = ["set output outdir.'profiles/'.abrev." '"' num2str(i,"%06i") '"' ".termsfx" ];
   fprintf(fid,"%s\n",plt);
   plt = "set multiplot title 'tke budget profile 2011 UTC yearday '.ttxt";
   fprintf(fid,"%s\n",plt);
   plt = 'plot \';
   fprintf(fid,"%s\n",plt);
   plt = [pltSP ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltSt ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltbw ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltep ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltwtke ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltwp ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltsgs];
   fprintf(fid,"%s\n",plt);
   plt = 'unset multiplot';
   fprintf(fid,"%s\n",plt);
   %
   plt = ["set output outdir.'profiles/ProDis'.abrev." '"' num2str(i,"%06i") '"' ".termsfx" ];
   fprintf(fid,"%s\n",plt);
   plt = "set multiplot title 'tke budget profile 2011 UTC yearday '.ttxt";
   fprintf(fid,"%s\n",plt);
   plt = 'plot \';
   fprintf(fid,"%s\n",plt);
   plt = [pltSP ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltSt ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltbw ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltep];
   fprintf(fid,"%s\n",plt);
   plt = 'unset multiplot';
   fprintf(fid,"%s\n",plt);
   %
   plt = ["set output outdir.'profiles/FlxDiv'.abrev." '"' num2str(i,"%06i") '"' ".termsfx" ];
   fprintf(fid,"%s\n",plt);
   plt = "set multiplot title 'tke budget profile 2011 UTC yearday '.ttxt";
   fprintf(fid,"%s\n",plt);
   plt = 'plot \';
   fprintf(fid,"%s\n",plt);
   plt = [pltwtke ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltwp ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltsgs];
   fprintf(fid,"%s\n",plt);
   plt = 'unset multiplot';
   fprintf(fid,"%s\n",plt);
   %
  end%for
   fclose(fid);
  # invoke gnuplot
  #unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev "tab.plt"]);
  unix(["gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/" abrev ".plt"]);
  unix(["pngmovie.sh -l " outdir "profiles/tkeBudg -n " outdir "profiles/tkeBudg -f 30"]);
  unix(["pngmovie.sh -l " outdir "profiles/ProDistkeBudg -n " outdir "profiles/ProDistkeBudg -f 30"]);
  unix(["pngmovie.sh -l " outdir "profiles/FlxDivtkeBudg -n " outdir "profiles/FlxDivtkeBudg -f 30"]);
 end%if
 %
end%function

function [quotient,idxBzero] =  noNaNdiv(A,B,idxBzero)
# divide A by B and replace division by zero in quotient with zero
 if (nargin()<2)
  B=A
 end%if
 if (nargin()<3)
  idxBzero = find((B==0));
 end%if
 quotient = A./B;
 quotient(idxBzero) = 0;
end%function
