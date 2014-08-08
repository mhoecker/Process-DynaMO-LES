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
multitxt = "set multiplot layout 1,3";
plttxt = "binary matrix w image not";
xyrange = "set xrange [0:360]\nset yrange [-80:90]\n set origin 0,.1;set size .99,.9;set colorbox user horizontal origin 0.06,0.07 size 0.88,.03\n";
MLrange = "set logscale cb 2\nset cbrange [8:512]\n";
dTrange = "unset logscale cb\nset cbrange [-0.001:0.001]\n";
dSrange = "unset logscale cb\nset cbrange [-0.004:0.004]\n";
months = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
for i=1:12
 outfile = [outdir MLroot num2str(i,'%02i')];
 MLfile = [outfile "ML"];
 dTfile = [outfile "dTdz"];
 dSfile = [outfile "dSdz"];
 nc = netcdf([datdir MLroot num2str(i,'%02i') datsfx],'r');
 lat = nc{'LATITUDE'}(:)';
 lon = nc{'LONGITUDE'}(:)';
 ML = nc{'DEPTH_MIXED_LAYER'}(:);
 dTdz = -nc{'dCTdz'}(:);
 dSdz = -nc{'dSAdz'}(:);
 ncclose(nc);
 MLdat = [MLfile ".dat"];
 dTdat = [dTfile ".dat"];
 dSdat = [dSfile ".dat"];
 binmatrix(lon,lat,ML,MLdat);
 binmatrix(lon,lat,dTdz,dTdat);
 binmatrix(lon,lat,dSdz,dSdat);
 pltfile = [outfile ".plt"];
 MLpng = [MLfile ".png"];
 dTpng = [dTfile ".png"];
 dSpng = [dSfile ".png"];
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
 fclose(fid);
 unix(['gnuplot ' pltfile]);
end%for
