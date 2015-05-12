function [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,trange,zrange)
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
 Tavgdag  = squeeze(dag{'t_ave'}(dagtidx,dagzidx,1,1));
 Savgdag  = squeeze(dag{'s_ave'}(dagtidx,dagzidx,1,1));
end%function
