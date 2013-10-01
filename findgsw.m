function findgsw
 gswpath = "/home/mhoecker/work/TEOS-10/";
 gswlibpath = "/home/mhoecker/work/TEOS-10/library/";
 if((exist(gswpath,"dir")==7).*(length(findstr(path,gswpath))==0))
  addpath(gswpath);
 end%if
 if((exist(gswlibpath,"dir")==7).*(length(findstr(path,gswlibpath))==0))
  addpath(gswlibpath);
 end%if
end%function
