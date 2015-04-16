function [flxout,TSout,UVout] = ICBCnc2ascii(ICBCfile,outloc)
 % initialize a run of the LES code using surface fluxes,
 % tempreature, salinity and ADCP profiles
 %
 % flxfile is a netCDF version of the Core 3 algorithm output
 % TSfile is a netCDF version of Chameleon data
 % adcpfile is a netCDF version of merged ADCP data
 % wantdates is a date range in matlab time format
 % outloc is the location for the output files
 if nargin()<1
  ICBCfile = "/home/mhoecker/tmp/ICBC.nc";
 end%if
 if nargin()<2
  outloc = "/home/mhoecker/tmp/";
  #outloc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/nextrun/";
 end%if
 flxout = LESsurfBC(ICBCfile,outloc);
 TSout = LESinitialTS(ICBCfile,outloc);
end%function

function BCnc2ascii(ICBCfile,outloc)
 outname = [outloc "Surface_Flux_" int2str(floor(min(t))) "-" int2str(ceil(max(t)))];
 fileout = [outname ".bc"];
 outid = fopen(fileout,"w");
 fprintf(outid,'SourceFile=%s\n',ICBCfile);
 fprintf(outid,' \n');
 fprintf(outid,' swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle\n');
 for i=1:length(nc{"t"}(:));
  fprintf(outid,'%f ',nc{"t"}(i)/3600);
  fprintf(outid,'%f ',nc{"J_sw"}(i);
  fprintf(outid,'%f ',nc{"J_se"}(i);
  fprintf(outid,'%f ',nc{"J_la"}(i);
  fprintf(outid,'%f ',nc{"P"}(i);
  fprintf(outid,'%f ',nc{"tau_x"}(i);
  fprintf(outid,'%f ',nc{"tau_y"}(i);
  fprintf(outid,'%f ',nc{"W_l"}(i);
  fprintf(outid,'%f ',nc{"W_h"}(i);
  fprintf(outid,'%f ',nc{"W_d"}(i);
  fprintf(outid,'\n');
 end%for
