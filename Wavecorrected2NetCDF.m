function [h,t]=Wavecorrected2NetCDF(inloc,fname,outloc)
%%
%% This script converts the raw 4 columns of acii data into
%% a CDl ascii file which it then uses `ncgen` to  convert the
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
txtfile = [inloc fname,'.prn'];
ncfile = [outloc fname '.nc'];
tmp = "/home/mhoecker/tmp/";
cdffile = [tmp fname '.cdf'];
#
X = load(txtfile);
Ns = size(X);
t = X(:,1)+X(:,2)/24+X(:,3)/(24*60*60);
h = X(:,4);
clear X;
N = Ns(1);
M = 2;
#
cdlid = fopen(cdffile,'w');
fprintf(cdlid,'netcdf %s {\n', fname);
#
vars = {};
longname = {};
units = {};
instrument = {};
for i=1:2;
 vars = {vars{:},['var' num2str(i)]};
 units = {units{:},'TBD'};
 longname = {longname{:},''};
 instrument = {instrument{:},''};
endfor
vars{1} = "t";
units{1} = "day";
longname{1} = "2011 year day";
#
vars{2} = "h";
units{2} = "meter";
longname{2} = "wave height";
instrument{2} = "REIGL LASER Altimeter";
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
fprintf(cdlid,':REIGL_Height = "17.5 meters";\n');
# Declare Data
fprintf(cdlid,'data:\n')
X = [t,h];
for i=1:M
 y = X(:,i);
 fprintf(cdlid,'%s =\n',vars{i});
 for j=1:N
  if(isnan(y(j))==1)
   fprintf(cdlid,'NaN');
  else
   fprintf(cdlid,'%20.20g',y(j));
  endif
  if(j<N)
   fprintf(cdlid,', ');
  else
   fprintf(cdlid,';\n');
  endif
 endfor
endfor
fprintf(cdlid,'}\n', fname);
fclose(cdlid);
unix(['ncgen -o ' ncfile ' ' cdffile ' && rm ' cdffile]);

