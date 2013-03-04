function slabstats(slab_file,output_dir,termtype)
# function slabstats(slab_file,output_dir)
# using simulation 
tmp = "/home/mhoecker/tmp/";
if(nargin<3) 
	termtype="png";
endif
[termtxt,termsfx] = termselect(termtype);
#
# Import Simulation Data
# 
#
#slab_file = "/home/mhoecker/work/les/output/run1/";
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
dxnc = Lx/(Nxnc+1);
#
Dx = xnc-xnc(ceil((Nxnc+1)/2));
Dy = ync-ync(ceil((Nync+1)/2));
idxz=find(Dx==0);
idyz=find(Dy==0);
k = (1:1:Nxnc)-ceil((Nxnc+1)/2);
dk = 2*pi/Lx;
k = k*dk;
l = (1:1:Nync)-ceil((Nync+1)/2);
dl = 2*pi/Ly;
l = l*dl;
m = (1:1:Nznc)-ceil((Nznc+1)/2);
m = m*2*pi/Lz;
#
[xx,yy] = meshgrid(xnc,ync);
[dxx,dyy] = meshgrid(Dx,Dy);
[kk,ll] = meshgrid(k,l);
#
Tync = squeeze(nc{'t_y'}(:));
Tznc = squeeze(nc{'t_z'}(:));
#
ncclose(nc);
#
Tav = zeros(Ntnc);
DTz = zeros(Nxnc,Nync,Ntnc);
rmsTz = zeros(1,Ntnc);
FTz = zeros(Nxnc,Nync,Ntnc);
PTz = zeros(Nxnc,Nync,Ntnc);
RTz = zeros(Nxnc,Nync,Ntnc);
#
places = 1+floor(log(Ntnc)/log(10));
#for i=1:length(tnc)
for i=25
	num = padint2str(i,places);
        tstamp = num2str(tnc(i),"%05.1f");
	Tav(i) = mean(mean(Tznc(i,:,:)));
	DTz(:,:,i) = squeeze(Tznc(i,:,:))- Tav(i);
	rmsTz(i) = sqrt(sum(sum(DTz(i,:,:).^2))/(Nxnc*Nync));
	if(rmsTz(i)==0)
		if(i>1)
			rmsTz(i) = rmsTz(i-1);
		else
			rmsTz(i) = 1;
		endif
	endif
#	printf("Rotating"); tic = time; Tzr = rotate(xnc,ync,DTz(:,:,i),phiavg); tic = time-tic
	FTz(:,:,i) = fftshift(fft2(DTz(:,:,i)));
	PTz(:,:,i) = (abs(FTz(:,:,i))^2)/(Nxnc*Nync);
	RTz(:,:,i) = fftshift(real(ifft2(ifftshift(PTz(:,:,i)))));
	RTz(:,:,i) = (RTz(:,:,i)/max(max(RTz(:,:,i)))).^2;
	RTzx = squeeze(RTz(idxz,:,i));
	R1dmin = 2e-3;
	iRx = find(RTzx>R1dmin/2);
	RTzy = squeeze(RTz(:,idyz,i))';
	iRy = find(RTzy>R1dmin/2);
	PTzmax = max(max(PTz(:,:,i)));
#
	Dtaxlabel = {'Upwind Dist. (m)','Crosswind Dist. (m)',['SST anomaly (C) at t = ' num2str(tnc(i)) 's']};
	plotslice([output_dir "SurfTempStat_SSTA" num],squeeze(DTz(:,:,i))',ync,xnc,Dtaxlabel,termtype);
#
	Paxlabel = {'Upwind Wave # (rad/m)','Crosswind Wave # (rad/m)',['Spectral Density (C^2 m^2 / rad^2) at t =' num2str(tnc(i)) 's'],'set logscale cb',['set cbrange [' num2str(R1dmin/10) ':1]']};
	plotslice([output_dir "SurfTempStat_PSD" num],squeeze(PTz(:,:,i))',l,k,Paxlabel,termtype);
#
	Raxlabel = {'Upwind Dist. (m)','Crosswind Dist. (m)',['Autocorrelation^2 at t =' num2str(tnc(i)) 's'],'set logscale cb',['set cbrange [' num2str(R1dmin/10) ':1]']};
	plotslice([output_dir "SurfTempStat_Rsq" num],squeeze(RTz(:,:,i))',Dy,Dx,Raxlabel,termtype);
	axeslabels = {'Crosswind Distance (m)','Autocorrelation^2',['Conditional Autocorrelation^2 at t =' num2str(tnc(i)) 's'],['set style data filledcurves y1=' num2str(log10(R1dmin))],'set linetype 1 lc rgb "#ffa0a0"','set logscale y',['set yrange [' num2str(R1dmin) ':1]'],'set xrange [0:*]','set label right at graph 1,0 offset character -1,1 "Langmuir Cell Size" front','set arrow from graph 1,0.01 to graph .85,0.01  size character 2,20 filled lw 4 front'};
	myplot([output_dir "SurfTempStat_R1Dx" num],Dx(iRx),RTzx(iRx),axeslabels,termtype);
	axeslabels = {'Upwind Distance (m)','Autocorrelation^2',['Conditional Autocorrelation^2 at t =' num2str(tnc(i)) 's'],['set style data filledcurves y1=' num2str(log10(R1dmin))],'set linetype 1 lc rgb "#a0a0ff"','set logscale y',['set yrange [' num2str(R1dmin) ':1]'],'set xrange [0:*]'};
	myplot([output_dir "SurfTempStat_R1Dy" num],Dy(iRy),RTzy(iRy),axeslabels,termtype);
#
endfor
