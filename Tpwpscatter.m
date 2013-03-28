flux = '/Users/mhoecker/Documents/Dynamo/output/run1/dyno_sw2-a_21600_rst_flux.nc';
nc = netcdf(flux , 'r');
tnc = nc{'time'}(:);
xnc = nc{'xw'}(:)';
ync = nc{'yu'}(:)';
znc = nc{'zu'}(:);
znc = ceil(max(znc))-znc;
termtype = 'pngposter';
for i=1:length(znc)
	x = squeeze(nc{'Tp'}(1,i,:,:))(:)';
	y = squeeze(nc{'wp'}(1,i,:,:))(:)';
	xrange = max(abs(x));
	yrange = max(abs(y));
	r = ones(size(x))*sqrt(xrange*yrange/(length(x)));
	c = ones(size(x))*znc(i);
	output = ['/Users/mhoecker/Documents/Dynamo/plots/run1/Tflux/TWscatter' num2str(znc(i)) 'm'];
	axeslabels = {'T-<T>_{xy}','w-<w>_{xy}',['T-<T>_{xy} and w-<w>_{xy} at ' num2str(znc(i)) 'm Depth'],['set cbrange [' num2str(max(znc)) ':' num2str(min(znc)) '] '],['set zeroaxis lt -1']};
	if(xrange>0)
		axeslabels = {axeslabels{:},['set xrange [' num2str(-xrange) ':' num2str(xrange) ']']};
	end
	if(yrange>0)
		axeslabels = {axeslabels{:},['set yrange [' num2str(-yrange) ':' num2str(yrange) ']']};
	end
	myscatter(output,x,y,r,c,axeslabels,termtype);
	x = squeeze(nc{'ui'}(1,i,:,:))(:)';
	y = squeeze(nc{'wi'}(1,i,:,:))(:)';
	xrange = max(abs(x));
	yrange = max(abs(y));
	r = ones(size(x))*sqrt(xrange*yrange/(length(x)));
	c = ones(size(x))*znc(i);
	output = ['/Users/mhoecker/Documents/Dynamo/plots/run1/momentumflux/UWscatter' num2str(znc(i)) 'm'];
	axeslabels = {'u-<u>_{xy}','w-<w>_{xy}',['u-<u>_{xy} and w-<w>_{xy} at ' num2str(znc(i)) 'm Depth'],['set cbrange [' num2str(max(znc)) ':' num2str(min(znc)) '] '],['set zeroaxis lt -1']};
	if(xrange>0)
		axeslabels = {axeslabels{:},['set xrange [' num2str(-xrange) ':' num2str(xrange) ']']};
	end
	if(yrange>0)
		axeslabels = {axeslabels{:},['set yrange [' num2str(-yrange) ':' num2str(yrange) ']']};
	end
	myscatter(output,x,y,r,c,axeslabels,termtype);
	x = squeeze(nc{'vi'}(1,i,:,:))(:)';
	y = squeeze(nc{'wi'}(1,i,:,:))(:)';
	xrange = max(abs(x));
	yrange = max(abs(y));
	r = ones(size(x))*sqrt(xrange*yrange/(length(x)));
	c = ones(size(x))*znc(i);
	output = ['/Users/mhoecker/Documents/Dynamo/plots/run1/momentumflux/VWscatter' num2str(znc(i)) 'm'];
	axeslabels = {'v-<v>_{xy}','w-<w>_{xy}',['v-<v>_{xy} and w-<w>_{xy} at ' num2str(znc(i)) 'm Depth'],['set cbrange [' num2str(max(znc)) ':' num2str(min(znc)) '] '],['set zeroaxis lt -1']};
	if(xrange>0)
		axeslabels = {axeslabels{:},['set xrange [' num2str(-xrange) ':' num2str(xrange) ']']};
	end
	if(yrange>0)
		axeslabels = {axeslabels{:},['set yrange [' num2str(-yrange) ':' num2str(yrange) ']']};
	end
	myscatter(output,x,y,r,c,axeslabels,termtype);
	x = squeeze(nc{'ui'}(1,i,:,:))(:)';
	y = squeeze(nc{'vi'}(1,i,:,:))(:)';
	xrange = max(abs(x));
	yrange = max(abs(y));
	r = ones(size(x))*sqrt(xrange*yrange/(length(x)));
	c = ones(size(x))*znc(i);
	output = ['/Users/mhoecker/Documents/Dynamo/plots/run1/momentumflux/UVscatter' num2str(znc(i)) 'm'];
	axeslabels = {'u-<u>_{xy}','v-<v>_{xy}',['u-<u>_{xy} and v-<v>_{xy} at ' num2str(znc(i)) 'm Depth'],['set cbrange [' num2str(max(znc)) ':' num2str(min(znc)) '] '],['set zeroaxis lt -1']};
	if(xrange>0)
		axeslabels = {axeslabels{:},['set xrange [' num2str(-xrange) ':' num2str(xrange) ']']};
	end
	if(yrange>0)
		axeslabels = {axeslabels{:},['set yrange [' num2str(-yrange) ':' num2str(yrange) ']']};
	end
	myscatter(output,x,y,r,c,axeslabels,termtype);
end
