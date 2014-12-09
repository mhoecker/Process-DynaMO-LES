function filterRAMAadcp(filename,fileloc,trange,zrange)
 tmpdir   = "/home/mhoecker/tmp/";
 filtersuffix = "_1hr_data_3day_filter";
 if nargin()<4
  zrange = [0,-100];
 end%if
 if nargin()<3
  trange = [324,334];
 end%if
 if nargin()<2
  fileloc = '/home/mhoecker/work/Dynamo/Observations/netCDF/RAMA/';
 end%if
 if nargin()<1
  filename = 'uv_RAMA_0N80E';
 endif
cdffile  = [tmpdir filename filtersuffix ".cdf"];
ncfile   = [fileloc filename filtersuffix ".nc"];
nc = netcdf([fileloc filename '.nc'],'r');
t = nc{'t'}(:);
tidx = inclusiverange(t,trange);
t = nc{'t'}(tidx);
dt = diff(t);
% depths
z = nc{'z'}(:);
zidx = inclusiverange(z,zrange);
z = nc{'z'}(zidx);
% velocity data
u = nc{'u'}(tidx,zidx);
v = nc{'v'}(tidx,zidx);
% choose days near station
s = floor(min(trange)):1/24:ceil(max(trange));
ds = mean(diff(s));
ulp = zeros(length(s),length(z));
uhp = zeros(length(s),length(z));
vlp = zeros(length(s),length(z));
vhp = zeros(length(s),length(z));
for i=1:length(z)
 uhp(:,i) =csqfil(u(:,i),t,s,3*ds);
 ulp(:,i) =csqfil(uhp(:,i),s,s,3);
 vhp(:,i) =csqfil(v(:,i),t,s,3*ds);
 vlp(:,i) =csqfil(vhp(:,i),s,s,3);
end%for
	val = {s(:)};
	val = {val{:},z(:)};
	val = {val{:},uhp(:,:)'};
	val = {val{:},vhp(:,:)'};
	val = {val{:},ulp(:,:)'};
	val = {val{:},vlp(:,:)'};
	clear s z uhp vhp ulp vlp
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
longname{1} = '2011 yearday';
dims{1} = [vars{1}];
#	02 depth
vars{2} = 'z';
units{2} = 'm';
longname{2} = 'depth';
dims{2} = [vars{2}];
#	03 uhp
vars{3} = 'uhp';
units{3} = 'm/s';
longname{3} = 'Current Zonal Velocity';
dims{3} = [vars{1} ',' vars{2}];
filtering{3} = "3 hours";
#	04 vhp
vars{4} = 'vhp';
units{4} = 'm/s';
longname{4} = 'Current Meridional Velocity';
dims{4} = [vars{1} ',' vars{2}];
filtering{4} = "3 hours";
#	05 ulp
vars{5} = 'ulp';
units{5} = 'm/s';
longname{5} = 'Current Zonal Velocity';
dims{5} = [vars{1} ',' vars{2}];
filtering{5} = "3 days";
#	6 v
vars{6} = 'vlp';
units{6} = 'm/s';
longname{6} = 'Current Meridional Velocity';
dims{6} = [vars{1} ',' vars{2}];
filtering{6} = "3 days";
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
fprintf(cdlid,':source = "%s";\n',[filename '.nc']);
fprintf(cdlid,':instrument = "ADCP";\n');
fprintf(cdlid,':platform = "RAMA Mooring";\n');
fprintf(cdlid,':Lattitude = "80.5";\n');
fprintf(cdlid,':Longitude = "0";\n');
# Declare Data
writeCDFdata(cdlid,val,vars)
#fprintf(cdlid,'data:\n')
#for i=1:Nvar
# y = val{i}(:);
# fprintf(cdlid,'%s =\n',vars{i});
# for j=1:length(y)
#  if(isnan(y(j))==1)
#   fprintf(cdlid,'NaN');
#  else
#   fprintf(cdlid,'%f',y(j));
#  endif
#  if(j<length(y))
#   fprintf(cdlid,', ');
#  else
#   fprintf(cdlid,';\n');
#  endif
# endfor
#endfor
#fprintf(cdlid,'}\n')
#fclose(cdlid)
unix(['ncgen -k1 -x -b ' cdffile ' -o ' ncfile '&& rm ' cdffile])
end%function
