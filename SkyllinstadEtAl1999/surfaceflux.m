function [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,cp,sigH,HoT,HoS,LaBflx,JhBflx,SaBflx] = surfaceflux(sfxnc,trange)
 % Extract Flux data
 field = ["Yday";"stress";"P";"Wdir";"SST";"SalTSG";"cp";"sigH"];
 field = [field;"shf";"lhf";"rhf";"Solarup";"Solardn";"IRup";"IRdn"];
 % Some other things to extract
 % "Precip";
 sfx = surfluxvars(sfxnc,field,trange);
 tsfx = sfx.Yday;
 stress = sfx.stress;
 p = sfx.P;
 Jh = sfx.shf+sfx.lhf+sfx.rhf+sfx.Solarup+sfx.Solardn+sfx.IRup+sfx.IRdn;
 wdir = sfx.Wdir;
 sst = sfx.SST;
 SalTSG = sfx.SalTSG;
 SolarNet = sfx.Solarup+sfx.Solardn;
 cp = sfx.cp;
 sigH = sfx.sigH;
 # Honikker numbers
 # Requires some thermodynamic constants
 findgsw;
 # Acceleration of gravity
 g = gsw_grav(0);
 # Thermal expansion coefficient
 alpha = gsw_alpha(SalTSG,sst,0);
 # Haline contraction coefficient
 beta = gsw_beta(SalTSG,sst,0);
 # Heat Capacity
 Cp = gsw_cp_t_exact(SalTSG,sst,0);
 # Latent Heat
 LH = gsw_latentheat_evap_t(SalTSG,sst);
 # density
 rho = gsw_rho(SalTSG,sst,0);
 # Convert Cp into omega and k
 k = g./cp.^2;
 omega = sqrt(g.*k);
 # Calculate Stokes drift velocity
 St = omega.*k.*(sigH.^2);
 # Calculate u*
 ustarsq = stress./rho;
 # Calculate evaporation rate
 e = -sfx.lhf./(rho.*LH);
 # Calculate buoyancy flux scales
 LaBflx = St.*k.*stress./rho;
 JhBflx = alpha.*g.*Jh./(Cp.*rho);
 SaBflx = -beta.*g.*SalTSG.*(e+p.*0.001/3600);
 # Calculate Thermal and Saline Honikker #s
 HoT = JhBflx./LaBflx;
 HoS = SaBflx./LaBflx;

end%function
