tic
clear
close all

% Updated KPP with nonlocal momentum fluxes included, Smyth et al. (2002)
%     Smyth, W.D., E.D. Skyllingstad, G.B. Crawford and H. Wijesekera,
%        2002, "Nonlocal fluxes and Stokes drift effects in the
%        K-profile parameterization", Ocean Dynamics 52 (3), 104-115.

% choose dataset:
adcpfile = "/home/mhoecker/work/Dynamo/Observations/netCDF/ADCP/adcp150_filled_with_140_filtered_1hr_3day.nc";
TCChamfile = "/home/mhoecker/work/Dynamo/Observations/AurelieObs/netCDF/TCCham10_leg3_filtered_1hr_3day.nc";
varfile={adcpfile,adcpfile,TCChamfile,TCChamfile,TCChamfile};
varname={"uhp","vhp","Tc_h","Sa_h","epsilon_h"};
tname = {"t","t","th","th","th"};
zname = {"z","z","z","z","z"};
zsign = [+1,+1,+1,+1,+1];
order = [-1,-1,-1-,1,-1];
% set up time parameters
tstart=328.02+datenum([2011,1,1])-1; % start time in days (eg for DYNAMO data tstart=328.02+datenum([2011,1,1])-1)
days=2;
frot=0; %DYNAMO value

dt=240; % time step [s]
nstep=15; % number of time steps per save
nsave=(3600*24/(nstep*dt))*days; % number of saves
tend=tstart+(nsave*nstep*dt)/24/3600;

% set up depth parameters
Lz=96; % Maximum depth
nn=64; % number of depth bins
dz=Lz/(nn-1); % depth spacing
z=-[.5*dz:dz:Lz-.5*dz]'; % model z coordinate for prognostic variables[m]
zp=-[0:dz:Lz]'; % model z coordinate for fluxes[m]
nn=length(z);

%% read U, V, T, S profiles **** NEED TO SPECIFY INPUT FILES
[U V T S E]=initial_profile_netCDF(t,z,varfile,varname,tname,zname,zsign,order);

%% read and plot surface fluxes **** NEED TO SPECIFY INPUT FILES
[t_sfc0 swrd_sfc ustar2_sfc vstar2_sfc hflx_sfc precip_sfc] = read_surface(iprofs);

t_sfc=t_sfc0-tstart*24*3600;
tend_sfc=dt*nstep*nsave;
pkt=t_sfc<=tend_sfc & t_sfc>=0;

h=figure(22);clf;
set(h,'Position' ,[624 594 672 504]-[600 0 0 0])
lw=1.5;
subplot(3,1,1)
plot(t_sfc(pkt)/3600,hflx_sfc(pkt),'linewidth',lw)
hold on
plot(t_sfc(pkt)/3600,swrd_sfc(pkt),'r','linewidth',lw)
% xlabel('t [hr]')
ylabel('Q_h [W/m^2])')
hold on
plot(xlim,[0 0],'k')
ylim([-1000 500])
title('surface fluxes')

subplot(3,1,2)
plot(t_sfc(pkt)/3600,precip_sfc(pkt)*1000*3600,'.')
hold on
plot(xlim,[0 0],'k')
ylim([-1 20])
ylabel('P-E [mm/hr]')

subplot(3,1,3)
plot(t_sfc(pkt)/3600,ustar2_sfc(pkt)*1020,'linewidth',lw)
hold on
plot(xlim,[0 0],'k')
plot(t_sfc(pkt)/3600,vstar2_sfc(pkt)*1020,'r','linewidth',lw)
xlabel('t [hr]')
ylabel('\tau_x, \tau_y [N/m^2]')
ylim([-.2 .4])

%% short-wave penetration parameters  **** NEED TO SPECIFY INPUT FILES
R1_rad
amu1_r
R2_rad = 1-r1
amu2_r] = read_pene(iprofs);


%% prepare for time stepping
t=0;
% initial profiles
uvl=U_o;
vvl=V_o;
tmp=T_o;
sal=S_o;

% initialize source terms
su = 0*uvl;
sv = 0*vvl;
st = 0*tmp;
ss = 0*sal;

% Interpolate to compute initial surface fluxes and transmission coefficients
[swrd ustar2 vstar2 hflx precip r1 r2 amu1 amu2] = ...
    timedep(t,dt,t_sfc,hflx_sfc,ustar2_sfc,vstar2_sfc,swrd_sfc,precip_sfc, ...
    t_r,r1_r,r2_r,amu1_r,amu2_r);sflx=precip*sal(1);

% call kpp to compute diffusivity profiles and nonlocal mixing coefficients
hbl=0;
[km kt ks ghatu ghatv ghatt ghats hbl] = kpp(uvl,vvl,tmp,sal,z,zp,-ustar2,-vstar2,(hflx-swrd)/4e6,sflx,swrd/4e6,frot,hbl,r1,amu1,r2,amu2,imod);

% initialize cumulative budget
cbudg_u=0.*[1:4];
cbudg_v=0.*[1:4];
cbudg_t=0.*[1:4];
cbudg_s=0.*[1:4];

%% loop over saves
for isv=1:nsave
    %% take nstep steps
    for ist=1:nstep
        t=t+dt;
        [swrd ustar2 vstar2 hflx precip r1 r2 amu1 amu2] = ...
            timedep(t,dt,t_sfc,hflx_sfc,ustar2_sfc,vstar2_sfc,swrd_sfc,precip_sfc, ...
            t_r,r1_r,r2_r,amu1_r,amu2_r);sflx=precip*sal(1);
        rad_frac=r1*exp(z/amu1)+r2*exp(z/amu2);
        [Km Kt Ks ghatu ghatv ghatt ghats hbl] = kpp(uvl,vvl,tmp,sal,z,zp,-ustar2,-vstar2,(hflx-swrd)/4e6,sflx,swrd/4e6,frot,hbl,r1,amu1,r2,amu2,imod);

        %% source terms
        su0=su;sv0=sv;st0=st;ss0=ss;
        Km0=Km;Kt0=Kt;Ks0=Ks;
        su=0*uvl;sv=0*vvl;st=0*tmp;ss=0*sal;

        % Coriolis
        su=frot*vvl;
        sv=-frot*uvl;

        % Nonlocal fluxes
        for n=2:nn-1
            su(n)=su(n)-(Km(n)*ghatu(n)-Km(n+1)*ghatu(n+1))/dz;
            sv(n)=sv(n)-(Km(n)*ghatv(n)-Km(n+1)*ghatv(n+1))/dz;
            st(n)=-(Kt(n)*ghatt(n)-Kt(n+1)*ghatt(n+1))/dz;
            ss(n)=-(Ks(n)*ghats(n)-Ks(n+1)*ghats(n+1))/dz;
        end
        su(1)=su(1)+Km(2)*ghatu(2)/dz;
        sv(1)=sv(1)+Km(2)*ghatv(2)/dz;
        st(1)=st(1)+Ks(2)*ghatt(2)/dz;
        ss(1)=ss(1)+Ks(2)*ghats(2)/dz;
        st(nn)=0.;
        ss(nn)=0.;

        % Penetrative radiation
        pene=st*0;
        pene(1:end-1)=-(swrd/4e6)*(rad_frac(1:end-1)-rad_frac(2:end));
        pene(end)=-(swrd/4e6)*(rad_frac(end-1)-rad_frac(end));
        swrdb=swrd*rad_frac(end);
        st=st+pene;

        % fractionation of source terms
        frac_u=sum(frot*vvl)/sum(su);
        frac_v=sum(-frot*uvl)/sum(sv);
        frac_t=sum(pene)/sum(st);
        frac_s=0;

        %
        %   2nd-order Adams-Bashforth for source terms on all but the first step
        %   Similar extrapolation for Km,Kt,Ks.
        %

        if isv == 1 & ist == 1
            du_dt=su;dv_dt=sv;
            dt_dt=st;ds_dt=ss;
            Km_f=Km;Kt_f=Kt;Ks_f=Ks;
        else
            du_dt=1.5*su-.5*su0;dv_dt=1.5*sv-.5*sv0;
            dt_dt=1.5*st-.5*st0;ds_dt=1.5*ss-.5*ss0;
            Km_f=1.5*Km-.5*Km0;Kt_f=1.5*Kt-.5*Kt0;Ks_f=1.5*Ks-.5*Ks0;
        end

        %% advance profiles by one time step
        [uvl,budg_u,budg2_u] = step(uvl,Km_f,du_dt,-ustar2,0,dz,dt,frac_u);
        [vvl,budg_v,budg2_v] = step(vvl,Km_f,dv_dt,-vstar2,0,dz,dt,frac_v);
        [tmp,budg_t,budg2_t] = step(tmp,Kt_f,dt_dt,(hflx-swrd)/4e6,swrdb/4e6,dz,dt,frac_t);
        [sal,budg_s,budg2_s] = step(sal,Ks_f,ds_dt,sflx,0,dz,dt,frac_s);

    end

    %% add new profiles to saved data
    t_s(isv)=t/3600;
    uvl_s(:,isv)=uvl;vvl_s(:,isv)=vvl;
    tmp_s(:,isv)=tmp;sal_s(:,isv)=sal;
    ustar2_s(isv)=ustar2;vstar2_s(isv)=vstar2;
    hflx_s(isv)=hflx;swrd_s(isv)=swrd;
    precip_s(isv)=precip;sflx_s(isv)=sflx;
    %     dml_s(isv)=dml;
    hbl_s(isv)=hbl;

    % save budget terms
    budg_u_s(isv,:)=budg_u';budg_v_s(isv,:)=budg_v';
    budg_t_s(isv,:)=budg_t';budg_s_s(isv,:)=budg_s';
    budg2_u_s(isv,:)=budg2_u';budg2_v_s(isv,:)=budg2_v';
    budg2_t_s(isv,:)=budg2_t';budg2_s_s(isv,:)=budg2_s';

    %% update the profile plot
    figure(11);clf
    lw=1.5;
    subplot(2,2,1)
    plot(tmp,z,'r','linewidth',lw);
    hold on
    plot(T_o,z,'r--','linewidth',1);
    plot(xlim,-hbl*[1 1],'k')
    xlabel('T [^oC]')
    ylabel('z [m]')
    ylim([-Lz 0])
    xlim(tmp_s(1,1)+[-1 .25])

    subplot(2,2,2)
    plot(sal,z,'b','linewidth',lw)
    hold on
    plot(S_o,z,'b--','linewidth',1);
    plot(xlim,-hbl*[1 1],'k')
    ylim([-Lz 0])
    xlabel('S [psu]')
    title(sprintf('hour=%.2f day=%.2f',t/3600, t/3600/24));
    xlim(sal_s(1,1)+[-.5 .4])

    subplot(2,2,3)
    plot(uvl,z,'b','linewidth',lw)
    hold on
    plot(U_o,z,'b--','linewidth',1)
    plot(vvl,z,'r','linewidth',lw)
    plot(V_o,z,'r--','linewidth',1)
    plot(xlim,-hbl*[1 1],'k')
    plot([0 0],ylim,'k')
    ylim([-Lz 0])
    xlim([-1 1])
    xlabel('U (b), V (r) [m/s]')

    subplot(2,2,4)
    eps=Km.*((ddz(z)*uvl).^2+(ddz(z)*vvl).^2);
    semilogx(eps,z,'r','linewidth',lw)
    hold on
    semilogx(Km,z,'k','linewidth',lw)
    plot(xlim,-hbl*[1 1],'k')
    ylim([-Lz 0])
    xlabel('\epsilon [W/kg], K_m [m^2/s]')
    xlim([1e-10 1])

end

%% SST, SSS plots

dep=5;
lab0=sprintf('model mean 0-%.1fm',dep);
kk=[1 5 12];
lab1=sprintf(' model z=%.2fm',z(kk(1)));
lab2=sprintf(' model z=%.2fm',z(kk(2)));
lab3=sprintf(' model z=%.2fm',z(kk(3)));

fs=16;
figure
load('\\gofer\data\Dynamo11\data\Tchain\Seabird\sbd_sum_dn11.mat') % *** NEED TO LOCATE THIS FILE
t_sbd=sbd1.time-datenum(2011,1,1,0,0,0)+1;
pk=t_sbd>=tstart & t_sbd<=tend;
h=plot(t_sbd(pk),sbd1.t(pk),'linewidth',.5)
set(h,'Color',[.7 .7 .7])
hold on
h=plot(t_sbd(pk),sbd2.t(pk),'linewidth',.5)
set(h,'Color',[1 .4 1])

plot(t_s/24+tstart,mean(tmp_s(z>-dep,:)),'g','linewidth',1.5)
plot(t_s/24+tstart,tmp_s(kk(1),:),'k','linewidth',1.5)
plot(t_s/24+tstart,tmp_s(kk(2),:),'r','linewidth',1.5)
plot(t_s/24+tstart,tmp_s(kk(3),:),'b','linewidth',1.5)
legend('Seabird1 2m','Seabird2 5m',lab0,lab1,lab2,lab3)
xlabel('day','fontsize',fs)
ylabel('T [^o C]','fontsize',fs)
title('model vs. data SST','fontsize',fs)

figure
h=plot(t_sbd(pk),sbd1.sal(pk),'linewidth',.5)
set(h,'Color',[.7 .7 .7])
hold on
h=plot(t_sbd(pk),sbd2.sal(pk),'linewidth',.5)
set(h,'Color',[1 .4 1])

plot(t_s/24+tstart,mean(sal_s(z>-dep,:)),'g','linewidth',1.5)
%     plot(t_s/24+tstart,sal_s(1,:),'g','linewidth',1.5)
plot(t_s/24+tstart,sal_s(kk(1),:),'k','linewidth',1.5)
plot(t_s/24+tstart,sal_s(kk(2),:),'r','linewidth',1.5)
plot(t_s/24+tstart,sal_s(kk(3),:),'b','linewidth',1.5)
legend('Seabird1 2m','Seabird2 5m','model mean 0-5m',lab1,lab2,lab3)
xlabel('day','fontsize',fs)
ylabel('S [psu]','fontsize',fs)
title('model vs. data SSS','fontsize',fs)

%% image plots

h=figure(1);clf
set(h,'Position' , [24 24 1900 900])
umn=-.2;umx=1;cu=[-.4:.02:1.2];cu_l=[-.4:.1:1];ulab=[-.1 .1 .3 .5];
vmn=-.6;vmx=.6;cv=cu;cv_l=cu_l;vlab=[-.3 -.1  .1 .3];
tmn=28.65;tmx=28.85;ct=[28.7:.005:28.85];ct_l=[28.74:.02:28.84];tlab=[28.7 28.8];
tmn=29.2;tmx=29.35;ct=[tmn+.5:.005:tmx];ct_l=[tmn+1:.02:tmx-.01];tlab=[28.7 28.8];
smn=34.23;smx=34.25;cs=[34.22:.001:34.27];cs_l=[34.22:.005:34.245];slab=[34.23 34.24 34.25];
smn=34;smx=34.2;cs=[smn-.01:.005:smx+.02];cs_l=[smn-.01:.005:smx-.005];slab=[34.23 34.24 34.25];


[tmn dum dum tmx]=quartiles(tmp_s(:));
% tmx=max(tmp_s(:));tmn=tmx-2;
ct=[tmn:.01:tmx];


[dum smx smn]=quartiles(sal_s(:));
smn=min(sal_s(:));smx=smn+.05;
cs=[smn:.001:smx];

ct=[28:.010:30];
cs=[33.5:.010:36.5];

tmn=min(ct);tmx=max(ct);
smn=min(cs);smx=max(cs);


x1=.08;
dx=.03;
xr=.98;
wx=(xr-x1-3*dx)/4;
x2=x1+wx+dx;
x3=x2+wx+dx;
x4=x3+wx+dx;


dy=.03;
y1=.18;
yt=.96;
wy=(yt-y1-1*dy)/3;
y1=y1-1*wy;
y2=y1+wy+dy;
y3=y2+wy+dy;
y4=y3+wy+dy;
fsz=8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(a) MET DATA
subplot('position',[x1 y4+.25*wy wx  .5*wy])
plot(t_sfc/3600,ustar2_sfc*1020,'k','linewidth',1)
hold on;plot([min(t_sfc)/3600 max(t_sfc)/3600],[0 0],'k','linewidth',.5)
set(gca,'Xlim',[min(t_s) max(t_s)],'Ylim',[-.1 .3])
title('\tau_x (N/m^2)')
set(gca,'XTickLabel','','fontsize',fsz)
text(-.1,.2,sprintf('day %.2f',tstart),'units','normal','fontsize',fsz+4,'rotation',90)

subplot('position',[x2 y4+.25*wy wx  .5*wy])
plot(t_sfc/3600,vstar2_sfc*1020,'k','linewidth',1)
hold on;plot([min(t_sfc)/3600 max(t_sfc)/3600],[0 0],'k','linewidth',.5)
set(gca,'Xlim',[min(t_s) max(t_s)],'Ylim',[-.3 .1])
title('\tau_y (N/m^2)')
set(gca,'XTickLabel','','fontsize',fsz)

subplot('position',[x3 y4+.25*wy wx  .5*wy])
plot(t_sfc/3600,hflx_sfc,'k','linewidth',1)
hold on;plot([min(t_sfc)/3600 max(t_sfc)/3600],[0 0],'k','linewidth',.5)
set(gca,'Xlim',[min(t_s) max(t_s)],'Ylim',[-800 400])
title('Q_h (W/m^2)')
set(gca,'XTickLabel','','YTick',[-800 -400 0 400],'fontsize',fsz)

subplot('position',[x4 y4+.25*wy wx  .5*wy])
plot(t_sfc/3600,precip_sfc*3.6e6,'k.','markersize',5)
hold on;plot([min(t_sfc)/3600 max(t_sfc)/3600],[0 0],'k','linewidth',.5)
set(gca,'Xlim',[min(t_s) max(t_s)],'Ylim',[-1 15])
title('P-E (mm/hr)')
set(gca,'XTickLabel','','fontsize',fsz)

zbot=-80;

subplot('position',[x1 y3 wx wy])
contourf(t_s,z,uvl_s,cu);%shading flat
colorbar('horiz')
title('U [m/s]')
ylabel('z [m]')
ylim([zbot 0])
xlabel('t [hr]')
caxis([umn umx])
xlim([min(t_s) max(t_s)])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'fontsize',fsz)
% p2=get(h2,'position');
% p2(2)=p2(2)-.08;
% set(h2,'position',p2);

subplot('position',[x2 y3 wx wy])
contourf(t_s,z,vvl_s,cv);%shading flat
colorbar('horiz')
title('V [m/s]')
xlabel('t [hr]')
xlim([min(t_s) max(t_s)])
ylim([zbot 0])
caxis([vmn vmx])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'yticklabel','')
set(gca,'fontsize',fsz)

subplot('position',[x3 y3 wx wy])
contourf(t_s,z,tmp_s,ct);
colorbar('horiz')
title('T [^o C]')
xlabel('t [hr]')
xlim([min(t_s) max(t_s)])
ylim([zbot 0])
caxis([tmn tmx])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'yticklabel','')
set(gca,'fontsize',fsz)

subplot('position',[x4 y3 wx wy])
contourf(t_s,z,sal_s,cs);
colorbar('horiz')
title('S [psu]')
xlabel('t [hr]')
ylim([zbot 0])
xlim([min(t_s) max(t_s)])
%         caxis([smn 34.27])
caxis([smn smx])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'yticklabel','')
set(gca,'fontsize',fsz)

subplot('position',[x1 y2 wx wy])
contourf((t_adcp-tstart)*24,z_U,smooth(U_obs,4)',cu);ylim([zbot 0])
title('U [m/s]')
ylabel('z [m]')
h2=colorbar('horiz');
ylim([zbot 0])
xlabel('t [hr]')
caxis([umn umx])
xlim([min(t_s) max(t_s)])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'fontsize',fsz)
% p2=get(h2,'position');
% p2(2)=p2(2)-.08;
% set(h2,'position',p2);

subplot('position',[x2 y2 wx wy])
contourf((t_adcp-tstart)*24,z_V,smooth(V_obs,4)',cv);ylim([zbot 0])
title('V [m/s]')
xlabel('t [hr]')
h2=colorbar('horiz');
xlim([min(t_s) max(t_s)])
ylim([zbot 0])
caxis([vmn vmx])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'yticklabel','')
set(gca,'fontsize',fsz)



for k=1:length(z_T)
    [~,T_bin(k,:)] = bin_function((t_cham'-tstart)*24,T_obs(:,k),[0 t_s]);
    [~,S_bin(k,:)] = bin_function((t_cham'-tstart)*24,S_obs(:,k),[0 t_s]);
end

subplot('position',[x3 y2 wx wy])
contourf(t_s,z_T,smooth(T_bin',4)',ct);ylim([zbot 0]);
%     contourf((t_adcp-tstart)*24,z_T,T_obs',ct);ylim([zbot 0])
title('T [^o C]')
xlabel('t [hr]')
%         ylabel('z [m]')
h2=colorbar('horiz');
xlim([min(t_s) max(t_s)])
ylim([zbot 0])
caxis([tmn tmx])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'yticklabel','')
set(gca,'fontsize',fsz)

subplot('position',[x4 y2 wx wy])
contourf(t_s,z_S,smooth(S_bin',4)',cs);ylim([zbot 0])
%     contourf((t_adcp-tstart)*24,z_S,S_obs',cs);ylim([zbot 0])
title('S [psu]')
xlabel('t [hr]')
h2=colorbar('horiz');
ylim([zbot 0])
xlim([min(t_s) max(t_s)])
%         caxis([smn 34.27])
caxis([smn smx])
hold on
%     plot(t_s,-hbl_s,'w','linewidth',1.5);plot(t_s,-hbl_s,'k','linewidth',.5)
set(gca,'yticklabel','')
set(gca,'fontsize',fsz)




%% budgets
h=figure;
set(h,'Position', [624 594 672 504]+[600 0 0 0])
lw=1.5;
subplot(2,2,1)
plot(t_s,budg_u_s,'linewidth',lw)
title('U')
subplot(2,2,2)
cols=get(gca,'Colororder');
plot(t_s,budg_v_s(:,1),'Color',cols(1,:),'linewidth',lw)
hold on
plot(t_s,budg_v_s(:,2),'Color',cols(2,:),'linewidth',lw)
plot(t_s,budg_v_s(:,3),'Color',cols(3,:),'linewidth',lw)
plot(t_s,budg_v_s(:,4),'Color',cols(4,:),'linewidth',lw)
plot(t_s,budg_v_s(:,5),'Color',cols(5,:),'linewidth',lw)
plot(t_s,budg_v_s(:,6),'Color',cols(6,:),'linewidth',lw)
h=legend('ddt','sfc','bot','src','NL','err');set(h,'fontsize',8)
title('V')
subplot(2,2,3)
% plot(t_s,budg_t_s,'linewidth',lw)
plot(t_s,budg_t_s(:,1),'Color',cols(1,:),'linewidth',lw)
hold on
plot(t_s,budg_t_s(:,2),'Color',cols(2,:),'linewidth',lw)
plot(t_s,budg_t_s(:,3),'Color',cols(3,:),'linewidth',lw)
plot(t_s,budg_t_s(:,4),'Color',cols(4,:),'linewidth',lw)
plot(t_s,budg_t_s(:,5),'Color',cols(5,:),'linewidth',lw)
plot(t_s,budg_t_s(:,6),'Color',cols(6,:),'linewidth',lw)
title('T')
subplot(2,2,4)
plot(t_s,budg_s_s,'linewidth',lw)
title('S')

budg_u_mn=mean(budg_u_s)
budg_v_mn=mean(budg_v_s)
budg_t_mn=mean(budg_t_s)
budg_s_mn=mean(budg_s_s)

err_u=sqrt(mean(budg_u(:,end).^2))
err_v=sqrt(mean(budg_v(:,end).^2))
err_t=sqrt(mean(budg_t(:,end).^2))
err_s=sqrt(mean(budg_s(:,end).^2))



h=figure;
set(h,'Position', [624 594 672 504]+[600 -580 0 0])
lw=1.5;
subplot(2,2,1)
plot(t_s,budg2_u_s,'linewidth',lw)
title('U')
subplot(2,2,2)
plot(t_s,budg2_v_s,'linewidth',lw)
h=legend('ddt','sfc','bot','diss','src','NL','err');set(h,'fontsize',6)
title('V')
subplot(2,2,3)
plot(t_s,budg2_t_s,'linewidth',lw)
title('T')
subplot(2,2,4)
plot(t_s,budg2_s_s,'linewidth',lw)
title('S')

budg2_u_mn=mean(budg2_u_s)
budg2_v_mn=mean(budg2_v_s)
budg2_t_mn=mean(budg2_t_s)
budg2_s_mn=mean(budg2_s_s)



err2_u=sqrt(mean(budg2_u(:,end).^2))
err2_v=sqrt(mean(budg2_v(:,end).^2))
err2_t=sqrt(mean(budg2_t(:,end).^2))
err2_s=sqrt(mean(budg2_s(:,end).^2))

toc
