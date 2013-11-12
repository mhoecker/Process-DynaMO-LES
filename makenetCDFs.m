function makenetCDFs()
ObsDir = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/';
matdir = 'mat/';
netcdfdir = 'netCDF/';
% Convert the flux tower data
% /media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/mat/FluxTower/PSDflx_leg3.mat
fluxdir = 'FluxTower/';
fluxfile = 'PSDflx_leg3';
FluxTower2NetCDF([ObsDir matdir fluxdir],fluxfile,[ObsDir netcdfdir fluxdir]);
%
% Convert ADCP data
%adcpdir = 'ADCP/';
%adcpfile = 'adcp150_filled_with_140';
%adcp2NetCDF([ObsDir matdir adcpdir],adcpfile,[ObsDir netcdfdir adcpdir]);
%
% Convert Chameloen data
%chamdir = 'Chameleon/';
%chamfile = 'dn11b_sum_clean_v2';
%cham2NetCDF([ObsDir matdir chamdir],chamfile,[ObsDir netcdfdir chamdir]);
%
% Filter adcp
%filteradcp(adcpfile,[ObsDir netcdfdir adcpdir])
end%function
