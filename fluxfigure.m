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
#for i=1:1
for i=1:length(znc)
	output = [outdir '/HeatFlux/HeatFlux_t' num2str(tnc) 'z' num2str(znc(i)) 'm'];
	axeslabels = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Heat Flux (W/m^2) at ' num2str(tnc) ' s ' num2str(znc(i)) 'm Depth']};
	z = squeeze(nc{'Tf'}(1,i,:,:))';
	plotslice(output,z,xnc,ync,axeslabels,termtype);
	output = [outdir '/Temp/Temp_t' num2str(tnc) 'z' num2str(znc(i)) 'm'];
	axeslabels = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Temperature (C) at ' num2str(tnc) ' s '  num2str(znc(i)) 'm Depth']};
	z = squeeze(nc{'t'}(1,i,:,:))';
	plotslice(output,z,ync,xnc,axeslabels,termtype);
end
x = squeeze(nc{'Tfmean'}(:));
y = -znc';
minx = min(x);
maxx = max(x);
minxy = y(find(x==min(x)));
maxxy = y(find(x==max(x)));
output = [outdir '/Means/MeanHeatFlux_t' num2str(tnc)];
axeslabels = {
'Heat Flux (W/m^2)',
'Depth (m)',
['Mean Turbulent Heat Flux at ' num2str(tnc) ' s'],
'set style data filledcurves x1=0',
'set linetype 1 lc rgb "#ffa0a0"',
['set arrow from ' num2str(minx/2) ',' num2str(minxy+5) ' to ' num2str(minx/2) ',' num2str(minxy-5) ' size character 2,20 lw 2 front filled'],
['set arrow from ' num2str(maxx/2) ',' num2str(maxxy-5) ' to ' num2str(maxx/2) ',' num2str(maxxy+5) ' size character 2,20 lw 2 front filled']
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
dz = ddz(y);
size(x)
size(dz)
x = x*dz';
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanHeatFluxDiv_t' num2str(tnc)];
axeslabels = {'Heat Flux Divergence (W/m^3)','Depth (m)',['Divergence of Mean Turbulent Heat Flux at ' num2str(tnc) ' s'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#a0a0ff"',['set label "Cooling" at ' num2str(minx/2) ',' num2str(meany) ' center front'],['set label "Warming" at ' num2str(maxx/2) ',' num2str(meany) ' center front']
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
x = nc{'umean'}(:);
Su = x*dz';
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanZonalVelocity_t' num2str(tnc)];
axeslabels = {'Zonal Velocity (m/s)','Depth (m)',['Mean Zonal Velocity at ' num2str(tnc) ' s'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#a0ffa0"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
x = nc{'vmean'}(:);
Sv = x*dz';
minx = min(x);
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanMeridionalVelocity_t' num2str(tnc)];
axeslabels = {'Meridional Velocity (m/s)','Depth (m)',['Mean Meridional Velocity at ' num2str(tnc) ' s'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#ffa500"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
x = sqrt(Su.^2+Sv.^2);
minx = 0;
maxx = max(x);
meany = mean(y);
output = [outdir '/Means/MeanVelocityShear_t' num2str(tnc)];
axeslabels = {'Vertical Shear (1/s)','Depth (m)',['Mean Vertical Shear at ' num2str(tnc) ' s'],'set style data filledcurves x1=0','set linetype 1 lc rgb "#00a5ff"'
};
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
ncclose(nc);
end%function
