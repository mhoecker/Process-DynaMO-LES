function mergedag(daglist,dagout)
 dag = netcdf(daglist{1},'r');
 t = squeeze(dag{'time'}(:));
 idxs = [1,length(t)];
 for i=2:length(daglist)
  dag = netcdf(daglist{i},'r');
  t1 = squeeze(dag{'time'}(:));
  idxs = [idxs;find(t1>max(t),1),lengtht1];
 end%for
