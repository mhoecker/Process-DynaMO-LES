#this only needs to be run once!
#rstnc = '/home/mhoecker/work/Dynamo/output/run1/dyno_sw2-a_21600_rst.nc' 
#outloc = '/home/mhoecker/work/Dynamo/output/run1/'
#flxnc = fluxfromrst(rstnc,outloc);
# The results are saved
#
flxnc = '/home/mhoecker/work/Dynamo/output/run1/dyno_sw2-a_21600_rst_flux.nc'
nc = netcdf(flxnc , 'r');
tnc = nc{'time'}(:);
xnc = nc{'xw'}(:)';
ync = nc{'yu'}(:)';
znc = nc{'zu'}(:);
znc = ceil(max(znc))-znc;
termtype = 'pngposter';
for i=length(znc):length(znc)
	output = ['/home/mhoecker/work/Dynamo/plots/run1/Tflux/HeatFlux' num2str(znc(i)) 'm'];
	axeslabels = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Heat Flux (W/m^2) at ' num2str(znc(i)) 'm Depth']};
	z = squeeze(nc{'Tf'}(1,i,:,:))';
	plotslice(output,z,xnc,ync,axeslabels,termtype);
	output = ['/home/mhoecker/work/Dynamo/plots/run1/Tflux/Temp' num2str(znc(i)) 'm'];
	axeslabels = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Temperature (C) at ' num2str(znc(i)) 'm Depth']};
	z = squeeze(nc{'t'}(1,i,:,:))';
	plotslice(output,z,ync,xnc,axeslabels,termtype);
end
x = squeeze(nc{'Tfmean'}(:));
y = -znc';
minx = min(x);
maxx = max(x);
minxy = y(find(x==min(x)));
maxxy = y(find(x==max(x)));
output = '/home/mhoecker/work/Dynamo/plots/run1/MeanHeatFlux'
axeslabels = {
'Heat Flux (W/m^2)',
'Depth (m)',
'Mean Turbulent Heat Flux',
'set style data filledcurves x1=0',
'set linetype 1 lc rgb "#ffa0a0"',
['set arrow from ' num2str(minx/2) ',' num2str(minxy+7) ' to ' num2str(minx/2) ',' num2str(minxy-7) ' size character 2,20 lw 2 front filled'],
['set arrow from ' num2str(maxx/2) ',' num2str(maxxy-7) ' to ' num2str(maxx/2) ',' num2str(maxxy+7) ' size character 2,20 lw 2 front filled']
}
myplot(output,x,y,axeslabels,termtype);
clear axeslabels
dz = ddz(y);
x = x*dz;
minx = min(x);
maxx = max(x);
meany = mean(y);
output = '/home/mhoecker/work/Dynamo/plots/run1/MeanHeatFluxDiv'
axeslabels = {'Heat Flux Divergence (W/m^3)','Depth (m)','Divergence of Mean Turbulent Heat Flux','set style data filledcurves x1=0','set linetype 1 lc rgb "#a0a0ff"',['set label "Cooling" at ' num2str(minx/2) ',' num2str(meany) ' center front'],['set label "Warming" at ' num2str(maxx/2) ',' num2str(meany) ' center front']
}
myplot(output,x,y,axeslabels,termtype);
ncclose(nc);

