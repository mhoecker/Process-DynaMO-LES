function slabstats(slab_file,output_dir,termtype)
# function slabstats(slab_file,output_dir)
# using simulation 
tmp = "/home/mhoecker/tmp/";
if(nargin<3) 
	termtype="png";
endif
[temtxt,termsfx] = termselect(termtype);
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
k = (1:1:Nxnc)-ceil((Nxnc+1)/2);
k = k*2*pi/Lx;
l = (1:1:Nync)-ceil((Nync+1)/2);
l = l*2*pi/Ly;
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
for i=1:Ntnc
	num = num2str(i);
	if(i<10)
		num = ["0" num];
        endif
        tstamp = num2str(tnc(i));
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
#
	DTdat = [tmp "SurfTempAnomoly" num ".dat"];
	PTdat = [tmp "SurfTempPSD" num ".dat"];
	RTdat = [tmp "SurfTempR" num ".dat"];
	RTtdat = [tmp "SurfTempRt" num ".dat"];
	binmatrix(xnc,ync,squeeze(DTz(:,:,i)),DTdat,"w");
	binmatrix(k  ,l  ,squeeze(PTz(:,:,i)),PTdat,"w");
	binmatrix(Dx ,Dy ,squeeze(RTz(:,:,i)),RTdat,"w");
	binmatrix(Dy ,Dx ,squeeze(RTz(:,:,i))',RTtdat,"w");
#
	fid = fopen([tmp "SurfTempStat" num ".plt"],"w");
#
	fprintf(fid,"set terminal %s\n",termtxt);
	fprintf(fid,"set output '%s'\n",[output_dir "SurfTempStat_SSTA" num termsfx]);	
	fprintf(fid,"set view map\n");
	fprintf(fid,"set size ratio -1\n");
	fprintf(fid,"set pm3d\n");
	fprintf(fid,"set palette mode HSV\n");
	fprintf(fid,"tri(x) = (x-floor(x))\n");
	fprintf(fid,"set palette function %s,%s,%s\n" , '(.5+.5*+tanh(pi*(.5-gray)))*.8' , '.5+.5*tanh(4*pi*(1-gray))', '.5+.5*tanh(4*pi*gray)');
	fprintf(fid,"unset surface\n");
	fprintf(fid,"unset key\n");
#
	fprintf(fid,"set title 'SST anomaly (C) at t = %gs'\n",tnc(i));
	fprintf(fid,"set xrange [%f:%f]\n",min(xnc),max(xnc));
	fprintf(fid,"set xlabel 'Crosswind Dist. (m)'\n");
	fprintf(fid,"set yrange [%f:%f]\n",min(ync),max(ync));
	fprintf(fid,"set ylabel 'Upwind Dist. (m)'\n");
	fprintf(fid,"set cbrange [-%e:%e]\n",5*rmsTz(i),5*rmsTz(i));
	fprintf(fid,"splot '%s' matrix binary notitle\n",DTdat);
#
	fprintf(fid,"set output '%s'\n",[output_dir "SurfTempStat_PSD" num termsfx]);	
	fprintf(fid,"set title 'Spectral Density (C^2 m^2 / rad^2) at t = %g'\n",tnc(i));
	fprintf(fid,"set xrange [%f:%f]\n",min(k)/3,max(k)/3);
	fprintf(fid,"set yrange [%f:%f]\n",0,max(l)/2);
	fprintf(fid,"set xlabel 'Crosswind Wave # (rad/m)'\n");
	fprintf(fid,"set ylabel 'Upwind Wave # (rad/m)'\n");
	fprintf(fid,"set cbrange [%e:%e]\n",6*rmsTz(i)/sqrt(Nxnc*Nync),3*rmsTz(i));
	fprintf(fid,"set logscale cb\n");
	fprintf(fid,"set palette function %s,%s,%s\n" , '(1-gray)*.8' , '.5+.5*tanh(4*pi*gray)', '.5+.5*tanh(4*pi*(1-gray))');
	fprintf(fid,"splot '%s' matrix binary notitle\n",PTdat);
#
	fprintf(fid,"set output '%s'\n",[output_dir "SurfTempStat_Rsq" num termsfx]);	
	fprintf(fid,"set title 'Autocorrelation^2 at t = %gs'\n",tnc(i));
	fprintf(fid,"set xrange [%f:%f]\n",min(Dx)/2,max(Dx)/2);
	fprintf(fid,"set yrange [%f:%f]\n",0,max(Dy));
	fprintf(fid,"set xlabel 'Crosswind Dist. (m)'\n");
	fprintf(fid,"set ylabel 'Upwind Dist. (m)'\n");
	fprintf(fid,"set cbrange [%f:1]\n",6/(Nxnc*Nync));
	fprintf(fid,"splot '%s' matrix binary notitle\n",RTdat);
#
	fprintf(fid,"unset title\n");
	fprintf(fid,"unset colorbox\n");
	fprintf(fid,"set output '%s'\n",[output_dir "SurfTempStat_R1D" num termsfx]);
	fprintf(fid,"set multiplot layout 2,1 title 'Conditional Autocorrelation^2 at t = %gs'\n",tnc(i));
	fprintf(fid,"set logscale y\n");
	fprintf(fid,"set size ratio 0\n");
	fprintf(fid,"set key\n");
	fprintf(fid,"set xrange [%f:%f]\n",0,max(Dx));
	fprintf(fid,"set yrange [%f:1]\n",6/(Nxnc*Nync));
	fprintf(fid,"set ylabel 'Autocorrelation^2'\n");
	fprintf(fid,"set xlabel 'Crosswind Dist. (m)'\n");
	fprintf(fid,"plot '%s' matrix binary u 1:3:3 every :::192::192 w linespoints title 'Crosswind' lw 2 pt 1 ps 2\n",RTdat);
	fprintf(fid,"set xrange [%f:%f]\n",0,max(Dy));
	fprintf(fid,"set yrange [%f:1]\n",6/(Nxnc*Nync));
	fprintf(fid,"set ylabel 'Autocorrelation^2'\n");
	fprintf(fid,"set xlabel 'Upwind Dist. (m)'\n");
	fprintf(fid,"plot '%s' matrix binary u 1:3:3 every :::192::192 w linespoints title 'Upwind' lt 2 lw 2 pt 8 ps 2\n",RTtdat);
#
	fclose(fid);
unix(["gnuplot " tmp "SurfTempStat" num ".plt"])
unix(["rm " tmp "SurfTempStat" num ".plt" " " RTdat " " PTdat " " DTdat " " RTtdat])
endfor
