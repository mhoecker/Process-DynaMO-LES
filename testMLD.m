%TEST MLD
chamfile = '/home/mhoecker/work/Dynamo/Observations/netCDF/Chameleon/dn11b_sum_clean_v2.nc'
dagfile = '/home/mhoecker/work/Dynamo/output/yellowstone14/dag.nc';
trange = [328.25,328.75];
zrange = [-50,0];
%
nc = netcdf(chamfile,'r');
%
t = nc{'t'}(:);
tidx = inclusiverange(t,trange);
t = nc{'t'}(tidx);
%
z = nc{'z'}(:);
zidx = inclusiverange(z,zrange);
z = nc{'z'}(zidx);
%
T = nc{'T'}(tidx,zidx);
S = nc{'S'}(tidx,zidx);
ncclose(nc)
[tt,zz] = meshgrid(t,z);
[MLD1,MLI,drho,rho,DRHO]=getMLD(S,T,z);
%
figure(1)
pcolor(tt,zz,drho'); shading flat; axis([trange,zrange]); caxis([0,DRHO]);colorbar
hold on
plot(t,MLD1)
hold off
%
dagfile = '/home/mhoecker/work/Dynamo/output/yellowstone14/dag.nc';
%
nc = netcdf(dagfile,'r');
%
t2 = 328+nc{'time'}(:)/(24*3600);
tidx = inclusiverange(t2,trange);
t2 = 328+nc{'time'}(tidx)/(24*3600);
%
z2 = -nc{'zzu'}(:);
zidx = inclusiverange(z2,zrange);
z2 = -nc{'zzu'}(zidx);
%
T = squeeze(nc{'t_ave'}(tidx,zidx,1,1));
S = squeeze(nc{'s_ave'}(tidx,zidx,1,1));
%
%T = nc{'t_ave'}(tidx,zidx);
%S = nc{'s_ave'}(tidx,zidx);
ncclose(nc)
%
[tt2,zz2] = meshgrid(t2,z2);
[MLD2,MLI,drho2,rho,DRHO]=getMLD(S,T,z2);
%
figure(2)
pcolor(tt2,zz2,drho2'); shading flat; axis([trange,zrange]); caxis([0,DRHO]);colorbar
hold on
plot(t2,MLD2)
hold off
figure(3)
plot(t,MLD1,t2,MLD2)
