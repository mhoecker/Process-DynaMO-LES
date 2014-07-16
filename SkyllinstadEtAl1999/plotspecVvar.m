function plotspecVvar(roots,datdir,plotdir,term,tmp)
if nargin()<1
 roots = {'yellowstone6/dissipation/86400cSpectra-tke','yellowstone6/dissipation/86400cSpectra-u','yellowstone6/dissipation/86400cSpectra-v','yellowstone6/dissipation/86400cSpectra-w','yellowstone6/dissipation/86400cSpectra-t'};
 %{'run8/dissipation/108000','run8/dissipation/86400','run8/dissipation/64800','run8/dissipation/43200','run8/dissipation/21600','run7/dissipation/14400','run7/dissipation/7200'};
 end%if
 if nargin()<2
  datdir = '/home/mhoecker/work/Dynamo/plots/';
 end%if
 if nargin()<3
  plotdir = datdir;
 end%if
 if nargin()<4
  term = 'png';
 end%if
 if nargin()<5
  tmp  = '/home/mhoecker/tmp/';
 end%if
 abrev ="plotspecVvar";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(plotdir,datdir,abrev);
 for i=1:length(roots)
  datname = [datdir roots{i} '.dat'];
  outname = [plotdir roots{i} ];
  logform = "'10^{%L}'";
  addpath /home/mhoecker/work/Dynamo/octavescripts
  [termtxt,termsfx] = termselect(term);
  pltname = [tmp num2str(floor((now-floor(now))*24*60*60*1000),"%011i") ".plt"];pause(.0006);
  pltid = fopen(pltname,'w');
  fprintf(pltid,"load '%s'\n",limitsfile)
  fprintf(pltid,"load '%spospal.plt'\n",plotdir)
  fprintf(pltid,"set output '%s'.termsfx\n",outname)
  fprintf(pltid,"unset surface\n")
  fprintf(pltid,"set view map\n")
  fprintf(pltid,"set xlabel 'Horizontal Wavenumber (rad/m)' offset 0,.5\n")
  fprintf(pltid,"set ylabel 'Depth (m)'\n")
  fprintf(pltid,"set cblabel 'Spectral Energy Density (m^2/s^2) ' offset 0.5\n")
  fprintf(pltid,"set cbtics offset -1\n")
  fprintf(pltid,"unset key\n")
  fprintf(pltid,"set pm3d\n")
  fprintf(pltid,"set format x %s\n",logform)
  fprintf(pltid,"set format cb %s\n",logform)
  fprintf(pltid,"stats '%s' binary matrix u 3\n",datname)
  fprintf(pltid,"set logscale x\n")
  fprintf(pltid,"set logscale cb\n")
  fprintf(pltid,"set logscale z\n")
  fprintf(pltid,"set cbrange [STATS_mean/4:STATS_max/4]\n")
  fprintf(pltid,"splot '%s' binary matrix u 1:2:($1*$3)\n",datname)
  fclose(pltid)
  unix(["gnuplot " pltname ])
 end%for
end%function
