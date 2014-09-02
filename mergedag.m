function [t,idxs] = mergedag(daglist,dagdir)
 if(nargin()<1)
  daglist = {'a','b','c','d','e','f','g','h'};
 end%if
 if(nargin()<2)
  dagdir = '/home/mhoecker/work/Dynamo/output/yellowstone8/dyn1024-';
 end%if
 dagfile = [dagdir daglist{1} '_dag.nc'];
 dag = netcdf(dagfile,'r');
 t = squeeze(dag{'time'}(:));
 idxs = [1,length(t)-1];
 ncclose(dag);
 cliplist = {dagfile};
 for i=2:length(daglist)
  dagfile = [dagdir daglist{i} '_dag.nc'];
  dag = netcdf(dagfile,'r');
  ti = squeeze(dag{'time'}(:));
  ncclose(dag);
  idxi= [find(ti>max(t),1),length(ti)-1];
  clipfile =  [dagdir daglist{i} '_dagclip.nc'];
  ncoclip(dagfile,'time',idxi,clipfile)
  cliplist = {cliplist{:},clipfile};
  t = [t;ti(idxi(1):end)];
  idxs = [idxs;idxi];
 end%for
 outfile = [dagdir 'dag.nc'];
 ncorcat(cliplist,outfile);
end%function

function ncoclip(infile,dimname,index,outfile)
 ncksargs = [' -O -d ' dimname ',' num2str(index(1),"%i") ',' num2str(index(2),"%i") ' ' infile ' ' outfile];
 unix( ['ncks' ncksargs])
end%function

function ncorcat(infiles,outfile)
  files = '';
 for(i=1:length(infiles))
  files = [files infiles{i} ' '];
 end%for
 ncrcatargs = ['-O ' files ' ' outfile];
 unix( ['ncrcat ' ncrcatargs])
end%function
