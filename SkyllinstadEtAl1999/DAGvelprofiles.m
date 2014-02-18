function [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,trange,zrange)
 % Extract diagnostic profiles
 dag      = netcdf(dagnc,'r');
 tdag     = squeeze(dag{'time'}(:));
 if nargin()>1
  dagtidx = inclusiverange(tdag,trange);
 else
  dagtidx = 1:length(tdag);
 end%if
 % restict depth range
 zdag     = -squeeze(dag{'zzu'}(:));
 if nargin()>2
  dagzidx = inclusiverange(zdag,zrange);
 else
  dagzidx = 1:length(zdag);
 end%if
 tdag     = squeeze(dag{'time'}(dagtidx));
 zdag     = -squeeze(dag{'zzu'}(dagzidx));
 uavgdag  = squeeze(dag{'u_ave'}(dagtidx,dagzidx,1,1));
 vavgdag  = squeeze(dag{'v_ave'}(dagtidx,dagzidx,1,1));
 ncclose(dag);
end%function


