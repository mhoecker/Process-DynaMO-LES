function RevelleMet2toNetCDF(inloc,fname,outloc,tmp)
 %
 % This script converts RevelleMetRev2 mat data into
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
 if(nargin<4)
  tmp = "/home/mhoecker/tmp/";
  %tmp = [outloc "tmp"];
 end%if
 matfile = [inloc  fname '.mat'];
 ncfile  = [outloc fname '.nc' ];
 cdffile = [tmp    fname '.cdf'];
 load(matfile);
 cdlid = fopen(cdffile,'w');
 fprintf(cdlid,'netcdf %s {\n', fname);
 vals = {};
 vars = {};
 longname = {};
 units = {};
 instrument = {};
 vartype = {};
 %Yday      Decimal yearday (UTC) To convert to matlab time format use:
 % yd0=datenum(datestr('01-Jan-2011 00:00:00'))-1;
 % tmatlab=yday+yd0;
 i=1;
 vars{i} = "Yday";
 units{i} = "days";
 longname{i} = "2011 year day (UTC)";
 vartype{i} = 'double';
 instrument{i} =  '';
 vals{i} = yday;
 clear yday;
 i = i+1;
 %Lat       Latitude (deg)
 vars{i} = "Lat";
 units{i} = "degrees";
 longname{i} = "Latitude";
 vartype{i} = 'double';
 instrument{i} =  '';
 vals{i} = Lat;
 clear Lat;
 i = i+1;
 %Lon       Longitude (deg)
 vars{i} = "Lon";
 units{i} = "degrees";
 longname{i} = "Longitude";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Lon;
 clear Lon;
 i = i+1;
 %SOG       Speed over ground (m/s)
 vars{i} = "SOG";
 units{i} = "meters/second";
 longname{i} = "Speed over ground";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = SOG;
 clear SOG;
 i = i+1;
 %COG       Course over ground (deg)
 vars{i} = "COG";
 units{i} = "degrees from True North";
 longname{i} = "Course over ground";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = COG;
 clear COG;
 i = i+1;
 %Heading   Ship's heading (deg)
 vars{i} = "Heading";
 units{i} = "degrees from True North";
 longname{i} = "Ship's heading";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Heading;
 clear Heading;
 i = i+1;
 %Cspd      Current speed (m/s)
 vars{i} = "Cspd";
 units{i} = "meters/second";
 longname{i} = "Current speed";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = cspd;
 clear cspd;
 i = i+1;
 %Cdir      Current direction (deg) from
 vars{i} = "Cdir";
 units{i} = "degrees";
 longname{i} = "Current direction from";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = cdir;
 clear cdir;
 i = i+1;
 %U10       Wind speed (m/s) relative to earth adjusted to 10 m
 vars{i} = "U10";
 units{i} = "meters/second";
 longname{i} = "Wind speed relative to earth adjusted to 10 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = U10;
 clear U10;
 i = i+1;
 %Wdir      Wind direction (deg) from relative to earth
 vars{i} = "Wdir";
 units{i} = "degrees";
 longname{i} = "Wind direction from relative to earth";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = wdir;
 clear wdir;
 i = i+1;
 %Ur10      Wind speed (m/s) relative to water adjusted to 10 m
 vars{i} = "Ur10";
 units{i} = "meters/second";
 longname{i} = "Wind speed relative to water adjusted to 10 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Ur10;
 clear Ur10;
 i = i+1;
 %WdirR     Wind direction (deg) from relative to water
 vars{i} = "WdirR";
 units{i} = "degrees";
 longname{i} = "Wind direction from relative to earth";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = wdirR;
 clear wdirR;
 i = i+1;
 %Pair10    Pressure (mb) adjusted to 10 m
 vars{i} = "Pair10";
 units{i} = "millibar";
 longname{i} = "Pressure adjusted to 10 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Pair10;
 clear Pair10;
 i = i+1;
 %RH10      Relative humidity(%) adjusted to 10 m
 vars{i} = "RH10";
 units{i} = "Percentage";
 longname{i} = "Relative humidity adjusted to 10 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = RH10;
 clear RH10;
 i = i+1;
 %T10       Temperature (C) adjusted to 10 m
 vars{i} = "T10";
 units{i} = "Celsius";
 longname{i} = "Temperature adjusted to 10 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = T10;
 clear T10;
 i = i+1;
 %Tsea      Near surface sea temperature (C) from Sea snake
 vars{i} = "Tsea";
 units{i} = "Celsius";
 longname{i} = "Near surface sea temperature";
 instrument{i} =  "Primarily Sea snake, few values provided by the IR radiometer deployed by LDEO";
 vartype{i} = 'double';
 vals{i} = Tsea;
 clear Tsea;
 i = i+1;
 %SST       Sea surface temperature (C) from Tsea minus cool skin
 vars{i} = "SST";
 units{i} = "Celsius";
 longname{i} = "Sea surface temperature from Tsea minus cool skin";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = SST;
 clear SST;
 i = i+1;
 %Q10       Specific humidity (g/Kg) adjusted to 10 m
 vars{i} = "Q10";
 units{i} = "gram / kilogram";
 longname{i} = "Specific humidity adjusted to 10 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Q10;
 clear Q10;
 i = i+1;
 %Qsea      Specific humidity (g/Kg) 'near' ocean surface from sea snake
 vars{i} = "Qsea";
 units{i} = "gram / kilogram";
 longname{i} = "Specific humidity 'near' ocean surface";
 instrument{i} =  "Sea snake";
 vartype{i} = 'double';
 vals{i} = Qsea;
 clear Qsea;
 i = i+1;
 %SSQ       Sea surface specific humidity (g/Kg) from Qsea minus cool skin
 vars{i} = "SSQ";
 units{i} = "gram / kilogram";
 longname{i} = "Sea surface specific humidity from Qsea minus cool skin";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = SSQ;
 clear SSQ;
 i = i+1;
 %stress    Surface stress (N/m2) measured relative to water
 vars{i} = "stress";
 units{i} = "Newton / meter^2";
 longname{i} = "Surface stress measured relative to water";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = stress;
 clear stress;
 i = i+1;
 %shf       Sensible heat flux (W/m2)
 vars{i} = "shf";
 units{i} = "Watt / meter^2";
 longname{i} = "Sensible heat flux";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = shf;
 clear shf;
 i = i+1;
 %lhf       Latent heat flux (W/m2)
 vars{i} = "lhf";
 units{i} = "Watt / meter^2";
 longname{i} = "Latent heat flux";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = lhf;
 clear lhf;
 i = i+1;
 %rhf       Sensible heat flux from rain (W/m2)
 vars{i} = "rhf";
 units{i} = "Watt / meter^2";
 longname{i} = "Sensible heat flux from rain";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = rhf;
 clear rhf;
 i = i+1;
 %Solarup   Reflected solar (W/m2) estimated from Payne (1972)
 vars{i} = "Solarup";
 units{i} = "Watt / meter^2";
 longname{i} = "Reflected solar estimated from Payne (1972)";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Solarup;
 clear Solarup;
 i = i+1;
 %Solardn   Measured downwelling solar (W/m2)
 vars{i} = "Solardn";
 units{i} = "Watt / meter^2";
 longname{i} = "Measured downwelling solar";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Solardn;
 clear Solardn;
 i = i+1;
 %IRup      Upwelling IR (W/m2) computed from SST
 vars{i} = "IRup";
 units{i} = "Watt / meter^2";
 longname{i} = "Upwelling IR computed from SST";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = IRup;
 clear IRup;
 i = i+1;
 %IRdn      Measured downwelling IR (W/m2)
 vars{i} = "IRdn";
 units{i} = "Watt / meter^2";
 longname{i} = "Measured downwelling IR";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = IRdn;
 clear IRdn;
 i = i+1;
 %E         Evaporation rate (mm/hr)
 vars{i} = "E";
 units{i} = "milimeter / hour";
 longname{i} = "Evaporation rate";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = E;
 clear E;
 i = i+1;
 %P         Precipitation rate (mm/hr)
 vars{i} = "P";
 units{i} = "milimeter / hour";
 longname{i} = "Precipitation rate";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = P;
 clear P;
 i = i+1;
 %Evap      Accumulated evaporation for Leg (mm)
 vars{i} = "Evap";
 units{i} = "milimeter";
 longname{i} = "Accumulated evaporation for Leg";
 vartype{i} = 'double';
 instrument{i} =  '';
 vals{i} = Evap;
 clear Evap;
 i = i+1;
 %Precip    Accumulated precipitation for Leg (mm)
 vars{i} = "Precip";
 units{i} = "milimeter";
 longname{i} = "Accumulated precipitation for Leg";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Precip;
 clear Precip;
 i = i+1;
 %Interped  1= interpolated due to poor relative winds 0=no interpolation
 vars{i} = "Interped";
 units{i} = "N/A";
 longname{i} = "0=no interpolation, 1=interpolated due to poor relative winds";
 instrument{i} =  '';
 vartype{i} = "byte";
 vals{i} = interped;
 clear interped;
 i = i+1;
 %T02       Temperature (C) adjusted to 2 m
 vars{i} = "T02";
 units{i} = "Celsius";
 longname{i} = "Temperature adjusted to 2 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = T02;
 clear T02;
 i = i+1;
 %Q02       Specific humidity (g/Kg) adjusted to 2 m
 vars{i} = "Q02";
 units{i} = "gram / kilogram";
 longname{i} = "Specific humidity adjusted to 2 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = Q02;
 clear Q02;
 i = i+1;
 %RH02      Relative humidity(%) adjusted to 2 m
 vars{i} = "RH02";
 units{i} = "percent";
 longname{i} = "Relative humidity adjusted to 2 m";
 instrument{i} =  '';
 vartype{i} = 'double';
 vals{i} = RH02;
 clear RH02;
 % Declare Dimensions
 fprintf(cdlid,'dimensions:\n %s=%i;\n',vars{1},length(vals{1}));
 % Declare variables with units, long_name and instrument
 fprintf(cdlid,'variables:\n');
 for i=1:length(vars)
  fprintf(cdlid,'%s %s(%s);\n',vartype{i},vars{i},vars{1});
  fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
  fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
  if(length(instrument{i})>1)
   fprintf(cdlid,'%s:instrument = "%s";\n',vars{i},instrument{i});
  end%if
  fprintf(cdlid,'\n');
 end%for
 fprintf(cdlid,':source = "%s";\n',[fname '.txt']);
 fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
 fprintf(cdlid,':Flux_Algorithm = "bulk COARE version 3.0";\n');
 fprintf(cdlid,':Flux_Direction = "negative downward and positive upwards";\n');
 fprintf(cdlid,':Wind-Current_Direction = "meteorological convention (direction from)";\n');
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
