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
 dir.dat = cstrcat(outdir,"/dat/");
 dir.plt = cstrcat(outdir, "/plt/");
 dir.png = cstrcat(outdir, "/png/");
 dir.script = "/home/mhoecker/work/Dynamo/octavescripts/LESsummaries/";
 %
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 0; % simulated start time is 0
 dsim = 192; % Maximum simulation depth
 dplt = dsim*.8; % Maximum depth of plots
 tfsim = t0sim+0.5; % Simulated stop time 2011 yearday
 palcolors = 11; % number of colors in the color bar palette
 trange = [t0sim,tfsim];
 if((useoctplot==0))
  [gnuplotterm,termsfx] = termselect("pngposter");
  %
  termfile = cstrcat(dir.plt, abrev, "term.plt");
  [fid,MSG] = fopen(termfile,"w");
  fprintf(fid,"set term %s\n",gnuplotterm);
  fclose(fid);
  %
  timeticfile = cstrcat(dir.plt, abrev, "timetics.plt");
  fid = fopen(timeticfile,"w");
  fprintf(fid,"unset xtics\n");
  fprintf(fid,"set xtics out scale .5 nomirror offset 0,xtoff\n");
  fprintf(fid,"set xzeroaxis lt 0\n");
  fprintf(fid,"set xrange [%f:%f]\n",trange(1),trange(2));
  fprintf(fid,"set xtics .5\n");
  fprintf(fid,"set mxtics 12\n");
  fprintf(fid,"set xlabel offset 0,xloff\n");
  fclose(fid);
  %
  depthticfile = cstrcat(dir.plt, abrev, "depthtics.plt");
  fid = fopen(depthticfile,"w");
  fprintf(fid,"set yrange [-dplt:0]\n");
  fprintf(fid,"dytic = 10*floor(.1*3**(-1+log(dplt)/log(3)))\n");
  fprintf(fid,"set ytics -4*dytic,dytic,0\n");
  fclose(fid);
  %
  timedepthfile = cstrcat(dir.plt, abrev, "timedepth.plt");
  fid = fopen(timedepthfile,"w");
  fprintf(fid,"set size ratio 0 \n");
  fclose(fid);
  %
  limitsfile = cstrcat(dir.plt, abrev, "limits.plt");
  fid = fopen(limitsfile,"w");
  fprintf(fid,"limfile='%s'\n",limitsfile);
  fprintf(fid,"timeticfile='%s'\n",timeticfile);
  fprintf(fid,"depthticfile='%s'\n",depthticfile);
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
  fprintf(fid,"set style line 3 lt 1 lc pal frac .333 lw 1\n");
  fprintf(fid,"set style line 4 lt 1 lc pal frac .666 lw 1\n");
  fprintf(fid,"set style line 5 lt 2 lc pal frac 0 lw 1\n");
  fprintf(fid,"set style line 6 lt 2 lc pal frac 1 lw 1\n");
  fprintf(fid,"set style line 7 lt 2 lc pal frac .333 lw 1\n");
  fprintf(fid,"set style line 8 lt 2 lc pal frac .666 lw 1\n");
  fprintf(fid,"set style line 9 lt 1 lc -1 lw 1\n");
  fprintf(fid,"set style line 10 lt 1 pal frac .5 lw 1\n");
  fprintf(fid,"set style line 11 lt 1 lc -1 lw 1\n");
  fprintf(fid,"set style line 12 lt 2 lc -1 lw 1\n");
  fprintf(fid,"set style line 13 lt 1 lc rgbcolor 'grey60' lw 1\n");
  fprintf(fid,"set label 1 '' at graph 0, graph 1 left front nopoint offset character 0,character .5\n");
  fprintf(fid,"unset colorbox\n");
  fprintf(fid,"load termfile\n");
  fprintf(fid,"load scriptdir.'tlocbloc.plt'\n");
  fprintf(fid,"load timeticfile\n");
  fprintf(fid,"load depthticfile\n");
  fprintf(fid,"set xtics out scale .5 nomirror offset 0,xtoff\n");
  fprintf(fid,"set xlabel offset 0,xloff\n");
  fprintf(fid,"set ylabel offset yloff,0\n");
  fprintf(fid,"set ytics scale .5 out nomirror offset ytoff,0\n");
  fprintf(fid,"set key samplen 2\n");
  fprintf(fid,"set cblabel offset 0,0\n");
  fprintf(fid,"set cbtics scale .5 offset -ytoff,0\n");
  fprintf(fid,"cbmarks = (palcolors+1)/2\n");
  fprintf(fid,"set palette maxcolors palcolors\n");
  fprintf(fid,"%s",paltext("pmnan"));
  fclose(fid);
  %
  palfile = cstrcat(dir.plt,"sympal.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pm",palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"pospal.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pos",palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"negpal.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("neg",palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"sympalnan.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pmnan",palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"pospalnan.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("posnan",palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"negpalnan.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("negnan",palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"zissou.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("zissou",4*palcolors));
  fclose(fid);
  palfile = cstrcat(dir.plt,"circle.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("circle",36));
  fclose(fid);
  palfile = cstrcat(dir.plt,"grey.plt");
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("grey",palcolors));
  fclose(fid);
 else
    limitsfile = [""];
 end%if
end%function
