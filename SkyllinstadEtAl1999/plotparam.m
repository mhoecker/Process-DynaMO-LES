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
 palcolors = 8; % number of colors in the color bar palette
 scriptdir = "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/";
 if(useoctplot!=1)
  [gnuplotterm,termsfx] = termselect("pngposter");
  limitsfile = [ outdir abrev "limits.plt"];
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
  fprintf(fid,"cbmarks = (palcolors+1)/2\n");
  fprintf(fid,"set palette maxcolors palcolors\n");
  fprintf(fid,"%s",paltext("euh"));
  fclose(fid);
  palfile = [outdir "sympal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pm"));
  fclose(fid);
  palfile = [outdir "pospal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pos"));
  fclose(fid);
  palfile = [outdir "negpal.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("neg"));
  fclose(fid);
  palfile = [outdir "sympalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("pmnan"));
  fclose(fid);
  palfile = [outdir "pospalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("posnan"));
  fclose(fid);
  palfile = [outdir "negpalnan.plt"];
  fid = fopen(palfile,"w");
  fprintf(fid,"%s",paltext("negnan"));
  fclose(fid);
 end%if
end%function
