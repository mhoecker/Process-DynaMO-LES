function [U_o V_o T_o S_o E_o U_obs V_obs T_obs S_obs t_cham t_adcp z_T z_S z_U z_V] = initialize_profiles(tstart,tend,z,iprofs);
% inputs: tstart, z, iprofs
% outputs: T_o,S_o,U_o,V_o, E_o


%% obtain data
if iprofs==1
    % read COARE 1-hr profile data
    z_T=-4*[1:63]+2;
    z_U=z_T;z_V=z_T;z_S=z_T;z_E=z_T;
    % read temp
    X=load('..\..\input\temp_1hr_4m.asc');X(X==999.)=nan;
    time=X(:,1);
    ipk=time>=tstart & time<=tend; 
    T_obs=X(ipk,2:end);
    % read sali
    X=load('..\..\input\sali_1hr_4m.asc');X(X==999.)=nan;
    S_obs=X(ipk,2:end);
    % read uimt
    X=load('..\..\input\uimt_1hr_4m.asc');X(X==999.)=nan;
    U_obs=X(ipk,2:end);
    % read vimt
    X=load('..\..\input\vimt_1hr_4m.asc');X(X==999.)=nan;
    V_obs=X(ipk,2:end);
    % read epsi
    X=load('..\..\input\epsi_1hr_4m.asc');X(X==999.)=nan;
    E_obs=X(ipk,2:end);
    t_cham=time(ipk);
    t_adcp=time(ipk);
    clear X
    
    % pick the first profile after t=tstart
    it=sum(time<tstart)+1;
    T_in=T_obs(1,:);
    S_in=S_obs(1,:);
    U_in=U_obs(1,:);
    V_in=V_obs(1,:);
    E_in=E_obs(1,:);
    time_in=time(ipk(1));
    
elseif iprofs==2
    
    load('input/adcp150_1m');    % specify input file for velocities
    adcp150av=adcp;
    z_U=-adcp150av.depth;z_V=z_U;
    
    % pick the first profile after t=tstart
    time=adcp150av.time-datenum(2011,1,1,0,0,0)+1;
    ipk=time>=tstart & time<=tend; 
    t_adcp=time(ipk);
    
    U_obs=adcp150av.u(:,ipk);
    U_in=U_obs(:,1);
    V_obs=adcp150av.v(:,ipk);
    V_in=V_obs(:,1);
    time_in=tstart;
    U_obs=U_obs';V_obs=V_obs';
    
    load('input/dn11b_sum2'); % specify input file for temperature and salinity (and epsilon)
%     it=sum(cham.time-datenum(2011,1,1,0,0,0)<tstart)+1;
    time=cham.time-datenum(2011,1,1,0,0,0)+1;
    ipk=time>=tstart & time<=tend; 
    t_cham=time(ipk);
    
    z_T=-cham.depth;z_S=z_T;z_E=z_T;
    T_obs=cham.THETA(:,ipk);T_obs(z_T>-10)=T_obs(find(z_T<=-10,1,'first'));
    T_in=T_obs(:,1);
    S_obs=cham.S(:,ipk);S_obs(z_S>-10)=S_obs(find(z_S<=-10,1,'first'));
    S_in=S_obs(:,1);
    E_obs=cham.EPSILON1(:,ipk);E_obs(z_E>-10)=E_obs(find(z_E<=-10,1,'first'));
    E_in=E_obs(:,1);
    
    T_obs=T_obs';S_obs=S_obs';E_obs=E_obs';
   
%     figure;contourf((t_adcp-tstart)*24,z_V,V_obs');title('V1');;colorbar
    
    
elseif iprofs==3
    % analytical model
    z_T=-[0:10:100]';
    z_U=z_T;z_V=z_T;z_S=z_T;z_E=z_T;
    one=ones(1,length(z_in));
    T_in=30+z_in*.2;
    S_in=35*one;
    U_in=z_in/1e2;
    V_in=0*one;
    E_in=0*one;
    time_in=0;
    T_in(z_in>-20)=mean(T_in(z_in>-20));
end

%% interpolate
T_o=spline(z_T,T_in,z);T_o(z>-10)=T_o(find(z<=-10,1,'first'));
S_o=spline(z_S,S_in,z);S_o(z>-10)=S_o(find(z<=-10,1,'first'));
U_o=spline(z_U,U_in,z);U_o(z>-20)=U_o(find(z<=-20,1,'first'));
V_o=spline(z_V,V_in,z);V_o(z>-20)=V_o(find(z<=-20,1,'first'));
E_o=spline(z_E,E_in,z);E_o(E_o<1e-10)=1e-10;

return
%% plot (comment out the receding statement if you want to make these plots)
figure(21);clf
lw=1.5;
subplot(1,3,1)
plot(T_o,z,'r','linewidth',lw);
hold on
plot(S_o,z,'b','linewidth',lw)
ylabel('z [m]')
legend('T [^oC]','S [psu]','location','northwest'); legend boxoff
title(sprintf('day=%.4f',time_in));
xlabel('T [^oC], S [psu]')

subplot(1,3,2)
plot(U_o,z,'r','linewidth',lw)
hold on
plot(V_o,z,'b','linewidth',lw)
set(gca,'yticklabel','')
h=legend('U [m/s]','V [m/s]','location','northwest'); legend boxoff
plot([0 0],ylim,'k')
xlabel('U,V [m/s]')

subplot(1,3,3)
semilogx(E_o,z,'r','linewidth',lw);
set(gca,'yticklabel','')
xlabel('\epsilon [W/kg]')


