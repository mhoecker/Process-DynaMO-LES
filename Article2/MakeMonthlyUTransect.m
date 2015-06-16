% Make a synthetic climatological transect of velocity
% uses files from RAMA and TAO arrays
% uses the 2-byte CF time convention data
DYNAMO      = "/home/mhoecker/work/Dynamo";
outdir      = [DYNAMO "/plots/GTMBA"];
paramdir    = plotparam(outdir,"MonU");
Observation = [DYNAMO "/Observations"];
monthlyRAMA = [Observation "/netCDF/RAMA/monthly"];
monthlyTAO  = [Observation "/netCDF/TAO/monthly"];
%
% Individual files
% There is no ADCP at 067e or 180
%nc067e = [monthlyRAMA "/067e" "/cur0n67e_mon_2byte.cdf"];
%nc180  = [monthlyTAO  "/180"  ""];
%
londat = [80.5, 90, 147, 156, 165, 190];
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
% find depth and spacing for mooring at 90E
Z090  = nc090{'depth'}(:);
% find depth and spacing for mooring at 147E
Z147  = nc147{'depth'}(:);
% find depth and spacing for mooring at 156E
Z156  = nc156{'depth'}(:);
% find depth and spacing for mooring at 165E
Z165  = nc165{'depth'}(:);
% find depth and spacing for mooring at 190E (170W)
Z190  = nc190{'depth'}(:);
%
%Read in Zonal Currents
% Data are stored as an integer with scaling and offset
u081  = nc081{'u'}(:);
u081(u081==nc081{'u'}.missing_value) = NaN;
u081 = (u081*nc081{'u'}.scale_factor+nc081{'u'}.add_offset)/100;
u090  = nc090{'u'}(:);
u090(u090==nc090{'u'}.missing_value) = NaN;
u090 = (u090*nc090{'u'}.scale_factor+nc090{'u'}.add_offset)/100;
u147  = nc147{'u'}(:);
u147(u147==nc147{'u'}.missing_value) = NaN;
u147 = (u147*nc147{'u'}.scale_factor+nc147{'u'}.add_offset)/100;
u156  = nc156{'u'}(:);
u156(u156==nc156{'u'}.missing_value) = NaN;
u156 = (u156*nc156{'u'}.scale_factor+nc156{'u'}.add_offset)/100;
u165  = nc165{'u'}(:);
u165(u165==nc165{'u'}.missing_value) = NaN;
u165 = (u165*nc165{'u'}.scale_factor+nc165{'u'}.add_offset)/100;
u190  = nc190{'u'}(:);
u190(u190==nc190{'u'}.missing_value) = NaN;
u190 = (u190*nc190{'u'}.scale_factor+nc190{'u'}.add_offset)/100;
%
%
% Read in times and convert to months
% time is measured from various zero points!
% units are days
%
% t=0 on 2004-11-16 at 12:00:00
t081  = datenum(2004,11,16+nc081{'time'}(:));
%
% t=0 on 2004-11-16 at 12:00:00
t090  = datenum(2004,11,16+nc090{'time'}(:));
%
% t=0 on 1992-01-16 12:00:00
t147  = datenum(1992,01,16+nc147{'time'}(:));
%
% t=0 on 1991-09-16 12:00:00
t156  = datenum(1991,09,16+nc156{'time'}(:));
%
% t=0 on 1991-04-16 12:00:00
t165  = datenum(1991,04,16+nc165{'time'}(:));
%
% t=0 on 1988-05-16 12:00:00
t190  = datenum(1988,05,16+nc190{'time'}(:));
%
% Close all the files
ncclose(nc081);
ncclose(nc090);
ncclose(nc147);
ncclose(nc156);
ncclose(nc165);
ncclose(nc190);
%
% Convert to month
m081 = datevec(t081)(:,2);
m090 = datevec(t090)(:,2);
m147 = datevec(t147)(:,2);
m156 = datevec(t156)(:,2);
m165 = datevec(t165)(:,2);
m190 = datevec(t190)(:,2);
%
% Initialize Umean
Ubar081 = zeros(12,length(Z081));
Ubar090 = zeros(12,length(Z090));
Ubar147 = zeros(12,length(Z147));
Ubar156 = zeros(12,length(Z156));
Ubar165 = zeros(12,length(Z165));
Ubar190 = zeros(12,length(Z190));
%
% Average over months
for m=1:12
 idx = find(m081==m);
 Ubar081(m,:) = nanmean(u081(idx,:));
%
 idx = find(m090==m);
 Ubar090(m,:) = nanmean(u090(idx,:));
%
 idx = find(m147==m);
 Ubar147(m,:) = nanmean(u147(idx,:));
%
 idx = find(m156==m);
 Ubar156(m,:) = nanmean(u156(idx,:));
%
 idx = find(m165==m);
 Ubar165(m,:) = nanmean(u165(idx,:));
%
 idx = find(m190==m);
 Ubar190(m,:) = nanmean(u190(idx,:));
end%for
%
% Remove Depths with NaNs
idxgood = find(~isnan(sum(Ubar081,1)));
Ubar081 = Ubar081(:,idxgood);
Zbar081 = Z081(idxgood);
%
idxgood = find(~isnan(sum(Ubar090,1)));
Ubar090 = Ubar090(:,idxgood);
Zbar090 = Z090(idxgood);
%
idxgood = find(~isnan(sum(Ubar147,1)));
Ubar147 = Ubar147(:,idxgood);
Zbar147 = Z147(idxgood);
%
idxgood = find(~isnan(sum(Ubar156,1)));
Ubar156 = Ubar156(:,idxgood);
Zbar156 = Z156(idxgood);
%
idxgood = find(~isnan(sum(Ubar165,1)));
Ubar165 = Ubar165(:,idxgood);
Zbar165 = Z165(idxgood);
%
idxgood = find(~isnan(sum(Ubar190,1)));
Ubar190 = Ubar190(:,idxgood);
Zbar190 = Z190(idxgood);
%
% Find maximum depth with Velocity
Zmax = max(Zbar081);
Zmax = max([Zmax,max(Zbar090)]);
Zmax = max([Zmax,max(Zbar147)]);
Zmax = max([Zmax,max(Zbar156)]);
Zmax = max([Zmax,max(Zbar165)]);
Zmax = max([Zmax,max(Zbar190)]);
% Common Z spacing
dZ   = min(abs(diff(Zbar081)));
dZ   = min([dZ,min(abs(diff(Zbar090)))]);
dZ   = min([dZ,min(abs(diff(Zbar147)))]);
dZ   = min([dZ,min(abs(diff(Zbar156)))]);
dZ   = min([dZ,min(abs(diff(Zbar165)))]);
dZ   = min([dZ,min(abs(diff(Zbar190)))]);
% Create common Z co-ordiante
Z = 0:dZmin:Zmax;
%
U = zeros([12,6,length(Z)]);
% Interpolate/Extrapolate onto common Z basis
for m=1:12
 U(m,1,:) = interp1(Zbar081,Ubar081(m,:),Z,"nearest","extrap");
 U(m,2,:) = interp1(Zbar090,Ubar090(m,:),Z,"nearest","extrap");
 U(m,3,:) = interp1(Zbar147,Ubar147(m,:),Z,"nearest","extrap");
 U(m,4,:) = interp1(Zbar156,Ubar156(m,:),Z,"nearest","extrap");
 U(m,5,:) = interp1(Zbar165,Ubar165(m,:),Z,"nearest","extrap");
 U(m,6,:) = interp1(Zbar190,Ubar190(m,:),Z,"nearest","extrap");
 Um = squeeze(U(m,:,:))';
 binmatrix(londat,-Z,Um,[paramdir.dat num2str(m,"%02i") ".dat"]);
end%for
unix(["gnuplot " paramdir.initplt " " paramdir.script "MakeMonU.plt"])
