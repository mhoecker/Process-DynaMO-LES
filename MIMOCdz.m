function [dCTdz,dSAdz,Z,LAT,LON] = MIMOCdz(FDfile,MLfile)
# using the full depth netCDF file caculate
# Density
# and vertical derivatives of
# Conservative Temperature
# Salinity Absolute
# Density
# add them to the Mixed Layer netCDF file
 testing=true;
#
# Default to testing files if netcdf files are not given
 if(nargin<2)
  testing=true;
 end%if
#
 if(testing)
  ML = "/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/testML.nc";
  FD = "/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/test.nc";
 end%if
 # add Gibbs Sea Water to the path
 findgsw;
# open the net CDF file
 FDnc = netcdf(FD,'r');
 LAT = FDnc{'LATITUDE'}(:);
 LON = FDnc{'LONGITUDE'}(:);
 NY = length(LAT);
 NX = length(LON);
 P = FDnc{'PRESSURE'}(:);
 CT = FDnc{'ABSOLUTE_SALINITY'}(:);
 SA = FDnc{'CONSERVATIVE_TEMPERATURE'}(:);
 [llat,pp] = meshgrid(LAT,P);
 Z = gsw_z_from_p(pp,llat);
 pcolor(Z-mean(Z,2)); shading flat; colorbar
# Initialize the derivatives
# This Carries the NaNs over
 dCTdz = CT;
 dSAdz = SA;
# For each Lat,Lon pair
 for i=1:NY
# Get the depths
  zi = Z(:,i);
  for j=1:NX;
   CTtmp=CT(:,i,j);
   SAtmp=SA(:,i,j);
# Find the NaN
   idxgood = find(isnan(CTtmp)+isnan(SAtmp)<1);
# Ensure that the stencil of the derivative will fit in the domain
   if(length(idxgood)>4);
    zgood = zi(idxgood);
    CTgood= CTtmp(idxgood);
    SAgood = SAtmp(idxgood);
    dz = ddz(zgood);
    dCTdz(idxgood,i,j) = dz*CTgood;
    dSAdz(idxgood,i,j) = dz*SAgood;
   else
    dCTdz(:,i,j) = NaN;
    dSAdz(:,i,j) = NaN;
   end%if
  end%for
 end%for
end%function
