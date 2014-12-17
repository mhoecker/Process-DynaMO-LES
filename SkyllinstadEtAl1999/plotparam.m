function [useoctplot,t0sim,dsim,tfsim,limitsfile,dir] = plotparam(outdir,abrev)
 % Set the plot parameters for all the plots
 if(nargin<1)
  outdir = "/home/mhoecker/tmp/";
 end%if
 if(nargin<2)
  abrev = "";
 end%if
 % Subdirectories for data, gnuplt scripts, and PNG files
 dir.out = outdir;
 dir.dat = [outdir "/dat/"];
 dir.plt = [outdir "/plt/"];
 dir.png = [outdir "/png/"];
 dir.script = "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/";
 %
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 dsim = 80; % Maximum simulation depth
 dplt = 50; % Maximum depth of plots
 tfsim = t0sim+1.25; % Simulated stop time 2011 yearday
 palcolors = 15; % number of colors in the color bar palette
 trange = [t0sim+.25,tfsim];
 if((useoctplot==0)&&(nargin>0))
  [gnuplotterm,termsfx] = termselect("pngposter");
  %
  termfile = [dir.plt abrev "term.plt"]
  [fid,MSG] = fopen(termfile,"w");
  fprintf(fid,"set term %s\n",gnuplotterm);
  fclose(fid);
  %
  timeticfile = [dir.plt abrev "timetics.plt"];
  fid = fopen(timeticfile,"w");
  fprintf(fid,"unset xtics\n");
  fprintf(fid,"set xtics out nomirror offset 0,xtoff\n")
  fprintf(fid,"set xzeroaxis ls 2 lw 2 lc rgbcolor 'grey80'\n")
  fprintf(fid,"set xrange [%f:%f]\n",trange(1),trange(2));
  fprintf(fid,"set xtics .5\n");
  fprintf(fid,"set mxtics 12\n");
  fprintf(fid,"set xlabel offset 0,xloff\n");
  fclose(fid);
  %
  limitsfile = [dir.plt abrev "limits.plt"];
  fid = fopen(limitsfile,"w");
  fprintf(fid,"limfile='%s'\n",limitsfile);
  fprintf(fid,"timeticfile='%s'\n",timeticfile);
  fprintf(fid,"termfile='%s'\n",termfile);
  fprintf(fid,"t0sim=%f\n",t0sim+.25);
  fprintf(fid,"tfsim=%f\n",tfsim);
  fprintf(fid,"dsim=%f\n",dsim);
  fprintf(fid,"dplt=%f\n",dplt);
  fprintf(fid,"palcolors=%f\n",palcolors);
  fprintf(fid,"abrev = '%s'\n",abrev);
  fprintf(fid,"outdir = '%s'\n",outdir);
  fprintf(fid,"pngdir = '%s'\n",dir.png);
  fprintf(fid,"pltdir = '%s'\n",dir.plt);
  fprintf(fid,"datdir = '%s'\n",dir.dat);
  fprintf(fid,"scriptdir = '%s'\n",dir.script);
  fprintf(fid,"termsfx = '%s'\n",termsfx);
  fprintf(fid,"set style data lines\n");
  fprintf(fid,"set style line 1 lt 1 lc pal frac 0 lw 1\n");
  fprintf(fid,"set style line 2 lt 1 lc pal frac 1 lw 1\n");
  fprintf(fid,"set style line 3 lt 2 lc pal frac .25 lw 1\n");
  fprintf(fid,"set style line 4 lt 2 lc pal frac .75 lw 1\n");
  fprintf(fid,"set style line 5 lt 3 lc pal frac .125 lw 1\n");
  fprintf(fid,"set style line 6 lt 3 lc pal frac .625 lw 1\n");
  fprintf(fid,"set style line 7 lt 4 lc pal frac .375 lw 1\n");
  fprintf(fid,"set style line 8 lt 4 lc pal frac .875 lw 1\n");
  fprintf(fid,"set style line 9 lt 1 lc -1 lw 1\n");
  fprintf(fid,"set label 1 '' at graph 0, graph 1  left front textcolor rgbcolor 'grey30' nopoint offset character 0,character .45\n");
  fprintf(fid,"unset colorbox\n");
  fprintf(fid,"load termfile\n");
  fprintf(fid,"load scriptdir.'tlocbloc.plt'\n");
  fprintf(fid,"load timeticfile\n");
  fprintf(fid,"set yrange [-dplt:0]\n");
  fprintf(fid,"dytic = dplt/2.5\n");
  fprintf(fid,"set ylabel offset yloff,0\n");
  fprintf(fid,"set xlabel offset 0,xloff\n");
  fprintf(fid,"set cblabel offset 0,0\n");
  fprintf(fid,"set ytics -dsim+.5*dytic,dytic,-0.5*dytic\n");
  fprintf(fid,"set ytics out nomirror offset ytoff,0\n");
  fprintf(fid,"set cbtics offset -ytoff,0\n");
  fprintf(fid,"cbmarks = (palcolors+1)/2\n");
  fprintf(fid,"set palette maxcolors palcolors\n");
  fprintf(fid,"%s",paltext("pmnan"));
  fclose(fid);
  %
  palfile = [dir.plt "sympal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pm",palcolors));
  fclose(fid);
  palfile = [dir.plt "pospal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pos",palcolors));
  fclose(fid);
  palfile = [dir.plt "negpal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("neg",palcolors));
  fclose(fid);
  palfile = [dir.plt "sympalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pmnan",palcolors));
  fclose(fid);
  palfile = [dir.plt "pospalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("posnan",palcolors));
  fclose(fid);
  palfile = [dir.plt "negpalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("negnan",palcolors));
  fclose(fid);
  palfile = [dir.plt "zissou.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("zissou",4*palcolors));
  fclose(fid);
  palfile = [dir.plt "circle.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("circle",36));
  fclose(fid);
 else
    limitsfile = [""];
 end%if
end%function
