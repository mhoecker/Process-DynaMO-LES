function [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,cp,sigH,HoT,HoS,LaBflx,JhBflx,SaBflx] = DAGsfcflux(dagnc,trange)
 % this function replaces surfaceflux in post processing of model runs
 % it pulls values from the dag file instead of from surface observations
 % Get surface values from sea surface teperature and salinity
 field =["time";"zzu";"t_ave";"s_ave"];
 zrange = [0,1];
 flxvars = dagvars(dagnc,field,trange,zrange);
 sst=flxvars.t_ave(:,1);
 SalTSG=flxvars.s_ave(:,1);
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
 field = ["time";"z";"q";"rain";"hf_top";"ustr_t";"vstr_t";"swf_top";"lhf_top";"wave_l";"wave_h";"w_angle" ;"S_0";"L_a"];
 flxvars = dagvars(dagnc,field,trange);
 tsfx=flxvars.time;
 %ddtsfx = ddz(tsfx);
 stress=flxvars.ustr_t+I*flxvars.vstr_t;
 p=10*flxvars.rain./mode(diff(tsfx));
 Jh=flxvars.hf_top+flxvars.swf_top+flxvars.lhf_top;
 SolarNet=flxvars.swf_top;
 wdir=pi/2;
 cp = flxvars.S_0;
 sigH = flxvars.wave_l;
 %
 e = -flxvars.lhf_top./(rho.*LH);
 LaBflx = flxvars.S_0.*(2*pi./flxvars.wave_l).*stress./rho;
 JhBflx = alpha.*g.*Jh./(Cp.*rho);
 SaBflx = -beta.*g.*SalTSG.*(e+p.*0.001/3600);
 % Calculate Thermal and Saline Honikker #s
 HoT = JhBflx./LaBflx;
 HoS = SaBflx./LaBflx;
end%function
