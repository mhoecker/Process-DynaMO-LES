% Make a synthetic climatological transect of velocity
% uses files from RAMA and TAO arrays
Observation = "/home/mhoecker/work/Dynamo/Observations";
monthlyRAMA = [Observation "/netCDF/RAMA/monthly"];
monthlyTAO  = [Observation "/netCDF/TAO/monthly"];
%
% Individual files
% There is no ADCP at 067e or 180
%nc067e = [monthlyRAMA "/067e" "/cur0n67e_mon_2byte.cdf"];
%nc180  = [monthlyTAO  "/180"  ""];
%
londat = [80.5 90 147 156 165 190];
%
adcp081e = [monthlyRAMA "/081e" "/adcp0n80.5e_mon_2byte.cdf"];
adcp090e = [monthlyRAMA "/090e" "/adcp0n90e_mon_2byte.cdf"];
adcp147e = [monthlyTAO  "/147e" "/adcp0n147e_mon_2byte.cdf"];
adcp156e = [monthlyTAO  "/156e" "/adcp0n156e_mon_2byte.cdf"];
adcp165e = [monthlyTAO  "/165e" "/adcp0n165e_mon_2byte.cdf"];
adcp170w = [monthlyTAO  "/170w" "/adcp0n170w_mon_2byte.cdf"];
%
% Open all the files
nc081 = netcdf(adcp081e,'r');
nc090 = netcdf(adcp090e,'r');
nc147 = netcdf(adcp147e,'r');
nc156 = netcdf(adcp156e,'r');
nc165 = netcdf(adcp165e,'r');
nc190 = netcdf(adcp170w,'r');

% Find the deepest depth and highest resolution profile
% find depth and spacing for mooring at 81E
Z081  = nc081{'depth'}(:);
Zmax  = max(Z081);
dZmin = min(diff(Z081));
% find depth and spacing for mooring at 90E
Z090  = nc090{'depth'}(:);
Zmax  = max([max(Z090),Zmax]);
dZmin = min([dZmin,min(diff(Z090))]);
% find depth and spacing for mooring at 147E
Z147  = nc147{'depth'}(:);
Zmax  = max([max(Z147),Zmax]);
dZmin = min([dZmin,min(diff(Z147))]);
% find depth and spacing for mooring at 156E
Z156  = nc156{'depth'}(:);
Zmax  = max([max(Z156),Zmax]);
dZmin = min([dZmin,min(diff(Z156))]);
% find depth and spacing for mooring at 165E
Z165  = nc165{'depth'}(:);
Zmax  = max([max(Z165),Zmax]);
dZmin = min([dZmin,min(diff(Z165))]);
% find depth and spacing for mooring at 190E (170W)
Z190  = nc190{'depth'}(:);
Zmax  = max([max(Z190),Zmax]);
dZmin = min([dZmin,min(diff(Z190))]);
%
% Create common Z co-ordiante
Z = 0:dZmin:Zmax
%
%Read in Zonal Currents
u081  = nc081{'u'}(:);
u090  = nc090{'u'}(:);
u147  = nc147{'u'}(:);
u156  = nc156{'u'}(:);
u165  = nc165{'u'}(:);
u190  = nc190{'u'}(:);
%
%
%
% Read in times
%
% Convert to month
%
% Average over months
%
% Extrapolate to full depth
%
% Interpolate to common Z basis

%
% Close all the files
ncclose(nc081);
ncclose(nc090);
ncclose(nc147);
ncclose(nc156);
ncclose(nc165);
ncclose(nc190);
