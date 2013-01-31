function [t_sfc0 swrd_sfc ustar2_sfc vstar2_sfc hflx_sfc precip_sfc] = read_surface(iprofs)
if iprofs==1
    % read COARE surface fluxes
    X=load('../../input/coare_met_10min_jun95.dat');
    %     X=load('../input/coare_met_v2_1hr_patch.dat');
    t_sfc0=X(:,1)  *24*3600;
    swrd_sfc=-X(:,2); % SW radiative heat flux [W/m2] downward = negative
    ustar2_sfc=X(:,8)/1030; % squared zonal friction velocity [m2/s2]
    vstar2_sfc=X(:,9)/1030; % squared meridional friction velocity [m2/s2]
    hflx_sfc=X(:,13);  % net surface heat flux [W/m2] downward = negative
    precip_sfc=X(:,11)/3.6e6-X(:,5)/2.56e9;-X(:,12)/3.6e6; % P-E [m/s]
elseif iprofs==2
    % Read dynamo data
    % t_sfc0 = year day 2011 *24*3600 [s]
    % swrd_sfc  = SW radiative heat flux [W/m2]
    % ustar2_sfc = squared zonal friction velocity [m2/s2]
    % vstar2_sfc = Wind direction (wind is FROM this direction, measured clockwise from North)
    % hflx_sfc = net surface heat flux [W/m2]
    % precip_sfc = % P-E [m/s]
    %
    % All fluxes are positive upward !!!!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    X=load('input/DYNAMO_2011_Leg3_PSD_flux_5min_all.txt');
    t_sfc0=fillgap(X(:,1))*24*3600;
    swrd_sfc=-fillgap(X(:,10))*1.01; % SW radiative heat flux [W/m2] downward = negative
    tau=fillgap(X(:,21)); % Wind stress magnitude [N/m^2]
    dir=fillgap(X(:,3)); % Wind direction (wind is FROM this direction, measured clockwise from North)
    ustar2_sfc =-tau.*sin(pi*dir./180)/1030; % squared zonal friction velocity [m2/s2]
    vstar2_sfc =-tau.*cos(pi*dir./180)/1030; % squared meridional friction velocity [m2/s2]
    precip_sfc=fillgap(X(:,12))/3600/1000-fillgap(X(:,23))/2.56e9;  % P-E [m/s]
    hf_sen=fillgap(X(:,22)); %sensible [W/m2]
    hf_lat=fillgap(X(:,23)); %latent [W/m2]
    hf_pre=fillgap(X(:,24)); %rain [W/m2]
    sigma = 5.7e-8; % Stefan-Boltzman, [W/m2/K4]
    SST = fillgap(X(:,4))+273.15; % sea snake temperature [Kelvin]
    hf_lw_up= .97*sigma*SST.^4;
    hf_lw_dn=fillgap(X(:,11));
    hflx_sfc=swrd_sfc+hf_lw_up -hf_lw_dn +hf_sen+hf_lat+hf_pre;  % net surface heat flux [W/m2] downward = negative
end