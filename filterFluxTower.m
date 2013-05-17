%function filterFluxTower(fileloc,filename,)
tmpdir   = "/home/mhoecker/tmp/";
fileloc = '/home/mhoecker/work/Dynamo/Observations/netCDF/FluxTower/';
filename = 'DYNAMO_2011_Leg3_PSD_flux_5min_all';
cdffile  = [tmpdir filename "_filtered_1hr_3day.cdf"];
ncfile   = [fileloc filename "_filtered_1hr_3day.nc"];
maxdpos = .2;
nc = netcdf([fileloc filename '.nc'],'r');
ncclose(nc);
% Distance from nominal station
%dpos = sqrt(lat.^2+(lon-80.5).^2);
% indecies of points near station
%dnumstart = datenum([2011,11,11,0,0,0]);
%dnumstop = datenum([2011,12,3,0,0,0]);
%idxclose = find((dpos<maxdpos).*(t>dnumstart).*(t<dnumstop));
