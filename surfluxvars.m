function vars = surfluxvars(sfxnc,field,trange)
 % Extract Flux data from netCDF file
 % vars = surfluxvars(sfxnc,fields,trange)
 % vars.(field(i)) =  field i for field(1) in trange
 % if trange is not given then th whole data record is used
 % if feilds is not given "Yday" is used
 sfx = netcdf(sfxnc,'r');
 if(nargin<1)
  field = ["Yday"];
 end%if
 % get the dimension variable
 tsfx = squeeze(sfx{deblank(field(1,:))}(:));
 if nargin()>2
  sfxtidx = inclusiverange(tsfx,trange);
 else
  sfxtidx = 1:length(tsfx);
 end%if
 for i=1:length(field(:,1))
  vars.(deblank(field(i,:))) = squeeze(sfx{deblank(field(i,:))}(sfxtidx));
 end%for
 ncclose(sfx);
end%function
