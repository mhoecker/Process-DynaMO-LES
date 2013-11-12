function plotspecVvar(roots,datdir,plotdir,term,tmp)
if nargin()<1
 roots = {'run8/dissipation/108000','run8/dissipation/86400','run8/dissipation/64800','run8/dissipation/43200','run8/dissipation/21600','run7/dissipation/14400','run7/dissipation/7200'};
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
 for i=1:length(roots)
  datname = [datdir roots{i} '.dat']
  outname = [plotdir roots{i} ]
  logform = "'10^{%L}'";
  addpath /home/mhoecker/work/Dynamo/octavescripts
  [termtxt,termsfx] = termselect(term);
  pltname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".plt"];pause(.0006);
  pltid = fopen(pltname,'w');
  fprintf(pltid,"set term %s\n",termtxt)
  fprintf(pltid,"set output '%s%s'\n",outname,termsfx)
  fprintf(pltid,"unset surface\n")
  fprintf(pltid,"set view map\n")
  fprintf(pltid,"set logscale x\n")
  fprintf(pltid,"set logscale cb\n")
  fprintf(pltid,"set logscale z\n")
  fprintf(pltid,"set xlabel 'Horizontal Wavenumber (rad/m)'\n")
  fprintf(pltid,"set ylabel 'time (s)'\n")
  fprintf(pltid,"set cblabel 'Spectral Energy Density (m^2/s^2/rad/m) '\n")
  fprintf(pltid,"unset key\n")
  fprintf(pltid,"set pm3d\n")
  fprintf(pltid,"set palette mode HSV\n")
  fprintf(pltid,"%s",paltext("pm"))
  fprintf(pltid,"set format x %s\n",logform)
  fprintf(pltid,"set format cb %s\n",logform)
  fprintf(pltid,"set cbrange [1e0:*]\n")
  fprintf(pltid,"splot '%s' binary matrix\n",datname)
  fclose(pltid)
  unix(["gnuplot " pltname ])
 end%for
end%function
