%filterTCCham
gswloc = "/home/mhoecker/work/TEOS-10/";
gswlib = "/home/mhoecker/work/TEOS-10/library/";
fileloc = "/home/mhoecker/work/Dynamo/Observations/AurelieObs/";
filename = "TCCham10_leg3";
lat = 0;
lon = 80;
addpath(gswloc);
addpath(gswlib);
load([fileloc filename ".mat"]);
tidx = 1:length(TCCham.time);
time = TCCham.time(tidx);
thourly = min(time):1./24:max(time);
% Get Pressure from depth
P = gsw_p_from_z(-TCCham.depth,lat);
Sa = 0*TCCham.S(:,tidx);
Tc = 0*TCCham.T(:,tidx);
rho = 0*TCCham.T(:,tidx);
[tt,zz]=meshgrid(thourly,-TCCham.depth);
Sahourly = tt*0;
Salp = Sahourly;
Tchourly = tt*0;
Tclp = Tchourly;
rhohourly = tt*0;
rholp = rhohourly;
% need to be done for each time slice and reassembled
for i=1:length(time)
 Sa(:,i) = gsw_SA_from_SP(TCCham.S(:,tidx(i)),P,lon,lat);
 Tc(:,i) = gsw_CT_from_t(Sa(:,i),TCCham.T(:,tidx(i)),P);
 for j=1:length(TCCham.depth)
  rho(j,i) = gsw_rho_CT(Sa(j,i),Tc(j,i),mean(P));
 end%for
end%for
% Filter each depth in time
for j=1:length(TCCham.depth)
 Sahourly(j,:)  = csqfil(Sa(j,:) ,time   ,thourly);
 Salp(j,:)      = csqfil(Sahourly(j,:) ,thourly,thourly,3);
 Tchourly(j,:)  = csqfil(Tc(j,:) ,time   ,thourly);
 Tclp(j,:)      = csqfil(Tchourly(j,:) ,thourly,thourly,3);
 rhohourly(j,:) = csqfil(rho(j,:),time  ,thourly);
 rholp(j,:)     = csqfil(rhohourly(j,:),thourly,thourly,3);
end%for
%
ddzmatrix = ddz(TCCham.depth);
hnan = find(isnan(rhohourly));
lpnan = find(isnan(rholp));
rhohourly(hnan)=0;
rholp(lpnan)=0;
drhodzhourly = (ddzmatrix'*rhohourly);
drhodzlp = (ddzmatrix'*rholp);
rhohourly(hnan)=NaN;
rholp(lpnan)=NaN;
hnan = find(abs(drhodzhourly)>10);
lpnan = find(abs(drhodzlp)>10);
drhodzhourly(hnan)=NaN;
drhodzlp(lpnan)=NaN;
%
save([fileloc filename "filtered.mat"],"lat","lon","time","thourly","Sa","Tc","rho","Sahourly","Tchourly","rhohourly","Salp","Tclp","rholp","drhodzhourly","drhodzlp");
%
figure(1)
subplot(4,1,1)
pcolor(tt,zz,Sahourly-Salp);shading flat;colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,2)
pcolor(tt,zz,Sahourly-Salp);shading flat;colorbar;axis([min(time),max(time),-300,0]);
subplot(4,1,3)
pcolor(tt,zz,Salp);shading flat;colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,4)
pcolor(tt,zz,Salp);shading flat;colorbar;axis([min(time),max(time),-300,0]);
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" filename "SaFiltered.png"],"-dpng","-S1280,1024")
%
figure(2)
subplot(4,1,1)
pcolor(tt,zz,Tchourly-Tclp);shading flat;colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,2)
pcolor(tt,zz,Tchourly-Tclp);shading flat;colorbar;axis([min(time),max(time),-300,0]);
subplot(4,1,3)
pcolor(tt,zz,Tclp);shading flat;colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,4)
pcolor(tt,zz,Tclp);shading flat;colorbar;axis([min(time),max(time),-300,0]);
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" filename "TcFiltered.png"],"-dpng","-S1280,1024")
%
figure(3)
subplot(4,1,1)
pcolor(tt,zz,rhohourly-rholp);shading flat;colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,2)
pcolor(tt,zz,rhohourly-rholp);shading flat;colorbar;axis([min(time),max(time),-300,0]);
subplot(4,1,3)
pcolor(tt,zz,rholp);shading flat;colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,4)
pcolor(tt,zz,rholp);shading flat;colorbar;axis([min(time),max(time),-300,0]);
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" filename "rhoFiltered.png"],"-dpng","-S1280,1024")
%
figure(4)
subplot(4,1,1)
pcolor(tt,zz,drhodzhourly); shading flat; colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,2)
pcolor(tt,zz,drhodzhourly); shading flat; colorbar;axis([min(time),max(time),-300,0]);
subplot(4,1,3)
pcolor(tt,zz,drhodzlp); shading flat; colorbar;axis([min(time),max(time),-50,0]);
subplot(4,1,4)
pcolor(tt,zz,drhodzlp); shading flat; colorbar;axis([min(time),max(time),-300,0]);
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" filename "drhodzFiltered.png"],"-dpng","-S1280,1024")
