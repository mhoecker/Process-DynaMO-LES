%filterTCCham
gsw_data = 'gsw_data_v3_0.mat';
gsw_data_file = which(gsw_data);
load(gsw_data_file,'version_number','version_date');
gswloc = "/home/mhoecker/work/TEOS-10/";
gswlib = "/home/mhoecker/work/TEOS-10/library/";
tmpdir   = "/home/mhoecker/tmp/";
fileloc = "/home/mhoecker/work/Dynamo/Observations/AurelieObs/";
filename = "TCCham10_leg3";
cdffile  = [tmpdir filename "_filtered_1hr_3day.cdf"];
ncfile   = [fileloc "netCDF/" filename "_filtered_1hr_3day.nc"];
TCChamF.lat = 0;
TCChamF.lon = 80.5;
addpath(gswloc);
addpath(gswlib);
load([fileloc filename ".mat"]);
TCChamF.depth = TCCham.depth;
tidx = 1:length(TCCham.time);
TCChamF.t = TCCham.time(tidx);
TCChamF.th = floor(min(TCChamF.t)*24)/24:1./24:ceil(max(TCChamF.t)*24)/24;
% Get Pressure from depth
TCChamF.P = gsw_p_from_z(-TCChamF.depth,TCChamF.lat);
TCChamF.Pm = mean(TCChamF.P);
TCChamF.Sa = 0*TCCham.S(:,tidx);
TCChamF.Tc = 0*TCCham.T(:,tidx);
TCChamF.eps = TCCham.EPSILON(:,tidx);
TCChamF.rho = TCChamF.Tc;
TCChamF.rhoSa = TCChamF.Tc;
TCChamF.rhoTc = TCChamF.Tc;
% Initialize arays for filtered data
filsize         = [length(TCCham.depth),length(TCChamF.th)];
TCChamF.Sah     = zeros(filsize);
TCChamF.Salp    = zeros(filsize);
TCChamF.Tch     = zeros(filsize);
TCChamF.Tclp    = zeros(filsize);
TCChamF.epsh    = zeros(filsize);
TCChamF.epslp   = zeros(filsize);
TCChamF.rhoh    = zeros(filsize);
TCChamF.rholp   = zeros(filsize);
% Calculate Absolute Salinity and Conservative Temperature
% Needs to be done for each time slice and reassembled
for i=1:length(TCChamF.t)
 TCChamF.Sa(:,i) = gsw_SA_from_SP(TCCham.S(:,tidx(i)),TCChamF.P,TCChamF.lon,TCChamF.lat);
 TCChamF.Tc(:,i) = gsw_CT_from_t(TCChamF.Sa(:,i),TCCham.T(:,tidx(i)),TCChamF.P);
 for j=1:length(TCCham.depth)
  TCChamF.rho(j,i) = gsw_rho_CT(TCChamF.Sa(j,i),TCChamF.Tc(j,i),TCChamF.Pm);
 end%for
end%for
% Calculate the mean Temperature and Salinity
TCChamF.Tcmean= nanmean(nanmean(TCChamF.Tc,2));
TCChamF.Samean= nanmean(nanmean(TCChamF.Sa,2));
% % Calculate the mean Density
TCChamF.rhomean = gsw_rho_CT(TCChamF.Samean,TCChamF.Tcmean,TCChamF.Pm);
% Calculate the linear expansion coefficients at the mean state
TCChamF.alpha = (gsw_rho_CT(TCChamF.Samean,TCChamF.Tcmean*1.001,TCChamF.Pm)-TCChamF.rhomean)/(TCChamF.Tcmean*0.001);
TCChamF.beta  = (gsw_rho_CT(TCChamF.Samean*1.001,TCChamF.Tcmean,TCChamF.Pm)-TCChamF.rhomean)/(TCChamF.Samean*0.001);
% Filter each depth in time
for j=1:length(TCCham.depth)
 TCChamF.Sah(j,:)     = csqfil(TCChamF.Sa(j,:)     ,TCChamF.t  ,TCChamF.th);
 TCChamF.Salp(j,:)    = csqfil(TCChamF.Sah(j,:)    ,TCChamF.th ,TCChamF.th,3);
 TCChamF.Tch(j,:)     = csqfil(TCChamF.Tc(j,:)     ,TCChamF.t  ,TCChamF.th);
 TCChamF.Tclp(j,:)    = csqfil(TCChamF.Tch(j,:)    ,TCChamF.th ,TCChamF.th,3);
 TCChamF.epsh(j,:)    = csqfil(TCChamF.eps(j,:)   ,TCChamF.t  ,TCChamF.th);
 TCChamF.epslp(j,:)   = csqfil(TCChamF.epsh(j,:)   ,TCChamF.th ,TCChamF.th,3);
 TCChamF.rhoh(j,:)    = csqfil(TCChamF.rho(j,:)    ,TCChamF.t  ,TCChamF.th);
 TCChamF.rholp(j,:)   = csqfil(TCChamF.rhoh(j,:)   ,TCChamF.th ,TCChamF.th,3);
end%for
%
%save([fileloc filename "filtered.mat"],"TCChamF");
% Create val cell array with all the data to be out in the netCDF
	val = {TCChamF.t(:)};             %1
	val = {val{:},TCChamF.th(:)};     %2
	val = {val{:},-TCChamF.depth(:)}; %3
	val = {val{:},TCChamF.Pm(:)};     %4
	val = {val{:},TCChamF.P(:)};      %5
	val = {val{:},TCChamF.alpha};     %6
	val = {val{:},TCChamF.beta};      %7
	val = {val{:},TCChamF.lat};       %8
	val = {val{:},TCChamF.lon};       %9
	val = {val{:},TCChamF.Sa(:,:)};   %10
	val = {val{:},TCChamF.Sah(:,:)};  %11
	val = {val{:},TCChamF.Salp(:,:)}; %12
	val = {val{:},TCChamF.Tc(:,:)};   %13
	val = {val{:},TCChamF.Tch(:,:)};  %14
	val = {val{:},TCChamF.Tclp(:,:)}; %15
	val = {val{:},TCChamF.eps(:,:)};  %16
	val = {val{:},TCChamF.epsh(:,:)}; %17
	val = {val{:},TCChamF.epslp(:,:)};%18
	val = {val{:},TCChamF.rho(:,:)};  %19
	val = {val{:},TCChamF.rhoh(:,:)}; %20
	val = {val{:},TCChamF.rholp(:,:)};%21
	val = {val{:},TCChamF.Samean};    %22
	val = {val{:},TCChamF.Tcmean};    %23
	val = {val{:},TCChamF.rhomean};   %24
#Clear all the variables that are no longer needed
	clear TCCham tidx tt zz
#Create the netCDF
	Nvar = length(val);
	Ndim = 4;
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
#	01 time
i=i+1;
vars{i} = 't';
units{i} = 'd';
longname{i} = 'time since 1999 Dec 31 00:00:00';
dims{i} = [vars{1}];
#	02 time hourly
i=i+1;
vars{i} = 'th';
units{i} = 'd';
longname{i} = 'time since 1999 Dec 31 00:00:00';
dims{i} = [vars{2}];
#	03 depth
i=i+1;
vars{i} = 'z';
units{i} = 'm';
longname{i} = 'depth';
dims{i} = [vars{3}];
#	04 Reference Pressure
i=i+1;
vars{i} = 'Pm';
units{i} = 'dbar';
longname{i} = 'Reference Pressure';
dims{i} = [vars{i}];
#	05 Pressure
i=i+1;
vars{i} = 'P';
units{i} = 'dbar';
longname{i} = 'Pressure';
dims{i} = [vars{3}];
#	06 Thermal Expansion
i=i+1;
vars{i} = 'alpha';
units{i} = 'kg/m^3 K';
longname{i} = 'Thermal expansion';
dims{i} = [vars{4}];
#	07 Haline expansion
i=i+1;
vars{i} = 'beta';
units{i} = 'kg/m^3 (kg Cl/ kg H_2O)';
longname{i} = 'Haline contraction';
dims{i} = [vars{4}];
#	08 Lattitude
i=i+1;
vars{i} = 'lat';
units{i} = 'degrees North';
longname{i} = 'lattitude';
dims{i} = [vars{4}];
#	09 Longitude
i=i+1;
vars{i} = 'lon';
units{i} = 'degrees East';
longname{i} = 'longitude';
dims{i} = [vars{4}];
#	10 Absolute Salinity
i=i+1;
vars{i} = 'Sa';
units{i} = 'gram/kg';
longname{i} = 'Absolute Salinity';
dims{i} = [vars{1} ',' vars{3}];
#	11 Hourly Absolute Salinity
i=i+1;
vars{i} = 'Sa_h';
units{i} = 'gram/kg';
longname{i} = 'Absolute Salinity';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 hours";
#	12 Daily Absolute Salinity
i=i+1;
vars{i} = 'Sa_d';
units{i} = 'gram/kg';
longname{i} = 'Absolute Salinity';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 days";
#	13 Conserved Temperature
i=i+1;
vars{i} = 'Tc';
units{i} = 'Celsius';
longname{i} = 'Conservative Temperature';
dims{i} = [vars{1} ',' vars{3}];
#	14 Hourly Conserved Temperature
i=i+1;
vars{i} = 'Tc_h';
units{i} = 'gram/kg';
longname{i} = 'Conservative Temperature';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 hours";
#	15 Daily Conserved Temperature
i=i+1;
vars{i} = 'Tc_d';
units{i} = 'gram/kg';
longname{i} = 'Conservative Temperature';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 days";
#	16 Dissipation
i=i+1;
vars{i} = 'epsilon';
units{i} = 'm^2/s^3';
longname{i} = 'Turbulent Dissipation';
dims{i} = [vars{1} ',' vars{3}];
#	17 Hourly Dissipation
i=i+1;
vars{i} = 'epsilon_h';
units{i} = 'm^2/s^3';
longname{i} = 'Turbulent Dissipation';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 hours";
#	18 Daily Dissipation
i=i+1;
vars{i} = 'epsilon_d';
units{i} = 'm^2/s^3';
longname{i} = 'Turbulent Dissipation';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 days";
#	19 Potential Density
i=i+1;
vars{i} = 'rho';
units{i} = 'kg/m^3';
longname{i} = 'Potential Density';
dims{i} = [vars{1} ',' vars{3}];
#	20 Hourly Potential Density
i=i+1;
vars{i} = 'rho_h';
units{i} = 'kg/m^3';
longname{i} = 'Potential Density';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 hours";
#	21 Daily Potential Density
i=i+1;
vars{i} = 'rho_d';
units{i} = 'kg/m^3';
longname{i} = 'Potential Density';
dims{i} = [vars{2} ',' vars{3}];
filtering{i} = "3 days";
#	22 Mean Absolute Salinity
i=i+1;
vars{i} = 'Sa_m';
units{i} = 'gram/kg';
longname{i} = 'Mean Absolute Salinity';
dims{i} = [vars{4}];
#	23 Mean Conservative Temperature
i=i+1;
vars{i} = 'Tc_m';
units{i} = 'Celsius';
longname{i} = 'Mean Conservative Temperature';
dims{i} = [vars{4}];
#	24 Mean Conservative Temperature
i=i+1;
vars{i} = 'rho_m';
units{i} = 'kg/m^3';
longname{i} = 'Mean Potential Density';
dims{i} = [vars{4}];
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
fprintf(cdlid,':Gibbs_Sea_Water = "version %s, %s";\n',version_number,version_date);
fprintf(cdlid,':instrument = "Merged Tchain and Chameleon";\n');
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
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
unix(['ncgen -k1 -x -b ' cdffile ' -o ' ncfile ])
%unix(['ncgen -k1 -x -b ' cdffile ' -o ' ncfile '&& rm ' cdffile])
