% figure 6
function tkeBudg(dagnc,outdir,SPcontour,SPval)
 abrev = "tkeBudg";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
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
 wpi = cumsum(tkePTra,2).*dz;
 #idxtop = find(abs(zdag)<=abs(1))
 #zdag(idxtop)
 #wpi(idxtop) = NaN;
 wtke = -cumsum(tkeAdve,2).*dz;
 sgs = -cumsum(tkeSGTr,2).*dz;
 # save files for gnuplot
 # tke
 binmatrix(tdag',zdag',tkeavg',[dir.dat abrev "tke.dat"]);
 # d tke d t
 binmatrix(tdag',zdag',dtkedt',[dir.dat abrev "dtkedt.dat"]);
 binmatrix(zdag',tdag',dtkedt,[dir.dat abrev "dtkedtT.dat"]);
 # d w' pi'd z
 binmatrix(tdag',zdag',tkePTra',[dir.dat abrev "dwpidz.dat"]);
 binmatrix(zdag',tdag',tkePTra,[dir.dat abrev "dwpidzT.dat"]);
 # w' pi'
 binmatrix(tdag',zdag',wpi',[dir.dat abrev "wpi.dat"]);
 binmatrix(zdag',tdag',wpi,[dir.dat abrev "wpiT.dat"]);
 # d w' tke d z
 binmatrix(tdag',zdag',tkeAdve',[dir.dat abrev "dwtkedz.dat"]);
 binmatrix(zdag',tdag',tkeAdve,[dir.dat abrev "dwtkedzT.dat"]);
 # w' tke
 binmatrix(tdag',zdag',wtke',[dir.dat abrev "wtke.dat"]);
 binmatrix(zdag',tdag',wtke,[dir.dat abrev "wtkeT.dat"]);
 # d sgs dz
 binmatrix(tdag',zdag',tkeSGTr',[dir.dat abrev "dsgsdz.dat"]);
 binmatrix(zdag',tdag',tkeSGTr,[dir.dat abrev "dsgsdzT.dat"]);
 # sgs
 binmatrix(tdag',zdag',sgs',[dir.dat abrev "sgs.dat"]);
 binmatrix(zdag',tdag',sgs,[dir.dat abrev "sgsT.dat"]);
 # b' w'
 binmatrix(tdag',zdag',BuoyPr',[dir.dat abrev "bw.dat"]);
 binmatrix(zdag',tdag',BuoyPr,[dir.dat abrev "bwT.dat"]);
 # u' u' d U d z
 binmatrix(tdag',zdag',ShPr',[dir.dat abrev "uudUdz.dat"]);
 binmatrix(zdag',tdag',ShPr,[dir.dat abrev "uudUdzT.dat"]);
 # u' u' d S d z
 binmatrix(tdag',zdag',StDr',[dir.dat abrev "uudSdz.dat"]);
 binmatrix(zdag',tdag',StDr,[dir.dat abrev "uudSdzT.dat"]);
 # dissipation
 binmatrix(tdag',zdag',Diss',[dir.dat abrev "diss.dat"]);
 binmatrix(zdag',tdag',Diss,[dir.dat abrev "dissT.dat"]);
 #
 if(nargin>2)
  fid = fopen(limitsfile,'a');
  fprintf(fid,"SPcontour = '%s'\n",SPcontour);
  fprintf(fid,"SPpc = %i\n",SPval);
  fclose(fid);
 end%if
 # Invoke gnuplot for main plots
 unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
 # Make profile movies
 movies = 0;
 if(movies)
  # write out profile plots
  fid = fopen([dir.plt "profiles/" abrev ".plt"],"w");
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
  unix(["gnuplot " limitsfile " " outdir "/profiles/" abrev ".plt"]);
  profiledir = [dir.plt "profiles/"];
  frameloc = [profiledir abrev];
  unix(moviemaker(frameloc,frameloc,"30","avi"));
  frameloc = [profiledir "ProDis" abrev];
  unix(moviemaker(frameloc,frameloc,"30","avi"));
  frameloc = [profiledir "FlxDiv" abrev];
  unix(moviemaker(frameloc,frameloc,"30","avi"));
  frameloc = [profiledir "Flx" abrev];
  unix(moviemaker(frameloc,frameloc,"30","avi"));
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
