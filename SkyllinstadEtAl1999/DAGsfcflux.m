function [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,S0,sigH,HoT,HoS,LaBflx,JhBflx,SaBflx,netp] = DAGsfcflux(dagnc,bcdat,trange)
 % this function replaces surfaceflux in post processing of model runs
 % it pulls values from the dag file instead of from surface observations
 % Get surface values from sea surface teperature and salinity
 field =["time";"zzu";"t_ave";"s_ave"];
 zrange = [0,1];
 flxvars = dagvars(dagnc,field,trange,zrange);
 sst=flxvars.t_ave(:,end);
 SalTSG=flxvars.s_ave(:,end);
 clear flxvars;
 % Get required thermodynamic constants
 findgsw;
 % Acceleration of gravity
 g = gsw_grav(0);
 % Thermal expansion coefficient
 alpha = gsw_alpha(SalTSG,sst,0);
 % Haline contraction coefficient
 beta = gsw_beta(SalTSG,sst,0);
 % Heat Capacity
 Cp = gsw_cp_t_exact(SalTSG,sst,0);
 % Latent Heat
 LH = gsw_latentheat_evap_t(SalTSG,sst);
 % density
 rho = gsw_rho(SalTSG,sst,0);
 % Get surface driving fluxes
 field = ["time";"z";"hf_top";"ustr_t";"vstr_t";"swf_top";"lhf_top";"wave_l";"wave_h";"w_angle" ;"S_0";"L_a"];
 flxvars = dagvars(dagnc,field,trange);
 tsfx=flxvars.time;
 bc = readbcdat(bcdat,tsfx);
 flxvas.rain = bc.rain;
 %ddtsfx = ddz(tsfx);
 stress=flxvars.ustr_t+I*flxvars.vstr_t;
 p=bc.rain;
 Jh=flxvars.hf_top+flxvars.swf_top+flxvars.lhf_top;
 Jh = -Jh;
 SolarNet=flxvars.swf_top;
 wdir=pi/2;
 S0 = flxvars.S_0;
 sigH = flxvars.wave_l;
 %
 e = -flxvars.lhf_top./(rho.*LH);
 netp = p-e;
 LaBflx = flxvars.S_0.*(2*pi./flxvars.wave_l).*abs(stress)./rho;
 JhBflx = alpha.*g.*Jh./(Cp.*rho);
 SaBflx = -beta.*g.*SalTSG.*(e-p*(1e-3)/3600);
 % Calculate Thermal and Saline Honikker #s
 HoT = JhBflx./LaBflx;
 HoS = SaBflx./LaBflx;
end%function
