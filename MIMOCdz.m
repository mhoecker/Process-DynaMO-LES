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
 SA = FDnc{'ABSOLUTE_SALINITY'}(:);
 CT = FDnc{'CONSERVATIVE_TEMPERATURE'}(:);
 [llat,pp] = meshgrid(LAT,P);
 g = gsw_grav(LAT);
 Z = gsw_z_from_p(pp,llat);
# Initialize the derivatives
# This Carries the NaNs over
 dCTdz = CT*NaN;
 dSAdz = SA*NaN;
 NsqSA = SA*NaN;
 NsqCT = CT*NaN;
 Nsq = SA*NaN;
# For each Lat,Lon pair
 for i=1:NY
# Get the depths
  zi = Z(:,i);
  for j=1:NX;
   CTtmp=CT(:,i,j);
   SAtmp=SA(:,i,j);
# Find the NaN
   idxgood = find(isnan(CTtmp)+isnan(SAtmp)<1);
# Ensure that the 3 point derivative stencil fits in the domain
   if(length(idxgood)>3);
    zgood = zi(idxgood);
    CTgood= CTtmp(idxgood);
    SAgood = SAtmp(idxgood);
    Pgood = P(idxgood);
    dz = ddz(zgood);
    dCTdz(idxgood,i,j) = dz*CTgood;
    dSAdz(idxgood,i,j) = dz*SAgood;
    [rho, alpha, beta] = gsw_rho_alpha_beta(SAgood,CTgood,Pgood);
    NsqCT(idxgood,i,j) = +g(i).*dCTdz(idxgood,i,j).*alpha;
    NsqSA(idxgood,i,j) = -g(i).*dSAdz(idxgood,i,j).*beta;
    Nsq(idxgood,i,j) = NsqCT(idxgood,i,j)+NsqSA(idxgood,i,j);
   else
    dCTdz(:,i,j) = NaN;
    dSAdz(:,i,j) = NaN;
    NsqSA(:,i,j) = NaN;
    NsqCT(:,i,j) = NaN;
    Nsq(:,i,j) = NaN;
   end%if
  end%for
 end%for
 clear CT;
 clear SA;
 #
 ncaddfloat(Z,'Z',{'PRESSURE','LATITUDE'},FDnc)
 ncaddfloat(dCTdz,'dCTdz',{'PRESSURE','LATITUDE','LONGITUDE'},FDnc)
 ncaddfloat(dSAdz,'dSAdz',{'PRESSURE','LATITUDE','LONGITUDE'},FDnc)
 ncaddfloat(NsqCT,'NsqCT',{'PRESSURE','LATITUDE','LONGITUDE'},FDnc)
 ncaddfloat(NsqSA,'NsqSA',{'PRESSURE','LATITUDE','LONGITUDE'},FDnc)
 ncaddfloat(Nsq,'Nsq',{'PRESSURE','LATITUDE','LONGITUDE'},FDnc)
 #
 ncclose(FDnc);
# Calculate ML properties
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
 dCTdzML = zeros(size(ZML))+NaN;
 dSAdzML = zeros(size(ZML))+NaN;
 NsqCTML = zeros(size(ZML))+NaN;
 NsqSAML = zeros(size(ZML))+NaN;
 NsqML = zeros(size(ZML))+NaN;
 Nsqmax = zeros(size(ZML))+NaN;
 myML = zeros(size(ZML))+NaN;
# For each Lat,Lon pair
 for i=1:NY
  for j=1:NX
   Nsqij = Nsq(:,i,j);
   zij = Z(:,i);
   dzijZ = zij+ZML(i,j);
   idxML = find(zij==min(zij),1);
   dCTdzML(i,j) = dCTdz(idxML,i,j);
   dSAdzML(i,j) = dSAdz(idxML,i,j);
   NsqCTML(i,j) = NsqCT(idxML,i,j);
   NsqSAML(i,j) = NsqSA(idxML,i,j);
   NsqML(i,j) = Nsq(idxML,i,j);
   idxgood = find(isnan(Nsqij)!=1);
   if(length(idxgood)>3)
    Nsqmax(i,j) = max(Nsqij(idxgood));
    idxmax = find(Nsqmax(i,j)==Nsqij(idxgood),1);
    imax = idxgood(idxmax);
    myML(i,j) = -Z(imax,i);
   else
    Nsqmax(i,j) = NaN;
    myML(i,j) = NaN;
   end%if
  end%for
 end%for
 ncaddfloat(dCTdzML,'dCTdz_ML',{'LATITUDE','LONGITUDE'},MLnc);
 ncaddfloat(dSAdzML,'dSAdz_ML',{'LATITUDE','LONGITUDE'},MLnc);
 ncaddfloat(NsqCTML,'Nsq_CT_ML',{'LATITUDE','LONGITUDE'},MLnc);
 ncaddfloat(NsqSAML,'Nsq_SA_ML',{'LATITUDE','LONGITUDE'},MLnc);
 ncaddfloat(NsqML,'Nsq_ML',{'LATITUDE','LONGITUDE'},MLnc);
 ncaddfloat(myML,'Pycnocline',{'LATITUDE','LONGITUDE'},MLnc);
 ncaddfloat(Nsqmax,'Nsq_max',{'LATITUDE','LONGITUDE'},MLnc);
 ncclose(MLnc);
end%function

function ncaddfloat(var,varname,dims,ncref)
 ncredef(ncref);
 if(length(dims)==0)
 elseif(length(dims)==1)
  ncref{varname} = ncfloat(dims{1});
 elseif(length(dims)==2)
  ncref{varname} = ncfloat(dims{1},dims{2});
 elseif(length(dims)==3)
  ncref{varname} = ncfloat(dims{1},dims{2},dims{3});
 elseif(length(dims)==4)
  ncref{varname} = ncfloat(dims{1},dims{2},dims{3},dims{4});
 elseif(length(dims)==5)
  ncref{varname} = ncfloat(dims{1},dims{2},dims{3},dims{4},dims{5});
 else
  error("too many dims specifed!")
 end#if
 ncref{varname}(:) = var;
 ncenddef(ncref);
 ncsync(ncref);
 end%function
