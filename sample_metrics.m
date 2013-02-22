function sample_metrics(slab_file)
#
# Import Simulation Data
#
tmp = "/home/mhoecker/tmp/";

#slab_file = "/home/mhoecker/work/les/output/run1/dyno_sw2-a_slb.nc";
nc = netcdf(slab_file , 'r');
tnc = nc{'time'}(:);
xnc = nc{'xw'}(:)';
ync = nc{'yu'}(:)';
znc = -nc{'zu'}(:);
#
Ntnc = length(tnc);
Nxnc = length(xnc);
Nync = length(ync);
Nznc = length(znc);
#
Lx = (max(xnc)-min(xnc))*(Nxnc+1)/(Nxnc);
Ly = (max(ync)-min(ync))*(Nync+1)/(Nync);
Lz = (max(znc)-min(znc))*(Nznc+1)/(Nznc);
#
dxnc = mean(diff(xnc));
dync = mean(diff(ync));
dznc = mean(diff(znc));
#
ddx = toeplitz([0,-1,zeros(1,Nxnc-3),1],[0,1,zeros(1,Nxnc-3),-1])/(2*dxnc);
ddy = toeplitz([0,-1,zeros(1,Nync-3),1],[0,1,zeros(1,Nync-3),-1])/(2*dync);
ddz = toeplitz([0,-1,zeros(1,Nznc-3),1],[0,1,zeros(1,Nznc-3),-1])/(2*dznc);
ddz(1,1) = -1/dznc;
ddz(1,2) = 1/dznc;
ddz(1,Nznc)= 0;
ddz(Nznc,1) = 0;
ddz(Nznc,Nznc) = 1/dznc;
ddz(Nznc,Nznc-1) = -1/dznc;
#
k = (1:1:Nxnc)-ceil(Nxnc/2);
k = k*2*pi/Lx;
l = (1:1:Nync)-ceil(Nync/2);
l = l*2*pi/Ly;
m = (1:1:Nznc)-ceil(Nznc/2);
m = m*2*pi/Lz;
#
[yx,zx] = meshgrid(ync,znc);
[xy,zy] = meshgrid(xnc,znc);
[xz,yz] = meshgrid(xnc,ync);
#
[ky,lx] = meshgrid(k,l);
[kz,zx] = meshgrid(k,znc);
[lz,zy] = meshgrid(l,znc);
#
Txnc = squeeze(nc{'t_x'}(:));
Tync = squeeze(nc{'t_y'}(:));
Tznc = squeeze(nc{'t_z'}(:));
Txncmean = squeeze(mean(Txnc,3));
Tyncmean = squeeze(mean(Tync,3));
#
ncclose(nc);
#
for i=1:Ntnc
	num = num2str(i);
	if(i<100)
		num = ["0" num];
		if(i<10)
			num = ["0" num];
		endif
	endif
	
	Tx = squeeze(Txnc(i,:,:));
	Ty = squeeze(Tync(i,:,:));
	Tz = squeeze(Tznc(i,:,:));
	Txbar = squeeze(Txncmean(i,:));
	Tybar = squeeze(Tyncmean(i,:));
	Tybardz = ddz*Txbar';
	figure
#	subplot(2,2,1); pcolor(xz,yz,Tz); shading flat; axis([min(xnc),max(xnc),min(ync),max(ync)]); caxis([28,30])
#	subplot(2,2,2); pcolor(xy,zy,Ty); shading flat; axis([min(xnc),max(xnc),min(znc),max(znc)]); caxis([28,30])
#	subplot(2,2,3); pcolor(yx,zx,Tx); shading flat; axis([min(ync),max(ync),min(znc),max(znc)]); caxis([28,30])
	subplot(2,2,1); plot(Txbar,znc); axis([28,30]);
	subplot(2,2,2); plot(Tybar,znc); axis([28,30]);
	subplot(2,2,3); plot(ddz*Txbar',znc); axis([0,.14]);
	subplot(2,2,4); plot(ddz*Tybar',znc); axis([0,.14]);
	print(["slabs" num ".png"],"-dpng")
	close
endfor
endfunction
