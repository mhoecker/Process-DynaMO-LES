function FilterRevelleMet2(inloc,fname,T,tmp)
 %
 % This script filters RevelleMetRev2 netCDF data into
 % a CDl ascii file which it then uses `ncgen` to  convert the
 % CDL text file into a NetCDF file.  "ncgen" is a utility program
 % which is part of NetCDF which can be aquired here
 % http://www.unidata.ucar.edu/software/netcdf/
 %
 % Mart!n Hoecker-Martinez
 % mhoecker@coas.oregonstate.edu
 %
 % This program is provided with no guarntees whatsoever
 %
 %
 infile = [inloc  fname '.nc'];
 if(nargin<3)
  T = 1./24;
 elseif(T<1/(24*60*60))
   error("Filter period is too short")
 end%if
 if(nargin<4)
  tmp = "/home/mhoecker/tmp/";
  %tmp = [outloc "tmp"];
 end%if
 outsfx = "filter";
 if(T>=1)
  outsfx = [ num2str(T,3) "day" outsfx ];
 elseif(24*T>=1)
  outsfx = [ num2str(T*24,3) "hour" outsfx ];
 else
  outsfx = [ num2str(T*24*60,3) "days" outsfx ];
 end%if
 ncfile  = [inloc fname outsfx ".nc"];
 cdffile = [tmp   fname outsfx '.cdf'];
 nc = netcdf(infile,'r');
 t = nc{'Yday'}(:);
% s = floor(min(t)/T)*T:T:ceil((1+min(t))/T)*T;
 s = floor(min(t)/T)*T:T:ceil(max(t)/T)*T;
 cdlid = fopen(cdffile,'w');
 fprintf(cdlid,'netcdf %s {\n', fname);
 %Yday Decimal yearday (UTC) To convert to matlab time format use:
 % yd0=datenum(datestr('01-Jan-2011 00:00:00'))-1;
 % tmatlab=yday+yd0;
 i=1;
 vars{i} = "Yday";
 units{i} = "days";
 longname{i} = "2011 year day (UTC)";
 instrument = {''};
 vartype = {'double'};
 vals = {s};
 i = i+1;
 %Lat       Latitude (deg)
 vars{i} = "Lat";
 units{i} = "degrees";
 longname{i} = "Latitude";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Lat'}(:),t,s)};
 i = i+1;
 %Lon       Longitude (deg)
 vars{i} = "Lon";
 units{i} = "degrees";
 longname{i} = "Longitude";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Lon'}(:),t,s)};
 i = i+1;
 %SOG       Speed over ground (m/s)
 SOG = nc{'SOG'}(:);
 %COG       Course over ground (deg)
 COG = nc{'COG'}(:);
 % create a velocity over ground  = [UOG,VOG] from SOG and COG
 [UOG,VOG]  = SpeedHeadingtoUV(SOG,COG,"NorthCWto");
 %UOG       East/West velocity over ground (m/s)
 vars{i} = "UOG";
 units{i} = "meters/second";
 longname{i} = "East/West velocity over ground";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(UOG,t,s)};
 i = i+1;
 %UOG       North/South velocity over ground (m/s)
 vars{i} = "VOG";
 units{i} = "m/s";
 longname{i} = "North/South velocity over gound";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(VOG,t,s)};
 i = i+1;
 %Heading   Ship's heading (deg)
 vars{i} = "Heading";
 units{i} = "degrees from True North";
 longname{i} = "Ship's heading";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Heading'}(:),t,s)};
 i = i+1;
 %Cspd      Current speed (m/s)
 %Cdir      Current direction (deg) from
 [Usc,Vsc]  = SpeedHeadingtoUV(nc{'Cspd'}(:),nc{'Cdir'}(:),"NorthCWfrom");
 %Usc      Current East/West velocity (m/s) to
 vars{i} = "Usc";
 units{i} = "meters/second";
 longname{i} = "East/West Surface current velocity (to)";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(Usc,t,s)};
 i = i+1;
 %Vsc      Current direction (deg) from
 vars{i} = "Vsc";
 units{i} = "merters / second";
 longname{i} = "North/South Surface current velocity (to)";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(Vsc,t,s)};
 i = i+1;
 %U10       Wind speed (m/s) relative to earth adjusted to 10 m
 %Wdir      Wind direction (deg) from relative to earth
 [U10,V10] = SpeedHeadingtoUV(nc{'U10'}(:),nc{'Wdir'}(:),"NorthCWfrom");
 %U10      East/West Wind velocity (m/s) to relative to earth
 vars{i} = "U10";
 units{i} = "meters/second";
 longname{i} = "East/West Wind velocity relative to earth adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(U10,t,s)};
 i = i+1;
 %Wdir      Wind direction (deg) from relative to earth
 vars{i} = "V10";
 units{i} = "meters/second";
 longname{i} = "East/West Wind velocity relative to earth adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(V10,t,s)};
 i = i+1;
 clear U10 V10
 %Ur10      Wind speed (m/s) relative to water adjusted to 10 m
 %WdirR     Wind direction (deg) from relative to water
 [Ur10,Vr10] = SpeedHeadingtoUV(nc{'Ur10'}(:),nc{'WdirR'}(:),"NorthCWfrom");
 %Ur10      East/West Wind velocity (m/s) relative to water adjusted to 10 m
 vars{i} = "Ur10";
 units{i} = "meters/second";
 longname{i} = "East/West Wind velocity relative to water adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(Ur10,t,s)};
 i = i+1;
 %Vr10      North/South Wind velocity (m/s) relative to water adjusted to 10 m
 vars{i} = "Vr10";
 units{i} = "meters/second";
 longname{i} = "North/South Wind velocity relative to water adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(Vr10,t,s)};
 i = i+1;
 %Pair10    Pressure (mb) adjusted to 10 m
 vars{i} = "Pair10";
 units{i} = "millibar";
 longname{i} = "Pressure adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Pair10'}(:),t,s)};
 i = i+1;
 %RH10      Relative humidity(%) adjusted to 10 m
 vars{i} = "RH10";
 units{i} = "Percentage";
 longname{i} = "Relative humidity adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'RH10'}(:),t,s)};
 i = i+1;
 %T10       Temperature (C) adjusted to 10 m
 vars{i} = "T10";
 units{i} = "Celsius";
 longname{i} = "Temperature adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'T10'}(:),t,s)};
 i = i+1;
 %Tsea      Near surface sea temperature (C) from Sea snake
 vars{i} = "Tsea";
 units{i} = "Celsius";
 longname{i} = "Near surface sea temperature";
 instrument{i} =  "Primarily Sea snake, few values provided by the IR radiometer deployed by LDEO";
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Tsea'}(:),t,s)};
 i = i+1;
 %SST       Sea surface temperature (C) from Tsea minus cool skin
 vars{i} = "SST";
 units{i} = "Celsius";
 longname{i} = "Sea surface temperature from Tsea minus cool skin";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'SST'}(:),t,s)};
 i = i+1;
 %Q10       Specific humidity (g/Kg) adjusted to 10 m
 vars{i} = "Q10";
 units{i} = "gram / kilogram";
 longname{i} = "Specific humidity adjusted to 10 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Q10'}(:),t,s)};
 i = i+1;
 %Qsea      Specific humidity (g/Kg) 'near' ocean surface from sea snake
 vars{i} = "Qsea";
 units{i} = "gram / kilogram";
 longname{i} = "Specific humidity 'near' ocean surface";
 instrument{i} =  "Sea snake";
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Qsea'}(:),t,s)};
 i = i+1;
 %SSQ       Sea surface specific humidity (g/Kg) from Qsea minus cool skin
 vars{i} = "SSQ";
 units{i} = "gram / kilogram";
 longname{i} = "Sea surface specific humidity from Qsea minus cool skin";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'SSQ'}(:),t,s)};
 i = i+1;
 %stresx    Surface stress (N/m2) measured relative to water
 vars{i} = "stresx";
 units{i} = "Newton / meter^2";
 longname{i} = "Surface stress measured relative to water";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'stress'}(:).*Ur10./nc{'Ur10'}(:),t,s)};
 i = i+1;
 %stresy    Surface stress (N/m2) measured relative to water
 vars{i} = "stresy";
 units{i} = "Newton / meter^2";
 longname{i} = "Surface stress measured relative to water";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'stress'}(:).*Vr10./nc{'Ur10'}(:),t,s)};
 i = i+1;
 %shf       Sensible heat flux (W/m2)
 vars{i} = "shf";
 units{i} = "Watt / meter^2";
 longname{i} = "Sensible heat flux";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'shf'}(:),t,s)};
 i = i+1;
 %lhf       Latent heat flux (W/m2)
 vars{i} = "lhf";
 units{i} = "Watt / meter^2";
 longname{i} = "Latent heat flux";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'lhf'}(:),t,s)};
 i = i+1;
 %rhf       Sensible heat flux from rain (W/m2)
 vars{i} = "rhf";
 units{i} = "Watt / meter^2";
 longname{i} = "Sensible heat flux from rain";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'rhf'}(:),t,s)};
 i = i+1;
 %Solarup   Reflected solar (W/m2) estimated from Payne (1972)
 vars{i} = "Solarup";
 units{i} = "Watt / meter^2";
 longname{i} = "Reflected solar estimated from Payne (1972)";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Solarup'}(:),t,s)};
 i = i+1;
 %Solardn   Measured downwelling solar (W/m2)
 vars{i} = "Solardn";
 units{i} = "Watt / meter^2";
 longname{i} = "Measured downwelling solar";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Solardn'}(:),t,s)};
 i = i+1;
 %IRup      Upwelling IR (W/m2) computed from SST
 vars{i} = "IRup";
 units{i} = "Watt / meter^2";
 longname{i} = "Upwelling IR computed from SST";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'IRup'}(:),t,s)};
 i = i+1;
 %IRdn      Measured downwelling IR (W/m2)
 vars{i} = "IRdn";
 units{i} = "Watt / meter^2";
 longname{i} = "Measured downwelling IR";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'IRdn'}(:),t,s)};
 i = i+1;
 %E         Evaporation rate (mm/hr)
 vars{i} = "E";
 units{i} = "milimeter / hour";
 longname{i} = "Evaporation rate";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'E'}(:),t,s)};
 i = i+1;
 %P         Precipitation rate (mm/hr)
 vars{i} = "P";
 units{i} = "milimeter / hour";
 longname{i} = "Precipitation rate";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'P'}(:),t,s)};
 i = i+1;
 %Evap      Accumulated evaporation for Leg (mm)
 vars{i} = "Evap";
 units{i} = "milimeter";
 longname{i} = "Accumulated evaporation for Leg";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Evap'}(:),t,s)};
 i = i+1;
 %Precip    Accumulated precipitation for Leg (mm)
 vars{i} = "Precip";
 units{i} = "milimeter";
 longname{i} = "Accumulated precipitation for Leg";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Precip'}(:),t,s)};
 i = i+1;
 %Interped  1= interpolated due to poor relative winds 0=no interpolation
 vars{i} = "Interped";
 units{i} = "N/A";
 longname{i} = "0=no interpolation, 1=interpolated due to poor relative winds";
 instrument = {instrument{:},''};
 vartype{i} = "byte";
 vals = {vals{:},ceil(csqfil(nc{'Interped'}(:),t,s))};
 i = i+1;
 %T02       Temperature (C) adjusted to 2 m
 vars{i} = "T02";
 units{i} = "Celsius";
 longname{i} = "Temperature adjusted to 2 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'T02'}(:),t,s)};
 i = i+1;
 %Q02       Specific humidity (g/Kg) adjusted to 2 m
 vars{i} = "Q02";
 units{i} = "gram / kilogram";
 longname{i} = "Specific humidity adjusted to 2 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'Q02'}(:),t,s)};
 i = i+1;
 %RH02      Relative humidity(%) adjusted to 2 m
 vars{i} = "RH02";
 units{i} = "percent";
 longname{i} = "Relative humidity adjusted to 2 m";
 instrument = {instrument{:},''};
 vartype = {vartype{:},'double'};
 vals = {vals{:},csqfil(nc{'RH02'}(:),t,s)};
 %
 ncclose(nc);
 % Declare Dimensions
 fprintf(cdlid,'dimensions:\n %s=%i;\n',vars{1},length(s));
 % Declare variables with units, long_name and instrument
 fprintf(cdlid,'variables:\n');
 for i=1:length(vals)
  fprintf(cdlid,'%s %s(%s);\n',vartype{i},vars{i},vars{1});
  fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
  fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
  if(length(instrument{i})>1)
   fprintf(cdlid,'%s:instrument = "%s";\n',vars{i},instrument{i});
  end%if
  fprintf(cdlid,'\n');
 end%for
 fprintf(cdlid,':source = "%s";\n',infile);
 fprintf(cdlid,':filtering = "%s";\n',"weighted average , weight=(1+cos(2*pi*(s-t)/T))^2 for |s-t| < T/2");
 fprintf(cdlid,':filter_period = "T=%f";\n',3*diff(s));
 fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
 fprintf(cdlid,':Flux_Algorithm = "bulk COARE version 3.0";\n');
 fprintf(cdlid,':Flux_Direction = "negative downward and positive upwards";\n');
 fprintf(cdlid,':Wind-Current_Direction = "oceanographic convention (direction to)";\n');
 notes = " 12/10/11 Tair is taken from the calibrated PSD and UConn aspirated air temperature sensors on the bow mast. These were least affected by solar heating. Qair and Pair are computed the calibrated UConn RH/T/P sensors on the on the bow mast. Q is less sensitive to solar heating as long as the temperature and RH are measured simultaneously. RH is reconstructed from the Q, aspirated Tair and P measurements to remove the effects of solar heating. The sonic anemometers on the bow mast are used to measure the wind speed and direction. Relative wind speed is taken into consideration to minimize flow distortion. SST is estimated after correction for cool skin and this accounts for the difference between Tsea and SST. Similar corrections are applied to SSQ from Qsea. Solardn is provided by the ship's pyranometer on the top of the forward mast. IRdn represents an average of the gyrostabilized PSD purgeometer on top of its van and the ship's purgeometer on the top of the forward mast. The ship's purgeometer was first corrected for the effects of solar heating. Solarup is taken from a commonly used parameterization for surface albedo of the ocean (Payne, 1972). IRup was derived from the SST measurements using the COARE 3.0 algorithm. The bulk fluxes of stress (momentum), sensible heat, latent heat and sensible heat due to rain were provided by the COARE 3.0 algorithm. The COARE 3.0 algorithm was also used to compute the 10-m values of wind speed, temperature and humidity. SOG, COG and Gyro were taken from the PSD GPS compass. These were used to compute the wind speed relative to earth. Surface currents are measured by the ship's ADCP and have been QCed by OSU Ocean Mixing group. These were used to compute the wind speed relative to water. The wind speed relative to water are used to compute the fluxes. 10/08/12 New calibrations were applied to the RH measurements from the UConn and ETL sensors. The calibration raised the RH values 1-2%, which modifies slightly the flux estimates and any variabiles adjusted using MO similarity. Values of temperature, specific humidity and relative humidity adjusted to 2-m were added to the matlab and ASCII files.";
 fprintf(cdlid,':Notes = "%s";\n',notes)
 # Declare Data
 fprintf(cdlid,'data:\n')
 for i=1:length(vals)
  y = vals{i};
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
   end%if
  end%for
 end%for
 fprintf(cdlid,'}\n', fname)
 fclose(cdlid)
 unix(['ncgen -o ' ncfile ' ' cdffile ' && rm ' cdffile])
end%function
% this might need to be its own function someday
function [U,V] = SpeedHeadingtoUV(speed,heading,ref)
%  ref = "NorthCWto"
%  ref = "NorthCWfrom"
%  ref = "EastCCWto"
%  others are yet to be implemented
%
 if(nargin<3)
  ref = "NorthCWto";
 end%if
 switch ref
  case "NorthCWto"
    U = speed.*sin(heading*pi/180);
    V = speed.*cos(heading*pi/180);
   case "NorthCWfrom"
    U = -speed.*sin(heading*pi/180);
    V = -speed.*cos(heading*pi/180);
   case "EastCCWto"
    U = speed.*cos(heading*pi/180);
    V = speed.*sin(heading*pi/180);
    otherwise
     error("ref must be one of 'NorthCWto' 'NorthCWfrom' or 'EastCCWto'");
 end%switch
end%function
