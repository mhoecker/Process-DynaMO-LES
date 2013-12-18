function [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange)
% function [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange)
 % Extract profile data from Chameleon
 chm = netcdf(chmnc,'r');
 % Restrict time index
 tchm = squeeze(chm{'t'}(:));
 if nargin()>1
  chmtidx = inclusiverange(tchm,trange);
 else
  chmtidx = 1:length(tchm);
 end%if
 % restict depth range
 zchm = squeeze(chm{'z'}(:));
 if nargin()>2
  chmzidx = inclusiverange(zchm,zrange);
 else
  chmzidx = 1:length(zchm);
 end%if
 % Extract desired data
 tchm   = squeeze(chm{'t'}(chmtidx));
 zchm   = squeeze(chm{'z'}(chmzidx));
 epschm = squeeze(chm{'epsilon'}(chmtidx,chmzidx));
 Tchm   = squeeze(chm{'T'}(chmtidx,chmzidx));
 Schm   = squeeze(chm{'S'}(chmtidx,chmzidx));
 ncclose(chm);
end%function
