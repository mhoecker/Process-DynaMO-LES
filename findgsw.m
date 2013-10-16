function [version_number,version_date] = findgsw
 % Ensure Gibbs sea water is in the path,
 % return the version number and date
 gswpath = "/home/mhoecker/work/TEOS-10/";
 gswlibpath = "/home/mhoecker/work/TEOS-10/library/";
 if((exist(gswpath,"dir")==7).*(length(findstr(path,gswpath))==0))
  addpath(gswpath);
 end%if
 if((exist(gswlibpath,"dir")==7).*(length(findstr(path,gswlibpath))==0))
  addpath(gswlibpath);
 end%if
 gsw_data = 'gsw_data_v3_0.mat';
 gsw_data_file = which(gsw_data);
 load(gsw_data_file,'version_number','version_date');
end%function
