%function filterFluxTower(fileloc,filename)
tmpdir   = "/home/mhoecker/tmp/";
fileloc = '/home/mhoecker/work/Dynamo/Observations/netCDF/FluxTower/';
filename = 'DYNAMO_2011_Leg3_PSD_flux_5min_all';
cdffile  = [tmpdir filename "_filtered_1hr_3day.cdf"];
ncfile   = [fileloc filename "_filtered_1hr_3day.nc"];
maxdpos = .2;
nc = netcdf([fileloc filename '.nc'],'r');
% Convert to datenum format (to match other files)
t = nc{'t'}(:)+datenum([2011,1,1])-1;
th = floor(min(t)*24)/24:1/24:ceil(max(t)*24)/24;
% location
lat  = nc{'lat'}(:);
lon  = nc{'lon'}(:);
Us   = nc{'VS'}(:).*sin(nc{'VH'}(:)*pi/180);
Vs   = nc{'VS'}(:).*cos(nc{'VH'}(:)*pi/180);
Us2  = nc{'VSOG'}(:).*sin(nc{'VH2'}(:)*pi/180);
Vs2  = nc{'VSOG'}(:).*cos(nc{'VH2'}(:)*pi/180);
Vsd  = nc{'VSsd'}(:);
Uwr  = nc{'RWS'}(:).*sin(nc{'RWH'}(:)*pi/180);
Vwr  = nc{'RWS'}(:).*cos(nc{'RWH'}(:)*pi/180);
% Atmosphere (mote
% wind heading "WH" uses atmospheric convention
P    = nc{'P'}(:);
Uw   = -nc{'WS'}(:).*sin(nc{'WH'}(:)*pi/180);
Vw   = -nc{'WS'}(:).*cos(nc{'WH'}(:)*pi/180);
Ta   = nc{'AT'}(:);
Ta2  = nc{'TA2'}(:);
SSQ  = nc{'SSQ'}(:);
AQ   = nc{'AQ'}(:);
AQ2  = nc{'AQ2'}(:);
% Fluxes
SW     = nc{'SWRF'}(:);
LW     = nc{'LWRF'}(:);
SW2     = nc{'SWRF2'}(:);
LW2     = nc{'LWRF2'}(:);
Sen    = nc{'SF'}(:);
La    = nc{'LF'}(:);
Precip = nc{'PR'}(:);
RainF  = nc{'RainF'}(:);
Taux   = nc{'Tau'}(:).*Uw./nc{'WS'}(:);
Tauy   = nc{'Tau'}(:).*Vw./nc{'WS'}(:);
% Ocean
T    = nc{'T'}(:);
S    = nc{'S'}(:);
SST  = nc{'SST'}(:);
Zref = nc{'Zref'}(:);
ncclose(nc);
# Do some filtering

# Place desired data into val cell array
val = {th};
val = {val{:},csqfil(SW,t,th)};
val = {val{:},csqfil(LW,t,th)};
val = {val{:},csqfil(La,t,th)};
val = {val{:},csqfil(Sen,t,th)};
val = {val{:},csqfil(Taux,t,th)};
val = {val{:},csqfil(Tauy,t,th)};
val = {val{:},csqfil(RainF,t,th)};
val = {val{:},csqfil(Precip,t,th)};
val = {val{:},csqfil(SST,t,th)};
val = {val{:},csqfil(T,t,th)};
val = {val{:},csqfil(S,t,th)};
# Initialize descriptor fields
	Nvar = length(val);
	Ndim = 1;
	vars = {};
	longname = {};
	units = {};
	dims = {};
	filtering = {};
	for i=1:Nvar;
		vars = {vars{:},['var' num2str(i)]};
		units = {units{:},'TBD'};
		longname = {longname{:},'TBD'};
		dims = {dims{:},''};
		filtering = {filtering{:},''};
	endfor
i=0;
#	Hourly time
i=i+1;
vars{i} = 't';
units{i} = 'd';
longname{i} = 'time since 1999 Dec 31 00:00:00';
dims{i} = [vars{1}];
#	Short Wave Heat Flux
i=i+1;
vars{i} = 'SW';
units{i} = 'W/m^2';
longname{i} = 'Short Wave Heat Flux';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Short Wave Heat Flux
i=i+1;
vars{i} = 'LW';
units{i} = 'W/m^2';
longname{i} = 'Long Wave Heat Flux';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Latent Heat Flux
i=i+1;
vars{i} = 'La';
units{i} = 'W/m^2';
longname{i} = 'Latent Heat Flux';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Sensible Heat Flux
i=i+1;
vars{i} = 'Sen';
units{i} = 'W/m^2';
longname{i} = 'Sensible Heat Flux';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	E/W Stress
i=i+1;
vars{i} = 'Tau_x';
units{i} = 'Pa/m^2';
longname{i} = 'E/W Stress';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	N/S Stress
i=i+1;
vars{i} = 'Tau_y';
units{i} = 'Pa/m^2';
longname{i} = 'E/W Stress';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Rain Heat Flux
i=i+1;
vars{i} = 'RainF';
units{i} = 'W/m^2';
longname{i} = 'Rain Heat Flux';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Percipitaion rate
i=i+1;
vars{i} = 'Precip';
units{i} = 'mm/hr';
longname{i} = 'Precipitation';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Sea Surface Temperature
i=i+1;
vars{i} = 'SST';
units{i} = 'Celsius';
longname{i} = 'Sea Surface Temperature';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Sea Snake Temperature
i=i+1;
vars{i} = 'T';
units{i} = 'Celsius';
longname{i} = 'Sea Snake Temperature';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Sea Snake Temperature
i=i+1;
vars{i} = 'S';
units{i} = 'psu';
longname{i} = 'Sea Snake Salinity';
dims{i} = [vars{1}];
filtering{i} = "3 hours";
#	Open CDF file
	cdlid = fopen(cdffile,'w');
	fprintf(cdlid,'netcdf %s {\n', filename);
#	Declare Dimensions
	fprintf(cdlid,'dimensions:\n');
	for i=1:Ndim
		fprintf(cdlid,'%s=%i;\n',vars{i},length(val{i}));
	endfor
#	Declare variables
	fprintf(cdlid,'variables:\n');
	for i=1:Nvar
		fprintf(cdlid,'double %s(%s);\n',vars{i},dims{i});
	endfor
# Add units, long_name and instrument
fprintf(cdlid,'\n');
for i=1:Nvar
	fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
	fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
	if(length(filtering{i})>0)
		fprintf(cdlid,'%s:Fillter_Period = "%s";\n',vars{i},filtering{i});
	endif
endfor
#Declare global attributes
fprintf(cdlid,':source = "%s";\n',[filename '.nc']);
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
fprintf(cdlid,':Flux_Algorithm = "bulk COARE version 3.0";\n');
fprintf(cdlid,':LW_Flux = "Fairall et al. Jtech, 1998.";\n');
fprintf(cdlid,':Sea_Snake_Depth = "0.05 meters";\n');
fprintf(cdlid,':TSG_Depth = "5 meters";\n');
fprintf(cdlid,':PSD_Height = "18 meters";\n');
fprintf(cdlid,':PSD_sonic_Height = "18.5 meters";\n');
fprintf(cdlid,':IMET_Height = "21 meters";\n');
fprintf(cdlid,':filtering = "%s";\n',"weighted average , weight=(1+cos(2*pi*(s-t)/T))^2 for |s-t| < T/2");
# Declare Data
fprintf(cdlid,'data:\n')
for i=1:Nvar
 y = val{i}(:);
 fprintf(cdlid,'%s =\n',vars{i});
 for j=1:length(y)
  if(isnan(y(j))==1)
   fprintf(cdlid,'NaN');
  else
   fprintf(cdlid,'%f',y(j));
  end%if
  if(j<length(y))
   fprintf(cdlid,', ');
  else
   fprintf(cdlid,';\n');
  end%if
 endfor
endfor
fprintf(cdlid,'}\n')
fclose(cdlid)
%unix(['ncgen -k1 -x -b ' cdffile ' -o ' ncfile ])
unix(['ncgen -k1 -x -b ' cdffile ' -o ' ncfile '&& rm ' cdffile])
