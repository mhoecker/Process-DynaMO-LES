function [flxout,TSout,UVout] = LESBCandIC(flxfile,chamRamafile,wantdates,outloc,avgtime)
 % initialize a run of the LES code using surface fluxes,
 % tempreature, salinity and ADCP profiles
 %
 % flxfile is a netCDF version of the Core 3 algorithm output
 % TSfile is a netCDF version of Chameleon data
 % adcpfile is a netCDF version of merged ADCP data
 % wantdates is a date range in matlab time format
 % outloc is the location for the output files
 if nargin()<1
  flxfile = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc";
 end%if
 if nargin()<2
  chamRAMAfile = "/home/mhoecker/work/Dynamo/Observations/netCDF/chamRAMA/isoPZchamAndRAMA.nc"
 end%if
 if nargin()<3
  % 2011 Year day 328-330
  wantdates = [datenum(2011,0,328),datenum(2011,0,330)];
 end%if
 if nargin()<4
  outloc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/nextrun/";
 end%if
 if nargin()<5
  avgtime = 1.0/24;
 end%if
 yeardates = wantdates-datenum(2010,12,31);
 flxout = LESsurfBC(flxfile,yeardates,outloc,avgtime);
 avgcenter = num2str(min(yeardates)-2.5,"%5.1f");
 ncwacall = ["ncwa -v U,V,SA,CT -O -a t -d t," avgcenter "," avgcenter " "];
 UVoutnc = [outloc "UVinit.nc"];
 unix([ncwacall chamRAMAfile " -o" UVoutnc]);
 TSout = LESinitialTS(UVoutnc,outloc);
end%function
