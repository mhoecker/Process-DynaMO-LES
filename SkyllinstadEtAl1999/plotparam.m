function [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam(outdir,datdir,abrev)
 % Set the plot parameters for all the plots
 if(nargin==1)
  datdir = outdir;
 end%if
 if(nargin<3)
  abrev = "";
 end%if
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 dsim = 80; % Maximum simulation depth
 tfsim = t0sim+1.25; % Simulated stop time 2011 yearday
 palcolors = 15; % number of colors in the color bar palette
 scriptdir = "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/";
 if(useoctplot!=1)
  [gnuplotterm,termsfx] = termselect("pngposter");
  limitsfile = [outdir abrev "limits.plt"];
  fid = fopen(limitsfile,"w");
  fprintf(fid,"t0sim=%f\n",t0sim);
  fprintf(fid,"tfsim=%f\n",tfsim);
  fprintf(fid,"dsim=%f\n",dsim);
  fprintf(fid,"palcolors=%f\n",palcolors);
  fprintf(fid,"abrev = '%s'\n",abrev);
  fprintf(fid,"outdir = '%s'\n",outdir);
  fprintf(fid,"datdir = '%s'\n",datdir);
  fprintf(fid,"scriptdir = '%s'\n",scriptdir);
  fprintf(fid,"termsfx = '%s'\n",termsfx);
  fprintf(fid,"set term %s\n",gnuplotterm);
  fprintf(fid,"set style data lines\n");
  fprintf(fid,"set style line 1 lc pal frac 0 lw 1\n");
  fprintf(fid,"set style line 2 lc pal frac 1 lw 1\n");
  fprintf(fid,"set style line 3 lc pal frac .5 lw 1\n");
  fprintf(fid,"set style line 4 lc pal frac .25 lw 1\n");
  fprintf(fid,"set style line 5 lc pal frac .75 lw 1\n");
  fprintf(fid,"set style line 6 lc pal frac .125 lw 1\n");
  fprintf(fid,"set style line 7 lc pal frac .625 lw 1\n");
  fprintf(fid,"set style line 8 lc pal frac .375 lw 1\n");
  fprintf(fid,"set style line 9 lc pal frac .875 lw 1\n");
  fprintf(fid,"unset colorbox\n");
  fprintf(fid,"cbmarks = (palcolors+1)/2\n");
  fprintf(fid,"set palette maxcolors palcolors\n");
  fprintf(fid,"%s",paltext("pmnan"));
  fclose(fid);
  palfile = [outdir "sympal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pm",palcolors));
  fclose(fid);
  palfile = [outdir "pospal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pos",palcolors));
  fclose(fid);
  palfile = [outdir "negpal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("neg",palcolors));
  fclose(fid);
  palfile = [outdir "sympalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pmnan",palcolors));
  fclose(fid);
  palfile = [outdir "pospalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("posnan",palcolors));
  fclose(fid);
  palfile = [outdir "negpalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("negnan",palcolors));
  fclose(fid);
  palfile = [outdir "zissou.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("zissou",4*palcolors));
  fclose(fid);
 end%if
end%function
