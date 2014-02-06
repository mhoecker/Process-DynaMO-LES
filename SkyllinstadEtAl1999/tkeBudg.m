% figure 6
function tkeBudg(chmnc,adcpnc,sfxnc,dagnc,outdir)
 abrev = "tkeBudg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
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
  fid = fopen([outdir "profiles/" abrev ".plt"],"w");
  #
  plt = 'set style data lines';
  fprintf(fid,"%s\n",plt);
  plt = 'abrev = "tkeBudg"';
  fprintf(fid,"%s\n",plt);
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
  plt = "unset mxtics";
  fprintf(fid,"%s\n",plt);
  plt = "set style data lines";
  fprintf(fid,"%s\n",plt);
  plt = "set yzeroaxis lc rgbcolor 'grey'";
  fprintf(fid,"%s\n",plt);
  plt = "set key b r opaque sample 1";
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
  plt = "field8 = 'wtkeT'";
  fprintf(fid,"%s\n",plt);
  plt = "field9 = 'wpiT'";
  fprintf(fid,"%s\n",plt);
  plt = "field10 = 'sgsT'";
  fprintf(fid,"%s\n",plt);
  %
  % Choose scaling by x/(1e-6+abs(x))
  %
  plt = "spow = -6";
  fprintf(fid,"%s\n",plt);
  plt = "sman = 4";
  fprintf(fid,"%s\n",plt);
  plt = "scale = 10**spow";
  fprintf(fid,"%s\n",plt);
  plt = "phi(x) = x/(sman*scale+abs(x))";
  fprintf(fid,"%s\n",plt);
  plt = "set xrange[-1:1]";
  fprintf(fid,"%s\n",plt);
  zeroticlab = ' "0" 0 ';
  oneticlabs = ' "1" phi(scale), "-1" phi(-scale) ';
  twoninetics = ' "" phi(-2*scale), "" phi(2*scale), "" phi(-3*scale), "" phi(3*scale), "" phi(4*scale), "" phi(-4*scale), "" phi(5*scale), "" phi(-5*scale), "" phi(6*scale), "" phi(-6*scale), "" phi(7*scale), "" phi(-7*scale), "" phi(8*scale), "" phi(-8*scale), "" phi(9*scale), "" phi(-9*scale) ';
  tenticlabs = ' "10" phi(10*scale), "-10" phi(-10*scale) ';
  twentyninetytics = '"" phi(20*scale), "" phi(-20*scale), "" phi(30*scale), "" phi(-30*scale), "" phi(40*scale), "" phi(-40*scale), "" phi(50*scale), "" phi(-50*scale), "" phi(60*scale), "" phi(-60*scale), "" phi(70*scale), "" phi(-70*scale), "" phi(80*scale), "" phi(-80*scale), "" phi(90*scale), "" phi(-90*scale)';
  hundredticlabs = ' "100" phi(100*scale), "-100" phi(-100*scale) ';
  hundredtics = ' "" phi(100*scale), "" phi(-100*scale) ';
  twoninehundredtics = ' "" phi(-200*scale), "" phi(200*scale), "" phi(-300*scale), "" phi(300*scale), "" phi(-400*scale), "" phi(400*scale), "" phi(-500*scale), "" phi(500*scale), "" phi(-600*scale), "" phi(600*scale), "" phi(-700*scale), "" phi(700*scale), "" phi(-800*scale), "" phi(800*scale), "" phi(-900*scale), "" phi(900*scale) ';
  thousandticlabs = ' "1000" phi(1000*scale), "-1000" phi(-1000*scale) ';
  plt = 'set xtics offset 0,xtoff';
  fprintf(fid,"%s\n",plt);
  fprintf(fid,"set xtics (%s)\n",zeroticlab);
  fprintf(fid,"set xtics add (%s)\n",oneticlabs);
  fprintf(fid,"set xtics add (%s)\n",twoninetics);
  fprintf(fid,"set xtics add (%s)\n",tenticlabs);
  fprintf(fid,"set xtics add (%s)\n",twentyninetytics);
  fprintf(fid,"set xtics add (%s)\n",hundredticlabs);
  fprintf(fid,"set xtics add (%s)\n",twoninehundredtics);
  plt = ["set xlabel 'Turbulent Kinetic Energy Production/Dissipation (10^{'.spow.'}W/kg)'"];
  fprintf(fid,"%s\n",plt);
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
  pltwtkefx = ['datdir.abrev.field8.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "' "w'tke" '" lc rgbcolor "cyan"'];
  pltwpfx = ['datdir.abrev.field9.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "' "w'P'" '" lc rgbcolor "orange"'];
  pltsgsfx = ['datdir.abrev.field10.".dat" binary matrix u (phi($3)):1 every :::tidx::tidx title "sgs" lc rgbcolor "magenta"'];
  %
  %
  Nsteps = length(tdag)-1;
  Nskip = 1;
  for i=1:Nskip:Nsteps
   # Set save file
   [days,hours,minutes,seconds] = tag2dhms(tdag(i));
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
  # Setup two collumn spacing
  plt = "rows = 1";
  fprintf(fid,"%s\n",plt);
  plt = "row = 0";
  fprintf(fid,"%s\n",plt);
  plt = "cols = 2";
  fprintf(fid,"%s\n",plt);
  plt = "col = -1";
  fprintf(fid,"%s\n",plt);
  plt = 'set xtics offset 0,xtoff';
  fprintf(fid,"%s\n",plt);
  fprintf(fid,"set xtics (%s)\n",zeroticlab);
  fprintf(fid,"set xtics add (%s)\n",oneticlabs);
  fprintf(fid,"set xtics add (%s)\n",twoninetics);
  fprintf(fid,"set xtics add (%s)\n",tenticlabs);
  fprintf(fid,"set xtics add (%s)\n",twentyninetytics);
  fprintf(fid,"set xtics add (%s)\n",hundredtics);
  fprintf(fid,"set xtics add (%s)\n",twoninehundredtics);
  for i=1:Nskip:Nsteps
   # Set time labels
   [days,hours,minutes,seconds] = tag2dhms(tdag(i));
   plt = ["ttxt = " '"' num2str(days,"%03i") '-' num2str(hours,"%02i") '-' num2str(minutes,"%02i") '-' num2str(seconds,"%02i") '"'];
   fprintf(fid,"%s\n",plt);
   plt = ["tidx = " int2str(i)];
   fprintf(fid,"%s\n",plt);
   plt = ["tval = " num2str(tdag(i))];
   fprintf(fid,"%s\n",plt);
   # Set filename
   plt = ["set output outdir.'profiles/Flx'.abrev." '"' num2str(i,"%06i") '"' ".termsfx" ];
   fprintf(fid,"%s\n",plt);
   # Set overalll title
   plt = "set multiplot title 'Turbulent Kinetic Energy 2011 UTC yearday '.ttxt";
   fprintf(fid,"%s\n",plt);
   #
   plt = "set ylabel 'Z(m)'";
   fprintf(fid,"%s\n",plt);
   plt = "set format y '%g'";
   fprintf(fid,"%s\n",plt);
   plt = "col = nextcol(col)";
   fprintf(fid,"%s\n",plt);
   plt = "set lmargin at screen lloc(col)";
   fprintf(fid,"%s\n",plt);
   plt = "set rmargin at screen rloc(col)";
   fprintf(fid,"%s\n",plt);
   plt = ["set xlabel 'Production/Dissipation (10^{'.spow.'}W/kg)'"];
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
   #
   plt = "set ylabel ''";
   fprintf(fid,"%s\n",plt);
   plt = "set format y ''";
   fprintf(fid,"%s\n",plt);
   plt = "col = nextcol(col)";
   fprintf(fid,"%s\n",plt);
   plt = "set lmargin at screen lloc(col)";
   fprintf(fid,"%s\n",plt);
   plt = "set rmargin at screen rloc(col)";
   fprintf(fid,"%s\n",plt);
   plt = "set xlabel 'Transport (10^{'.spow.'}Wm/kg)'";
   fprintf(fid,"%s\n",plt);
   plt = 'plot \';
   fprintf(fid,"%s\n",plt);
   plt = [pltwtkefx ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltwpfx ',\'];
   fprintf(fid,"%s\n",plt);
   plt = [pltsgsfx];
   fprintf(fid,"%s\n",plt);
   plt = 'unset multiplot';
   fprintf(fid,"%s\n",plt);
  end%for
  fclose(fid);
  # invoke gnuplot
  unix(["gnuplot " limitsfile " " scriptdir abrev "tab.plt"]);
  unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
  unix(["gnuplot " limitsfile " " outdir "/profiles/" abrev ".plt"]);
  # Make movies
  movies = 1;
  if(movies)
   profiledir = [outdir "profiles/"];
   frameloc = [profiledir abrev];
   unix(moviemaker(frameloc,frameloc,"30","avi"));
   frameloc = [profiledir "ProDis" abrev];
   unix(moviemaker(frameloc,frameloc,"30","avi"));
   frameloc = [profiledir "FlxDiv" abrev];
   unix(moviemaker(frameloc,frameloc,"30","avi"));
   frameloc = [profiledir "Flx" abrev];
   unix(moviemaker(frameloc,frameloc,"30","avi"));
  end%if
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

function [days,hours,minutes,seconds] = tag2dhms(tdag)
   days = floor(tdag);
   hours = floor((tdag-days)*24);
   minutes = floor(60*(((tdag-days)*24)-hours));
   seconds = floor(60*(60*(((tdag-days)*24)-hours)-minutes));
end%function

function callmovie = moviemaker(frameloc,movieloc,framerate,type)
 callmovie = "pngmovie.sh";
 if(nargin()>0)
  callmovie = [callmovie " -l " frameloc];
 end%if
 if(nargin()>1)
  callmovie = [callmovie " -n " movieloc];
 end%if
 if(nargin()>2)
  callmovie = [callmovie " -f " framerate];
 end%if
 if(nargin()>3)
  callmovie = [callmovie " -t " type];
 end%if
  callmovie = [callmovie " >> " movieloc ".log" ];
end%function
