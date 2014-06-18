function vars = dagvars(dagnc,field,trange,zrange)
 % Extract data from dag netCDF file
 % vars = dagvars(sfxnc,fields,trange)
 % vars.(field(i)) =  field i for field(1:2) in trange:zrange
 % if trange:zrange is not given the whole data record is used
 % if feilds is not given "time";"zzu" are used
 dag = netcdf(dagnc,'r');
 if(nargin<2)
  field = ["time";"zzu"];
 end%if
 % get and restrict the time variable
 dim = squeeze(dag{deblank(field(1,:))}(:));
 if nargin()>2
  dagtidx = inclusiverange(dim,trange);
 else
  dagtidx = 1:length(dim);
 end%if
 deblank(field(1,:))
 vars.(deblank(field(1,:))) = squeeze(dag{deblank(field(1,:))}(dagtidx));
 % get and restict depth range
 dim = -squeeze(dag{deblank(field(2,:))}(:));
 if nargin()>3
  dagzidx = inclusiverange(dim,zrange);
 else
  dagzidx = 1:length(dim);
 end%if
 vars.(deblank(field(2,:))) = squeeze(dag{deblank(field(2,:))}(dagzidx));
 % get the values of the desired variables
 for i=3:length(field(:,1))
  fieldname = deblank(field(i,:));
  vars.(fieldname) = squeeze(dag{fieldname}(dagtidx,dagzidx,1,1));
 end%for
 ncclose(dag);
end%function
