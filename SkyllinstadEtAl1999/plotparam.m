function [useoctplot,t0sim,dsim,tfsim] = plotparam(outdir,datdir)
 % Set the plot parameters for all the plots
 useoctplot=0; % 1 plot using octave syntax, 0 use gnuplot script
 t0sim = 328; % simulated start time is 2011 yearday 328
 dsim = 80; % Maximum simulation depth
 tfsim = t0sim+1; % Simulated stop time 2011 yearday
 palcolors = 9; % number of colors in the color bar palette
 if(nargin==1)
  datdir = outdir;
 end%if
 if(useoctplot!=1)
  [gnuplotterm,termsfx] = termselect("pngposter");
  limitsfile = [outdir "limits.plt"];
  fid = fopen(limitsfile,"w");
  fprintf(fid,"t0sim=%f\n",t0sim);
  fprintf(fid,"tfsim=%f\n",tfsim);
  fprintf(fid,"dsim=%f\n",dsim);
  fprintf(fid,"palcolors=%f\n",palcolors);
  fprintf(fid,"outdir = '%s'\n",outdir);
  fprintf(fid,"datdir = '%s'\n",datdir);
  fprintf(fid,"termsfx = '%s'\n",termsfx);
  fprintf(fid,"set term %s\n",gnuplotterm);
  fprintf(fid,"cbmarks = (palcolors+1)/2\n");
  fprintf(fid,"set palette maxcolors palcolors\n");
  fprintf(fid,"%s",paltext("hue"));
  fclose(fid);
 end%if
end%function
