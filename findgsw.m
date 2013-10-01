function findgsw
 gswpath = "/home/mhoecker/work/TEOS-10/";
 gswlibpath = "/home/mhoecker/work/TEOS-10/library/";
 if(exitst(gswpath,"dir")!=7)
  addpath(gswpath);
 end%if
 if(exist(gswlibpath,"dir")!=7)
  addpath(gswlibpath);
 end%if
end%function
