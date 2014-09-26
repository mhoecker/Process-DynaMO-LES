function [flxout,TSout,UVout] = LESBCandIC(flxfile,TSfile,adcpfile,wantdates,maxdepth,avgtime,order,outloc,adcpvarnames)
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
  TSfile = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/Chameleon/dn11b_sum_clean_v2.nc";
 end%if
 if nargin()<3
  adcpfile = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140.nc";
  adcpvarnames = ["t";"z";"u";"v"];
  %adcpfile = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140_filtered_1hr_3day.nc";
  %adcpvarnames = ["t";"z";"ulp";"vlp"];
 end%if
 if nargin()<4
  % 2011 Year day 328-330
  wantdates = [datenum(2011,0,328),datenum(2011,0,330)];
 end%if
 if nargin()<5
  maxdepth = 80;
 end%if
 if nargin()<6
  avgtime = 0.25/24;
 end%if
 if nargin()<7
  order = 5;
 end%if
 if nargin()<8
  outloc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/nextrun/";
 end%if
 if nargin()<9
  wavespecHL = "/home/mhoecker/work/Dynamo/output/surfspectra/wavespectraHSL.mat";
 end%if
 yeardates = wantdates-datenum(2010,12,31)
 flxout = LESsurfBC(flxfile,yeardates,outloc,avgtime,wavespecHL)
 figure(5)
 TSout = LESinitialTS(TSfile,min(yeardates),outloc,avgtime,maxdepth);
 figure(6)
 if(length(adcpvarnames)>0)
  UVout = uvincfile(adcpfile,min(yeardates),maxdepth,outloc,avgtime,order,adcpvarnames);
 else
  UVout = uvincfile(adcpfile,min(yeardates),maxdepth,outloc,avgtime,order);
end%function
