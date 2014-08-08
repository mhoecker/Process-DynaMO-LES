%AllMIMOCdz
datdir = '/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/';
datsfx = '_new.nc'
% FD fiels of the form
% /home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/MIMOC_Z_GRID_v2.2_CT_SA_month01_new.nc
FDroot = 'MIMOC_Z_GRID_v2.2_CT_SA_month';
% ML files of the form
% /home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/MIMOC_ML_v2.2_CT_SA_MLP_month01_new.nc
MLroot = 'MIMOC_ML_v2.2_CT_SA_MLP_month';

for i=1:1
 MIMOCdz([datdir FDroot num2str(i,'%02i') datsfx],[datdir MLroot num2str(i,'%02i') datsfx]);
end%for
