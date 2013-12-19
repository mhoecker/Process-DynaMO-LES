function [t,z,u,v] = ADCPprofiles(adcpnc,trange,zrange,vars)
 % Extract ADCP profiles
 if(nargin()<4)
  vars = ['t';'z';'u';'v'];
 end%if
 adcp = netcdf(adcpnc,'r');
 t = squeeze(adcp{vars(1,:)}(:));
 z = squeeze(adcp{vars(2,:)}(:));
 if nargin()>1
  adcptidx = inclusiverange(t,trange);
 else
  adcptidx = 1:length(tadcp);
 end%if
 % restict depth range
 zadcp = squeeze(adcp{vars(2,:)}(:));
 if nargin()>2
  adcpzidx = inclusiverange(z,zrange);
 else
  adcpzidx = 1:length(z);
 end%if
 t = squeeze(adcp{vars(1,:)}(adcptidx));
 z = squeeze(adcp{vars(2,:)}(adcpzidx));
 u = squeeze(adcp{vars(3,:)}(adcptidx,adcpzidx));
 v = squeeze(adcp{vars(4,:)}(adcptidx,adcpzidx));
 ncclose(adcp);
end%function
