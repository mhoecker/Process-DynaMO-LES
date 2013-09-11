function fluxfigure(flxnc,outdir)
# Plots the output of fluxfromrst in slices
#
nc = netcdf(flxnc , 'r');
tnc = nc{'time'}(:);
xnc = nc{'xw'}(:)';
ync = nc{'yu'}(:)';
znc = nc{'zu'}(:);
znc = ceil(max(znc))-znc;
termtype = 'pngposter';
for i=1:1
#for i=1:length(znc)
	output = [outdir '/HeatFlux/HeatFlux_t' num2str(tnc) 'z' num2str(znc(i)) 'm'];
	axeslabels = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Heat Flux (W/m^2) at ' num2str(tnc/3600) ' hrs ' num2str(znc(i)) 'm Depth']};
	z = squeeze(nc{'Tf'}(1,i,:,:))';
	plotslice(output,z,xnc,ync,axeslabels,termtype);
	output = [outdir '/Temp/Temp_t' num2str(tnc) 'z' num2str(znc(i)) 'm'];
	axeslabels = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Temperature (C) at ' num2str(tnc/3600) ' hrs '  num2str(znc(i)) 'm Depth']};
	z = squeeze(nc{'t'}(1,i,:,:))';
	plotslice(output,z,ync,xnc,axeslabels,termtype);
end
y = -znc';
x = squeeze(nc{'Tfmean'}(:));
minx = min(x);
maxx = max(x);
minxy = y(find(x==min(x)));
maxxy = y(find(x==max(x)));
output = [outdir '/Means/MeanHeatFlux_t' num2str(tnc)];
axeslabels = {
'Heat Flux (W/m^2)',
'Depth (m)',
['Mean Turbulent Heat Flux at ' num2str(tnc/3600) ' hrs'],
'set style data filledcurves x1=0',
'set linetype 1 lc rgb "#ffa0a0"',
['set arrow from ' num2str(minx/2) ',' num2str(minxy+5) ' to ' num2str(minx/2) ',' num2str(minxy-5) ' size character 2,20 lw 2 front filled'],
['set arrow from ' num2str(maxx/2) ',' num2str(maxxy-5) ' to ' num2str(maxx/2) ',' num2str(maxxy+5) ' size character 2,20 lw 2 front filled']
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
x = squeeze(nc{'Sfmean'}(:));
x = 24*3600*x;
output = [outdir '/Means/MeanSalinityFlux_t' num2str(tnc)];
axeslabels = {
'Turbulent Salinity Flux (psu m / day)',
'Depth (m)',
['Mean Turbulent Salinity Flux at ' num2str(tnc/3600) ' hrs'],
'set style data filledcurves x1=0',
'set linetype 1 lc rgb "#ff00a5"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
x = 24*3600*nc{'uwfmean'}(:);
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanZonalVelFlx_t' num2str(tnc)];
axeslabels = {'Zonal Turbulent Velocity Flux ((m/s)*(m/day))','Depth (m)',['Mean Zonal Velocity Flux at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#a0ffa0"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
x = 24*3600*nc{'vwfmean'}(:);
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanMeridVelFlx_t' num2str(tnc)];
axeslabels = {'Meridional Velocity Flux ( (m/s)*(m/day))','Depth (m)',['Mean Meridional Velocity Flux at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#ffa500"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
dz = ddz(y);
x = nc{'umean'}(:);
Su = x*dz';
x = nc{'vmean'}(:);
Sv = x*dz';
x = sqrt(Su.^2+Sv.^2);
minx = 0;
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanVelocityShear_t' num2str(tnc)];
axeslabels = {'Vertical Shear (1/s)','Depth (m)',['Mean Vertical Shear at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#00a5ff"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
ysfc=-3;
subsfcidx = find(y<ysfc);
x = squeeze(nc{'Tfmean'}(:));
x = x*dz';
ysubsfc = y(subsfcidx);
x = x(subsfcidx);
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanHeatFluxDiv_t' num2str(tnc)];
axeslabels = {'Heat Flux Divergence (W/m^3)','Depth (m)',['Divergence of Mean Turbulent Heat Flux at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#a0a0ff"',['set label "Cooling" at ' num2str(maxx/2) ',' num2str(meany) ' center front'],['set label "Warming" at ' num2str(minx/2) ',' num2str(meany) ' center front']};
myplot(output,x(subsfcidx),y(subsfcidx),axeslabels,termtype);
clear axeslabels
x = squeeze(nc{'Tfmean'}(:));
x = x*dz';
x = -24*3600*x/(4000000.0);
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanHeatWarming_t' num2str(tnc)];
axeslabels = {"Warming (^oC/day)",'Depth (m)',['Warming due to Turbulent Heat Flux at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#a500ff"'};
myplot(output,x(subsfcidx),y(subsfcidx),axeslabels,termtype);
clear axeslabels
x = squeeze(nc{'Sfmean'}(:));
x = -24*3600*x*dz';
output = [outdir '/Means/MeanSalinification_t' num2str(tnc)];
axeslabels = {
'Turbulent Salinification (psu/day)',
'Depth (m)',
['Mean Turbulent Salinification at ' num2str(tnc/3600) ' hrs'],
'set style data filledcurves x1=0',
'set linetype 1 lc rgb "#ff00a5"',
};
myplot(output,x(subsfcidx),y(subsfcidx),axeslabels,termtype);
clear axeslabels
x = nc{'uwfmean'}(:);
x = -24*3600*x*dz';
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanZonalAccel_t' num2str(tnc)];
axeslabels = {'Zonal Turbulent Acceleration (m/s/day)','Depth (m)',['Mean Zonal Turbulent Acceleration  at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#a0ffa0"'
};
myplot(output,x(subsfcidx),y(subsfcidx),axeslabels,termtype);
clear axeslabels
x = nc{'vwfmean'}(:);
x = -24*3600*x*dz';
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanMeridionalAccel_t' num2str(tnc)];
axeslabels = {'Meridional Turbulent Acceleration (m/s/day','Depth (m)',['Mean Meridional Turbulent Acceleration at ' num2str(tnc/3600) ' hrs'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#ffa500"'
};
myplot(output,x(subsfcidx),y(subsfcidx),axeslabels,termtype);
clear axeslabels
ncclose(nc);
end%function
