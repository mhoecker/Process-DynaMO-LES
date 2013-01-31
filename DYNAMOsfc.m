function [t_sfc0,SST,tauM,tau,precip_sfc,evap_sfc,h20f_sfc,hflx_sfc,hf_lat] = DYNAMOsfc()
    % Read dynamo data
    % t_sfc0 = year day 2011 *24*3600 [s]
    % tau = Wind stress magnitude [N/m^2]
    % dir = Wind direction (wind is FROM this direction, measured clockwise from North)
    % hflx_sfc = net surface heat flux [W/m2]
    % precip_sfc =  precipitation [m/s]
    % evap_sfc = % evaporation 
    %
    % All fluxes are positive upward !!!!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    X      = load('input/DYNAMO_2011_Leg3_PSD_flux_5min_all.txt');
    t_sfc0 = fillgap(X(:,1),1)*24*3600;
    SST    = fillgap(X(:,4),1)+273.15; % sea snake temperature [Kelvin]
    tauM   = fillgap(X(:,21),1); % Wind stress magnitude [N/m^2]
    dir    = fillgap(X(:,3)); % Wind direction (wind is FROM this direction, measured clockwise from North)
    tau    = fillgap(-tauM.*(sin(dir*pi/180)-I*cos(dir*pi/180)),1); % Complex plane wind stress Real->West Imag->North
    %ustar2_sfc =-tauM.*sin(pi*dir./180)/1030; % squared zonal friction velocity [m2/s2]
    %vstar2_sfc =-tauM.*cos(pi*dir./180)/1030; % squared meridional friction velocity [m2/s2]
    swrd_sfc=-fillgap(X(:,10),1)*1.01; % SW radiative heat flux [W/m2] downward = negative
    hf_sen=fillgap(X(:,22),1); %sensible [W/m2]
    hf_lat=fillgap(X(:,23),1); %latent [W/m2]
    hf_pre=fillgap(X(:,24),1); %rain [W/m2]
    sigma = 5.7e-8; % Stefan-Boltzman, [W/m2/K4]
    Le = 2.56e9; % Effective latent heat [J/Mg]
    hf_lw_up= .97*sigma*SST.^4;
    hf_lw_dn=fillgap(X(:,11),1);
    hflx_sfc=swrd_sfc+hf_lw_up -hf_lw_dn +hf_sen+hf_lat+hf_pre;  % net surface heat flux [W/m2] downward = negative
    evap_sfc = hf_lat./Le; % evaporation latent heat of water = 2.56e9 J/m^3
    precip_sfc=fillgap(X(:,12),1)/3600/1000;  % precipitation [m/s]
    h20f_sfc = precip_sfc-evap_sfc; % Net fresh water flux [m/s]
end
