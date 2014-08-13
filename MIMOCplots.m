%AllMIMOCdz
datdir = '/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/';
datsfx = '_new.nc';
% FD fiels of the form
% /home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/MIMOC_Z_GRID_v2.2_CT_SA_month01_new.nc
FDroot = 'MIMOC_Z_GRID_v2.2_CT_SA_month';
% ML files of the form
% /home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/MIMOC_ML_v2.2_CT_SA_MLP_month01_new.nc
MLroot = 'MIMOC_ML_v2.2_CT_SA_MLP_month';
outdir = '/home/mhoecker/work/Dynamo/plots/MIMOC/';
[termtxt,termsfx] = termselect('pngposter');
pmpal = paltext('pmnan',19);
mpal = paltext('bluenan',6);
ppal = paltext('rednan',12);
multitxt = "set multiplot layout 1,3";
plttxt = "binary matrix w image not";
xyrange = "set xrange [0:360]\nset yrange [-80:90]\n set origin 0,.1;set size .99,.9;set colorbox user horizontal origin 0.06,0.07 size 0.88,.03\n";
MLrange = "set logscale cb 2\nset cbrange [8:512]\n";
dTrange = "unset logscale cb\nset cbrange [-0.004:0.004]\n";
dSrange = "unset logscale cb\nset cbrange [-0.001:0.001]\n";
Nrange = "unset logscale cb\nset cbrange [-8e-6:8e-6]\n";
Nmrange = "set logscale cb\nset cbrange [1e-6:1e-2]\n";
months = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
for i=1:12
 outfile = [outdir MLroot num2str(i,'%02i')];
 MLfile = [outfile "ML"];
 dTfile = [outfile "dTdz"];
 dSfile = [outfile "dSdz"];
 NSfile = [outfile "NsqS"];
 NTfile = [outfile "NsqT"];
 Nfile = [outfile "Nsq"];
 Nmfile = [outfile "Nsq_max"];
 Pycfile = [outfile "Pyc"];
 nc = netcdf([datdir MLroot num2str(i,'%02i') datsfx],'r');
 lat = nc{'LATITUDE'}(:)';
 lon = nc{'LONGITUDE'}(:)';
 ML = nc{'DEPTH_MIXED_LAYER'}(:);
 dTdz = nc{'dCTdz_ML'}(:);
 dSdz = nc{'dSAdz_ML'}(:);
 NT = nc{'Nsq_CT_ML'}(:);
 NS = nc{'Nsq_SA_ML'}(:);
 N = nc{'Nsq_ML'}(:);
 Nm = nc{'Nsq_max'}(:);
 Pyc = nc{'Pycnocline'}(:);
 ncclose(nc);
 MLdat = [MLfile ".dat"];
 dTdat = [dTfile ".dat"];
 dSdat = [dSfile ".dat"];
 NSdat = [NSfile ".dat"];
 NTdat = [NTfile ".dat"];
 Ndat = [Nfile ".dat"];
 Nmdat = [Nmfile ".dat"];
 Pycdat = [Pycfile ".dat"];
 binmatrix(lon,lat,ML,MLdat);
 binmatrix(lon,lat,dTdz,dTdat);
 binmatrix(lon,lat,dSdz,dSdat);
 binmatrix(lon,lat,NS,NSdat);
 binmatrix(lon,lat,NT,NTdat);
 binmatrix(lon,lat,N,Ndat);
 binmatrix(lon,lat,Nm,Nmdat);
 binmatrix(lon,lat,Pyc,Pycdat);
 pltfile = [outfile ".plt"];
 MLpng = [MLfile ".png"];
 dTpng = [dTfile ".png"];
 dSpng = [dSfile ".png"];
 NTpng = [NTfile ".png"];
 NSpng = [NSfile ".png"];
 Npng = [Nfile ".png"];
 Nmpng = [Nmfile ".png"];
 Pycpng = [Pycfile ".png"];
 fid = fopen(pltfile,'w');
 fprintf(fid,'set term %s\n',termtxt);
 fprintf(fid,'%s',xyrange);
 #
 fprintf(fid,'set output "%s"\n',MLpng);
 fprintf(fid,'%s',mpal);
 fprintf(fid,'%s',MLrange);
 fprintf(fid,'set title "Mixed Layer Depth (m) %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',MLdat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',dTpng);
 fprintf(fid,'%s',pmpal);
 fprintf(fid,'%s',dTrange);
 fprintf(fid,'set title "dT/dz (^oC/m) at z_{MLD} %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',dTdat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',dSpng);
 fprintf(fid,'%s',pmpal);
 fprintf(fid,'%s',dSrange);
 fprintf(fid,'set title "dS/dz (psu/m) at z_{MLD} %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',dSdat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',Nmpng);
 fprintf(fid,'%s',ppal);
 fprintf(fid,'%s',Nmrange);
 fprintf(fid,'set title "N^2 (1/s^2) at Pycnocline %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',Nmdat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',NTpng);
 fprintf(fid,'%s',pmpal);
 fprintf(fid,'%s',Nrange);
 fprintf(fid,'set title "N_T^2 (1/s^2) at z_{MLD} %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',NTdat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',NSpng);
 fprintf(fid,'%s',pmpal);
 fprintf(fid,'%s',Nrange);
 fprintf(fid,'set title "N_S^2 (1/s^2) at z_{MLD} %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',NSdat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',Npng);
 fprintf(fid,'%s',pmpal);
 fprintf(fid,'%s',Nrange);
 fprintf(fid,'set title "N^2 (1/s^2) at z_{MLD} %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',Ndat,plttxt);
 #
 fprintf(fid,'set output "%s"\n',Pycpng);
 fprintf(fid,'%s',mpal);
 fprintf(fid,'%s',MLrange);
 fprintf(fid,'set title "Pycnocline depth (m) %s"\n',months{i});
 fprintf(fid,'plot "%s" %s\n',Pycdat,plttxt);
 #
 fclose(fid);
 #
 unix(['gnuplot ' pltfile]);
end%for
convertstring = ['convert -delay 25 -loop 0 -resize 50% ' outdir MLroot '??'];
plottype = {"ML","dTdz","dSdz","Nsq_max","NsqT","NsqS","Nsq","Pyc"};
for i = 1:length(plottype);
 unix([convertstring plottype{i} '.png ' outdir plottype{i} ".gif"]);
end%for
