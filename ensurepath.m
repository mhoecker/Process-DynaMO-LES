function ensurepath(dir)
 if((exist(dir,"dir")==7).*(length(findstr(path,dir))==0))
  addpath(dir);
 end%if
end%function
