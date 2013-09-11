term = 'png';
tmp  = '/home/mhoecker/tmp/';
datdir = '/home/mhoecker/work/Dynamo/plots/';
plotdir = '/home/mhoecker/work/Dynamo/plots/';
roots = {'run8/dissipation/108000','run8/dissipation/86400','run8/dissipation/64800','run8/dissipation/43200','run8/dissipation/21600','run7/dissipation/14400','run7/dissipation/7200'};
for i=1:length(roots)
datname = [datdir roots{i} 'Hspectra-all.dat'];
outname = [plotdir roots{i} 'Hspectra-all'];
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
fprintf(pltid,"set xlabel 'Horizontal Wavenumner (rad/m)'\n")
fprintf(pltid,"set ylabel 'Depth (m)'\n")
fprintf(pltid,"set cblabel 'Spectral Energy Density (m^2/s^2/rad/m) '\n")
fprintf(pltid,"unset key\n")
fprintf(pltid,"set pm3d\n")
fprintf(pltid,"set palette mode HSV\n")
fprintf(pltid,"%s",paltext("pm"))
fprintf(pltid,"set format x %s\n",logform)
fprintf(pltid,"set format cb %s\n",logform)
fprintf(pltid,"set cbrange [1e-1:1e5]\n")
fprintf(pltid,"splot '%s' binary matrix\n",datname)
fclose(pltid)
unix(["gnuplot " pltname ])
end%for
