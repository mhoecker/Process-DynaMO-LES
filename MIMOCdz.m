function [dCTdz,dSAdz,Z,LAT,LON] = MIMOCdz(FD,ML)
# using the full depth netCDF file caculate
# Density
# and vertical derivatives of
# Conservative Temperature
# Salinity Absolute
# Density
# add them to the Mixed Layer netCDF file
 testing=false;
#
# Default to testing files if netcdf files are not given
 if(nargin<2)
  testing=true;
 end%if
#
 if(testing)
  ML = "/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/testML.nc";
  FD = "/home/mhoecker/work/Dynamo/Observations/netCDF/MIMOC/testFD.nc";
 end%if
 # add Gibbs Sea Water to the path
 findgsw;
# open the net CDF file
 FDnc = netcdf(FD,'w');
 LAT = FDnc{'LATITUDE'}(:);
 LON = FDnc{'LONGITUDE'}(:);
 NY = length(LAT);
 NX = length(LON);
 P = FDnc{'PRESSURE'}(:);
 NZ = length(P);
 CT = FDnc{'ABSOLUTE_SALINITY'}(:);
 SA = FDnc{'CONSERVATIVE_TEMPERATURE'}(:);
 [llat,pp] = meshgrid(LAT,P);
 Z = gsw_z_from_p(pp,llat);
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
 clear CT;
 clear SA;
 ncredef(FDnc)
 FDnc{'Z'} = ncfloat('PRESSURE','LATITUDE');
 FDnc{'Z'}(:) = Z;
 FDnc{'dCTdz'} = ncfloat('PRESSURE','LATITUDE','LONGITUDE');
 FDnc{'dCTdz'}(:) = dCTdz;
 FDnc{'dSAdz'} = ncfloat('PRESSURE','LATITUDE','LONGITUDE');
 FDnc{'dSAdz'}(:) = dSAdz;
 ncenddef(FDnc);
 ncsync(FDnc);
 ncclose(FDnc);
% Full size matrix of possible depths
 ZZZ = zeros(size(dCTdz));
 for i=1:NY
  for j=1:NZ
   ZZZ(j,i,:)=Z(j,i);
  end%for
 end%for
 MLnc = netcdf(ML,'w');
 LATML = MLnc{'LATITUDE'}(:);
 LONML = MLnc{'LONGITUDE'}(:);
 NYML = length(LATML);
 NXML = length(LONML);
 # test to be sure the
 badgrids = "The Full Depth and Mixed layer files are not on the same grid!";
 if((NX==NXML)&&(NY==NYML))
  if(sum(abs(LAT-LATML))+sum(abs(LON-LONML))>0)
   error("The Full Depth and Mixed layer files are not on the same grid!");
  else
   clear LATML;
   clear LONML;
   clear NXML;
   clear NYML;
  end%if
 else
  error("The Full Depth and Mixed layer files are not on the same grid!");
 end%if
 ZML = MLnc{'DEPTH_MIXED_LAYER'}(:);
 dCTdzML = zeros(size(ZML));
 dSAdzML = zeros(size(ZML));
# For each Lat,Lon pair
 for i=1:NY
  for j=1:NX
   zij = ZZZ(:,i,j);
   dzijZ = zij-ZML(i,j);
   idxML = find(zij==min(zij),1);
   dCTdzML(i,j) = dCTdz(idxML,i,j);
   dSAdzML(i,j) = dSAdz(idxML,i,j);
  end%for
 end%for
 ncredef(MLnc)
 MLnc{'dCTdz'} = ncfloat('LATITUDE','LONGITUDE');
 MLnc{'dCTdz'}(:) = dCTdzML;
 MLnc{'dSAdz'} = ncfloat('LATITUDE','LONGITUDE');
 MLnc{'dSAdz'}(:) = dSAdzML;
 ncenddef(MLnc);
 ncsync(MLnc);
 ncclose(MLnc);
end%function
