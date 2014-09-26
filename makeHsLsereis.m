function makeHsLsereis(directory)
 if(nargin==0)
  directory = "/home/mhoecker/work/Dynamo/output/surfspectra/"
 end%if
 freq = [];
 Pow = [];
 t = [];
 files = dir([directory "*.mat"]);
 for file=files'
  file.name
  load(file.name,"f","Px","tin")
 end%for
end%function
