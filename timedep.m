function [swrd ustar2 vstar2 hflx precip r1 r2 amu1 amu2] = timedep(t,dt,t_sfc,hflx_sfc,ustar2_sfc,vstar2_sfc,swrd_sfc,precip_sfc,t_r,r1_r,r2_r,amu1_r,amu2_r);
% USAGE: [swrd ustar2 vstar2 hflx precip r1 r2 amu1 amu2] = timedep(t,dt,t_sfc,hflx_sfc,ustar2_sfc,vstar2_sfc,swrd_sfc,precip_sfc,t_r,r1_r,r2_r,amu1_r,amu2_r);
% Interpolate to compute surface fluxes and transmission coefficients at arbitrary time
%

tp=t+.5*dt;

if tp<t_sfc(1)
    hflx=hflx_sfc(1);
    ustar2=ustar2_sfc(1);vstar2=vstar2_sfc(1);
    precip=precip_sfc(1);swrd=swrd_sfc(1);
elseif tp>t_sfc(end)
    hflx=hflx_sfc(end);
    ustar2=ustar2_sfc(end);vstar2=vstar2_sfc(end);
    precip=precip_sfc(end);swrd=swrd_sfc(end);
else
    hflx=spline(t_sfc,hflx_sfc,tp);
    ustar2=spline(t_sfc,ustar2_sfc,tp);
    vstar2=spline(t_sfc,vstar2_sfc,tp);
    precip=spline(t_sfc,precip_sfc,tp);
    swrd=spline(t_sfc,swrd_sfc,tp);
end

if tp<t_r(1)
    r1=r1_r(1);r2=r2_r(1);amu1=amu1_r(1);;amu2=amu2_r(1);
elseif tp>t_r(end)
    r1=r1_r(end);r2=r2_r(end);amu1=amu1_r(end);amu2=amu2_r(end);
else
    r1=spline(t_r,r1_r,tp);
    r2=spline(t_r,r2_r,tp);
    amu1=spline(t_r,amu1_r,tp);
    amu2=spline(t_r,amu2_r,tp);
end
return