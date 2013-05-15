%filteradcp
tmpdir   = "/home/mhoecker/tmp/";
fileloc = '/home/mhoecker/work/Dynamo/Observations/netCDF/ADCP/';
filename = 'adcp150_filled_with_140';
cdffile  = [tmpdir filename "_filtered_1hr_3day.cdf"];
ncfile   = [fileloc filename "_filtered_1hr_3day.nc"];
maxdpos = .2;
nc = netcdf([fileloc filename '.nc'],'r');
t = nc{'t'}(:);
lat = nc{'lat'}(:);
lon = nc{'lon'}(:);
Us = nc{'Us'}(:);
Vs = nc{'Vs'}(:);
dlat = diff(lat);
dlon = diff(lon);
dt = diff(t);
% Distance from nominal station
dpos = sqrt(lat.^2+(lon-80.5).^2);
% indecies of points near station
dnumstart = datenum([2011,11,11,0,0,0]);
dnumstop = datenum([2011,12,3,0,0,0]);
idxclose = find((dpos<maxdpos).*(t>dnumstart).*(t<dnumstop));
% depths
z = nc{'z'}(:);
% choose times near station
tgood = t(idxclose);
% velocity data
u = nc{'u'}(:,:);
v = nc{'v'}(:,:);
% choose times near station
s = floor(min(tgood)):1/24:ceil(max(tgood));
ulp = zeros(length(s),length(z));
uhp = zeros(length(s),length(z));
vlp = zeros(length(s),length(z));
vhp = zeros(length(s),length(z));
lats = csqfil(lat,t,s);
lons = csqfil(lon,t,s);
Uss = csqfil(Us,t,s);
Vss = csqfil(Vs,t,s);
for i=1:length(z)
 uhp(:,i) =csqfil(u(:,i),t,s);
 ulp(:,i) =csqfil(uhp(:,i),s,s,3);
 vhp(:,i) =csqfil(v(:,i),t,s);
 vlp(:,i) =csqfil(vhp(:,i),s,s,3);
end%for
	val = {s(:)};
	val = {val{:},z(:)};
	val = {val{:},Uss(:)};
	val = {val{:},Vss(:)};
	val = {val{:},lats(:)};
	val = {val{:},lons(:)};
	val = {val{:},uhp(:,:)'};
	val = {val{:},vhp(:,:)'};
	val = {val{:},ulp(:,:)'};
	val = {val{:},vlp(:,:)'};
	clear s z Uss Vss lats lons uhp vhp ulp vlp
	Nvar = length(val);
	Ndim = 2;
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
#	01 time
vars{1} = 't';
units{1} = 'd';
longname{1} = 'time since 1999 Dec 31 00:00:00';
dims{1} = [vars{1}];
#	02 depth
vars{2} = 'z';
units{2} = 'm';
longname{2} = 'depth';
dims{2} = [vars{2}];
#	03 U ship
vars{3} = 'Us';
units{3} = 'm/s';
longname{3} = 'Ship Zonal Velocity (Eastward>0)';
dims{3} = [vars{1}];
filtering{3} = "3 hours";
#	04 V Ship
vars{4} = 'Vs';
units{4} = 'm/s';
longname{4} = 'Ship Meridional Velocity (Northward>0)';
dims{4} = [vars{1}];
filtering{4} = "3 hours";
#	05 Lattitude
vars{5} = 'lat';
units{5} = 'degree_north';
longname{5} = 'Lattitude';
dims{5} = [vars{1}];
filtering{5} = "3 hours";
#	06 Longitude
vars{6} = 'lon';
units{6} = 'degree_east';
longname{6} = 'Longitude';
dims{6} = [vars{1}];
filtering{6} = "3 hours";
#	07 uhp
vars{7} = 'uhp';
units{7} = 'm/s';
longname{7} = 'Current Zonal Velocity';
dims{7} = [vars{1} ',' vars{2}];
filtering{7} = "3 hours";
#	08 vhp
vars{8} = 'vhp';
units{8} = 'm/s';
longname{8} = 'Current Meridional Velocity';
dims{8} = [vars{1} ',' vars{2}];
filtering{8} = "3 hours";
#	09 ulp
vars{9} = 'ulp';
units{9} = 'm/s';
longname{9} = 'Current Zonal Velocity';
dims{9} = [vars{1} ',' vars{2}];
filtering{9} = "3 days";
#	10 v
vars{10} = 'vlp';
units{10} = 'm/s';
longname{10} = 'Current Meridional Velocity';
dims{10} = [vars{1} ',' vars{2}];
filtering{10} = "3 days";
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
fprintf(cdlid,':filtering = "%s";\n',"weighted average , weight=(1+cos(2*pi*(s-t)/T))^2 for |s-t| < T/2");
fprintf(cdlid,':source = "%s";\n',[filename '.mat']);
fprintf(cdlid,':instrument = "ADCP";\n');
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
readme = "In all summary files depth is relative to sea surface.\
  Ship speed dependance should be removed from RDI (Bill).\
  HDSS140 should be re-navigated and then cleaned using existing tag file.\
  After that it should be combined with RDI150, HDSS50 should be navigated, cleaned and combined with RDI75";
fprintf(cdlid,':readme = "%s";\n',readme);
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
  endif
  if(j<length(y))
   fprintf(cdlid,', ');
  else
   fprintf(cdlid,';\n');
  endif
 endfor
endfor
fprintf(cdlid,'}\n')
fclose(cdlid)
unix(['ncgen -k1 -x -b ' cdffile ' -o ' ncfile '&& rm ' cdffile])
