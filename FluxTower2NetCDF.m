%% 
%% This script converts the raw 32 columns of acii data into
%% a CDl ascii file which it the uses `ncgen` to  convert the 
%% CDL text file into a NetCDF file.  "ncgen" is a utility program 
%% which is part of NetCDF which can be aquired here
%% http://www.unidata.ucar.edu/software/netcdf/
%%
%% Mart!n Hoecker-Martinez
%% mhoecker@coas.oregonstate.edu
%% 
%% This program is provided with no guarntees whatsoever
%%
%%
loc = "/home/mhoecker/work/les/forMartin/input/";
tmp = "/home/mhoecker/tmp/";
fname = 'DYNAMO_2011_Leg3_PSD_flux_5min_all';
cdlid = fopen([tmp fname '.cdl'],'w');
fprintf(cdlid,'netcdf %s {\n', fname);
X = load([loc fname,'.txt']);
Ns = size(X);
t = X(:,1);
N = Ns(1);
M = Ns(2);
vars = {};
longname = {};
units = {};
instrument = {}
for i=1:M;
 vars = {vars{:},['var' num2str(i)]};
 units = {units{:},'TBD'};
 longname = {longname{:},''};
 instrument = {instrument{:},''};
endfor
vars{1} = "t";
units{1} = "days";
longname{1} = "2011 year day at start of average";
#
vars{2} = "WS";
units{2} = "meter/second";
longname{2} = "Wind Speed";
instrument{2} = "PSD sonic";
#
vars{3} = "WH";
units{3} = "degrees";
longname{3} = "Wind Heading Direction wind comes from measured clocwise from True North";
instrument{3} = "PSD sonic";
#
vars{4} = "SST";
units{4} = "Celcius";
longname{4} = "Sea Surface Temperature";
instrument{4} = "Sea Snake";
#
vars{5} = "T";
units{5} = "Celcius";
longname{5} = "Temperature";
instrument{5} = "TSG";
#
vars{6} = "S";
units{6} = "PSU";
longname{6} = "Salinity";
instrument{6} = "TSG";
#
vars{7} = "AT";
units{7} = "Celcius";
longname{7} = "Air Temperature";
instrument{7} = "PSD";
#
vars{8} = "SSQ";
units{8} = "gram/kilogram";
longname{8} = "Sea Surface specific humidity";
instrument{8} = "Sea Snake";
#
vars{9} = "AQ";
units{9} = "gram/kilogram";
longname{9} = "Air specific humidity";
instrument{9} = "PSD";
#
vars{10} = "SWRF";
units{10} = "Watt/meter^2";
longname{10} = "net Short Wave Radiation Flux + = downward (correct by multiplying by 1.01)";
instrument{10} = "PSD";
#
vars{11} = "LWRF";
units{11} = "Watt/meter^2";
longname{11} = "incident Long Wave Radiation Flux + = downward";
instrument{11} = "PSD";
#
vars{12} = "PR";
units{12} = "mm/hour";
longname{12} = "uncorrected Precipitation Rate";
instrument{12} = "PSD STI optical rain gauge";
#
vars{13} = "VS";
units{13} = "m/s";
longname{13} = "Vessel Speed";
instrument{13} = "SCS";
#
vars{14} = "VH";
units{14} = "degrees";
longname{14} = "Vessel Heading measured clocwise from True North";
instrument{14} = "SCS";
#
vars{15} = "RWS";
units{15} = "m/s";
longname{15} = "Relative Wind Speed";
instrument{15} = "PSD";
#
vars{16} = "RWH";
units{16} = "degrees";
longname{16} = "Relative Wind Heading Direction wind comes from measured clocwise from the bow";
instrument{16} = "PSD sonic";
#
vars{17} = "lat";
units{17} = "degrees";
longname{17} = "Latitude";
instrument{17} = "SCS pcode";
#
vars{18} = "lon";
units{18} = "degrees";
longname{18} = "Longitude";
instrument{18} = "SCS pcode";
#
vars{19} = "Zref";
units{19} = "m";
longname{19} = "Depth for bulk flux Ts reference";
instrument{19} = "SCS pcode";
#
vars{20} = "VSsd";
units{20} = "m/s";
longname{20} = "standard deviation of Vessel Speed";
instrument{20} = "SCS pcode";
#
vars{21} = "Tau";
units{21} = "Newton/meter^2";
longname{21} = "bulk wind stress magnitude";
#
vars{22} = "SF";
units{22} = "Watt/meter^2";
longname{22} = "Sensible heat Flux";
#
vars{23} = "LF";
units{23} = "Watt/meter^2";
longname{23} = "Latent heat Flux";
#
vars{24} = "RainF";
units{24} = "Watt/meter^2";
longname{24} = "Rain heat Flux";
#
vars{25} = "TA2";
units{25} = "Celcius";
longname{25} = "Air Temperature";
instrument{25} = "IMET";
#
vars{26} = "AQ2";
units{26} = "gram/kilogram";
longname{26} = "Air specific humidity";
instrument{26} = "IMET";
#
vars{27} = "VSOG";
units{27} = "m/s";
longname{27} = "Vessel Speed Over Ground";
#
vars{28} = "VH2";
units{28} = "degrees";
longname{28} = "Vessel Heading measured clocwise from True North";
instrument{28} = "gyro";
#
vars{29} = "SWRF2";
units{29} = "Watt/meter^2";
longname{29} = "Solar flux";
instrument{29} = "ship pyranometer";
#
vars{30} = "LWRF2";
units{30} = "Watt/meter^2";
longname{30} = "Infrared flux";
instrument{30} = "ship pirgeometer";
#
vars{31} = "P";
units{31} = "hectopascal";
longname{31} = "barometric Pressure";
instrument{31} = "IMET";
#
vars{32} = "RH";
units{32} = "";
longname{32} = "RHvais";
instrument{32} = "PSD";
#
%vars
%units
# Declare Dimensions
fprintf(cdlid,'dimensions:\n %s=%i;\n',vars{1},N);
# Declare variables
fprintf(cdlid,'variables:\n');
for i=1:M
 fprintf(cdlid,'double %s(%s);\n',vars{i},vars{1});
endfor
# Add units, long_name and instrument
fprintf(cdlid,'\n');
for i=1:M
 fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
 fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
 if(length(instrument{i})>1)
  fprintf(cdlid,'%s:instrument = "%s";\n',vars{i},instrument{i});
 endif
endfor
#Declare global attributes
fprintf(cdlid,':source = "%s";\n',[fname '.txt']);
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
fprintf(cdlid,':Flux_Algorithm = "bulk COARE version 3.0";\n');
fprintf(cdlid,':LW_Flux = "Fairall et al. Jtech, 1998.";\n');
fprintf(cdlid,':Sea_Snake_Depth = "0.05 meters";\n');
fprintf(cdlid,':TSG_Depth = "5 meters";\n');
fprintf(cdlid,':PSD_Height = "18 meters";\n');
fprintf(cdlid,':PSD_sonic_Height = "18.5 meters";\n');
fprintf(cdlid,':IMET_Height = "21 meters";\n');


# Declare Data
fprintf(cdlid,'data:\n')
Y = X;
for i=1:M
 y = X(:,i);
 fprintf(cdlid,'%s =\n',vars{i}); 
 for j=1:N
  if(isnan(y(j))==1)
   fprintf(cdlid,'NaN');
  else
   fprintf(cdlid,'%f',y(j));
  endif
  if(j<N)
   fprintf(cdlid,', ');
  else
   fprintf(cdlid,';\n');
  endif
 endfor
endfor
fprintf(cdlid,'}\n', fname)
fclose(cdlid)
unix(['ncgen -o ' fname '.nc ' tmp fname '.cdl'])
unix(['rm ' tmp fname '.cdl'])
