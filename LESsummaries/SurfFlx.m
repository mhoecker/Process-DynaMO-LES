function vals = SurfFlx(dagnc,bcnc,trange)
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
 field = ["time";"z";"hf_top";"ustr_t";"vstr_t";"swf_top";"lhf_top";"wave_l";"wave_h";"w_angle";"S_0";"L_a";"rain";"u_star"];
 flxvars = dagvars(dagnc,field,trange);
 vals.t     = flxvars.time;
 vals.u_star   = flxvars.u_star;
 vals.u_str    = flxvars.ustr_t;
 vals.v_str    = flxvars.vstr_t;
 vals.stress   = sqrt(vals.u_str.^2+vals.v_str.^2);
 vals.rain     = flxvars.rain;
 vals.Jh       = flxvars.hf_top+flxvars.swf_top+flxvars.lhf_top;
 vals.Jh       = -vals.Jh;
 vals.SolarNet = flxvars.swf_top;
 vals.S_0      = flxvars.S_0;
 vals.sigH     = flxvars.wave_h;
 vals.e        = -flxvars.lhf_top./(rho.*LH);
 vals.netp     = flxvars.rain-e;
 vals.LaBflx   = vals.S_0.*(4*pi./flxvars.wave_l).*vals.stress./rho;
 vals.JhBflx   = alpha.*g.*vals.Jh./(Cp.*rho);
 vals.SaBflx   = beta.*g.*SalTSG.*(-vals.netp*(1e-3)/3600);
 vals.HoT      = 4*vals.JhBflx./vals.LaBflx;
 vals.HoS      = 4*vals.SaBflx./vals.LaBflx;
 vals.Ho       = vals.HoT+vals.HoS;
 vals.La_t     = vals.u_star./vals.S_0;

end%function
