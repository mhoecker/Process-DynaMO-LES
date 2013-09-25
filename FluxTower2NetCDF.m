function FluxTower2NetCDF(inloc,fname,outloc)
%%
%% This script converts the .mat data into
%% a CDl ascii file it then uses `ncgen` to  convert the
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
matfile = [inloc fname,'.mat'];
ncfile = [outloc fname '.nc'];
tmp = "/home/mhoecker/tmp/";
cdffile = [tmp fname '.cdf'];
#
load(matfile);
#
cdlid = fopen(cdffile,'w');
fprintf(cdlid,'netcdf %s {\n', fname);
#
vars = {};
longname = {};
units = {};
instrument = {};
val = {};
k=0;
#
k=k+1;
vars = {vars{:},"yday"};
units = {units{:},"day"};
longname = {longname{:},"2011 year day at start of average"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.time(:)-datenum(2011,1,0)};
#
k=k+1;
vars = {vars{:},"U10"};
units = {units{:},"meter/second"};
longname = {longname{:},"Wind Speed at 10m, earth relative"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.U10(:)};
#
k=k+1;
vars = {vars{:},"wdir"};
units = {units{:},"degrees"};
longname = {longname{:},"Direction earth relative wind comes from measured clocwise from True North"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.wdir(:)};
#
k=k+1;
vars = {vars{:},"SST"};
units = {units{:},"Celcius"};
longname = {longname{:},"Sea Surface Temperature"};
instrument = {instrument{:}, "Sea Snake - cool skin"};
val = {val{:},PSDfx.SST(:)};
#
k=k+1;
vars = {vars{:},"Tsea"};
units = {units{:},"Celcius"};
longname = {longname{:},"Temperature"};
instrument = {instrument{:}, "Sea Snake"};
val = {val{:},PSDfx.Tsea(:)};
#
k=k+1;
vars = {vars{:},"T10"};
units = {units{:},"Celcius"};
longname = {longname{:},"Air Temperature"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.T10(:)};
#
k=k+1;
vars = {vars{:},"SSQ"};
units = {units{:},"gram/kilogram"};
longname = {longname{:},"Sea Surface specific humidity"};
instrument = {instrument{:}, "From Qsea - cool skin"};
val = {val{:},PSDfx.SSQ(:)};
#
k=k+1;
vars = {vars{:},"Qsea"};
units = {units{:},"gram/kilogram"};
longname = {longname{:},"Near surface specific humidity"};
instrument = {instrument{:},"Sea Snake"};
val = {val{:},PSDfx.Qsea(:)};
#
k=k+1;
vars = {vars{:},"Solardn"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Downward Short Wave Radiation Flux"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.Solardn(:)};
#
k=k+1;
vars = {vars{:},"Solarup"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Upward Short Wave Radiation Flux"};
instrument = {instrument{:},"estimated from Payne (1972)"};
val = {val{:},PSDfx.Solarup(:)};
#
k=k+1;
vars = {vars{:},"IRdn"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Downward Long Wave Radiation Flux"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.IRdn(:)};
#
k=k+1;
vars = {vars{:},"IRup"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Upward Long Wave Radiation Flux"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.IRup(:)};
#
k=k+1;
vars = {vars{:},"P"};
units = {units{:},"mm/hour"};
longname = {longname{:},"Precipitation Rate"};
instrument = {instrument{:}, "PSD STI optical rain gauge"};
val = {val{:},PSDfx.P(:)};
#
k=k+1;
vars = {vars{:},"SOG"};
units = {units{:},"m/s"};
longname = {longname{:},"Speed over gound"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.SOG(:)};
#
k=k+1;
vars = {vars{:},"COG"};
units = {units{:},"degrees"};
longname = {longname{:},"Course over gound (clocwise from true North)"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.COG(:)};
#
k=k+1;
vars = {vars{:},"Ur10"};
units = {units{:},"m/s"};
longname = {longname{:},"Wind Speed at 10m, water relative"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.Ur10(:)};
#
k=k+1;
vars = {vars{:},"wdirR"};
units = {units{:},"degrees"};
longname = {longname{:},"Wind Direction, water relative (clocwise from true North)"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.wdirR(:)};
#
k=k+1;
vars = {vars{:},"Lat"};
units = {units{:},"degrees"};
longname = {longname{:},"Latitude"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.Lat(:)};
#
k=k+1;
vars = {vars{:},"stress"};
units = {units{:},"Newton/meter^2"};
longname = {longname{:},"bulk wind stress magnitude"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.stress(:)};
#
k=k+1;
vars = {vars{:},"shf"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Sensible heat Flux"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.shf(:)};
#
k=k+1;
vars = {vars{:},"lhf"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Latent heat Flux"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.lhf(:)};
#
k=k+1;
vars = {vars{:},"rhf"};
units = {units{:},"Watt/meter^2"};
longname = {longname{:},"Rain sensible heat Flux"};
instrument = {instrument{:},""};
val = {val{:},PSDfx.rhf(:)};
#
# Declare Dimensions
fprintf(cdlid,'dimensions:\n %s=%i;\n',vars{1},length(val{1}(:)));
# Declare variables
fprintf(cdlid,'variables:\n');
for i=1:k
 fprintf(cdlid,'double %s(%s);\n',vars{i},vars{1});
# Add units, long_name and instrument
 fprintf(cdlid,'\n');
 fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
 fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
 if(length(instrument{i})>1)
  fprintf(cdlid,'%s:instrument = "%s";\n',vars{i},instrument{i});
 endif
endfor
#Declare global attributes
fprintf(cdlid,':source = "%s";\n',[fname '.mat']);
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
fprintf(cdlid,':Flux_Algorithm = "bulk COARE version 3.0";\n');
fprintf(cdlid,':LW_Flux = "Fairall et al. Jtech, 1998.";\n');
fprintf(cdlid,':Sea_Snake_Depth = "0.05 meters";\n');
fprintf(cdlid,':TSG_Depth = "5 meters";\n');
fprintf(cdlid,':PSD_Height = "18 meters";\n');
fprintf(cdlid,':PSD_sonic_Height = "18.5 meters";\n');
fprintf(cdlid,':IMET_Height = "21 meters";\n');


writeCDFdata(cdlid,val,vars)
#fprintf(cdlid,'data:\n')
#for i=1:M
# y = X(:,i);
# fprintf(cdlid,'%s =\n',vars{i});
# for j=1:N
#  if(isnan(y(j))==1)
#   fprintf(cdlid,'NaN');
#  else
#   fprintf(cdlid,'%20.20g',y(j));
#  endif
#  if(j<N)
#   fprintf(cdlid,', ');
#  else
#   fprintf(cdlid,';\n');
#  endif
# endfor
#endfor
#fprintf(cdlid,'}\n', fname)
#fclose(cdlid)
unix(['ncgen -o ' ncfile ' ' cdffile ' && rm ' cdffile])
