function [dims,vars] = myncread(ncfile,dimnames,varnames,dimranges)
%function [dims,vars] = myncread(ncfile,dimnames,varnames,dimranges)
% Extract a sub set of a netCDF file
%
 if(nargin<1)
  ncfile= '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone6/d1024_1-c_slb.nc';
 end%if

 if(nargin<2)
  dimnames = {'time','zup','yu','xw'};
 end%if

 if(nargin<3)
  varnames = {'t_z'};
 end%if

 if(nargin<4)
  dimranges = {[1,1],[2.5,2.5],[0,1024],[0,1024]};
 end%if

 nc = netcdf(ncfile,'r');

 dims = {};
 idx = {};
 Ndim = length(dimnames);
 for i=1:Ndim
  dims = {dims{:},squeeze(nc{dimnames{i}}(:))};
  idx = {idx{:},inclusiverange(dims{i},dimranges{i})};
  dims{i} = squeeze(nc{dimnames{i}}(idx{i}));
 end%for

 vars = {};
 for i=1:length(varnames)
  if(Ndim==1)
   vars = {vars{:},squeeze(nc{varnames{i}}(idx{1}))};
  elseif(Ndim==2)
   vars = {vars{:},squeeze(nc{varnames{i}}(idx{1},idx{2}))};
  elseif(Ndim==3)
   vars = {vars{:},squeeze(nc{varnames{i}}(idx{1},idx{2},idx{3}))};
  elseif(Ndim==4)
   vars = {vars{:},squeeze(nc{varnames{i}}(idx{1},idx{2},idx{3},idx{4}))};
  elseif(Ndim==5)
   vars = {vars{:},squeeze(nc{varnames{i}}(idx{1},idx{2},idx{3},idx{4},idx{5}))};
  end%if
 end%for
 ncclose(nc);

end%function
