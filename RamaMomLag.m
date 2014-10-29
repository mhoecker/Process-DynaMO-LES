#Rama data file
ramanc = "/home/mhoecker/work/Dynamo/Observations/netCDF/RAMA/uv_RAMA_0N80E.nc";
# Revelle data file
revenc = "/home/mhoecker/work/Dynamo/Observations/netCDF/RevelleMet/Revelle1minuteLeg3_r3.nc";
# Date range
trange = [312,330];
# Depth range
zrange = [0,-10];
# Load Rama mooring data
rama = netcdf(ramanc,'r');
trama = rama{'t'}(:);
zrama = rama{'z'}(:);
tramaidx = find((trama>=min(trange)).*(trama<=max(trange)));
zramaidx = find((zrama>=min(zrange)).*(zrama<=max(zrange)));
trama = rama{'t'}(tramaidx);
zrama = rama{'z'}(zramaidx);
u = rama{'u'}(tramaidx,zramaidx);
v = rama{'v'}(tramaidx,zramaidx);
ncclose(rama);
# Load Revelle surface stress
reve = netcdf(revenc,'r');
treve = reve{'Yday'}(:);
treveidx = find((treve>=min(trange)).*(treve<=max(trange)));
treve = reve{'Yday'}(treveidx);
Taureve = reve{'stress'}(treveidx);
dirreve = 2*pi*reve{'WdirR'}(treveidx)./180;
ncclose(reve);
# Calculate meridional and zonal components
Tx = Taureve.*sin(dirreve);
Ty = Taureve.*cos(dirreve);
# Calculate d/dt of Rama velocity
ddtrama = ddz(trama);
dudt = ddtrama*u;
dvdt = ddtrama*v;
# filter/interpolate onto same time basis
# find the time step of the two series
dtrama = mean(diff(trama));
dtreve = mean(diff(treve));
if(dtrama>dtreve)
 "Rama is less frequent"
 Txf = harmfill(Tx,treve,trama,1,1.5*dtrama);
 Tyf = harmfill(Ty,treve,trama,1,1.5*dtrama);
 figure(3)
 subplot(2,1,1)
 plot(treve,Tx,trama,Txf)
 subplot(2,1,2)
 plot(treve,Ty,trama,Tyf)
 t = trama;
 Tx = Txf;
 Ty = Tyf;
 clear Txf Tyf trama treve
else
 "Revelle is less frequent"
 dudtf = harmfill(dudt,trama,treve,2,1.5*dtreve);
 dvdtf = harmfill(dvdt,trama,treve,2,1.5*dtreve);
 t = treve;
 dudt = dudtf;
 dvdt = dvdtf;
 clear dudtf dvdtf trama treve
end#if
[tt,zz]=meshgrid(t,zrama);
vrange=[-1,1]
dvrange=[-2,2]
figure(4)
subplot(2,1,1)
pcolor(tt,zz,u'); caxis(vrange); shading flat; colorbar
subplot(2,1,2)
pcolor(tt,zz,dudt'); caxis(dvrange); shading flat; colorbar
addpath "spectra";
figure(1)
for i=1:length(zrama);
 F = mycrosscorr(Tx,dudt(:,i),t,4);
end
# do laged correlation of du/dt vs surface tau
