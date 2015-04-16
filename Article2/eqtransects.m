ncdir = "/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/";
ncroot = [ncdir "MIMOC_Z_GRID_v2.2_CT_SA_month"];
outdir = "/home/mhoecker/work/Dynamo/plots/MIMOC/";
dir = plotparam(outdir,"eqtransects")
outdat  = [dir.dat "eqtransects_"];
for i=1:12
 ncfile = [ncroot num2str(i,"%02i") "_new.nc"];
 datsfx = [num2str(i,"%02i") ".dat"];
 nc = netcdf(ncfile,'r');
 lat = nc{"LATITUDE"}(:);
 lon = nc{"LONGITUDE"}(:)';
 idxeq = find(lat==0);
 Z = squeeze(nc{"Z"}(:,idxeq))';
 T = squeeze(nc{"CONSERVATIVE_TEMPERATURE"}(:,idxeq,:));
 S = squeeze(nc{"ABSOLUTE_SALINITY"}(:,idxeq,:));
 N = squeeze(nc{"Nsq"}(:,idxeq,:));
 dTdZ = squeeze(nc{"dCTdz"}(:,idxeq,:));
 dSdZ = squeeze(nc{"dSAdz"}(:,idxeq,:));
 binmatrix(lon,Z,T,[outdat "T" datsfx]);
 binmatrix(lon,Z,S,[outdat "S" datsfx]);
 binmatrix(lon,Z,N,[outdat "Nsq" datsfx]);
 binmatrix(lon,Z,dTdZ,[outdat "dTdZ" datsfx]);
 binmatrix(lon,Z,dSdZ,[outdat "dSdZ" datsfx]);
 ncclose(nc);
end%for
unix(["gnuplot " dir.initplt " " dir.script "eqtransects.plt"])
pngopts = " -w 640 -v 4096 -t avi ";
unix(["pngmovie.sh " pngopts " -l " dir.png  "T -n " dir.png "T_eq"  ]);
unix(["pngmovie.sh " pngopts " -l " dir.png  "S -n " dir.png "S_eq"  ]);
unix(["pngmovie.sh " pngopts " -l " dir.png  "Nsq -n " dir.png "Nsq_eq"]);
unix(["pngmovie.sh " pngopts " -l " dir.png  "dTdZ -n " dir.png "dTdZ_eq"]);
unix(["pngmovie.sh " pngopts " -l " dir.png  "dSdZ -n " dir.png "dSdZ_eq"]);
