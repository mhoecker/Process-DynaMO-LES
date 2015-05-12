function vars = bcvars(bcnc,field,trange)
 %
 %
 %
 %
 %
 %
 bc = netcdf(bcnc,'r');
 if(nargin<2)
  field = ["time"];
 end%if
 % get and restrict the time variable
 dim = squeeze(bc{deblank(field(1,:))}(:));
 if nargin()>2
  tidx = inclusiverange(dim,trange);
 else
  tidx = 1:length(dim);
 end%if
 vars.(deblank(field(1,:))) = squeeze(bc{deblank(field(1,:))}(tidx));
 % get and restict depth range
 Nt = length(tidx)
 for i=2:length(field(:,1))
  fieldname = deblank(field(i,:));
  % if the variable is defined, return it
  % othersie return a Nt array of NaN
  try
   vars.(fieldname) = squeeze(bc{fieldname}(tidx,1,1,1));
  catch
   vars.(fieldname) = NaN*ones(Nt);
  end%trycatch
 end%for
 ncclose(bc);
end%function
