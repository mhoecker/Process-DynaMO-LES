function waterfall(slab_file,wave_file,currents_file,output_dir)
# function waterfall(slab_file,wave_file,currents_file,output_dir)
# using simulation and observartional data cre
tmp = "/home/mhoecker/tmp/";
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
Dx = xnc-median(xnc);
Dy = ync-median(ync);
#
[xx,yy] = meshgrid(xnc,ync);
[dxx,dyy] = meshgrid(Dx,Dy);
#
Tync = squeeze(nc{'t_y'}(:));
Tznc = squeeze(nc{'t_z'}(:));
#
ncclose(nc);
#
Tav = zeros(Ntnc);
DTz = zeros(Nxnc,Nync,Ntnc);
rmsTz = zeros(1,Ntnc);
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
	binmatrix(xnc,ync,squeeze(DTz(:,:,i)),DTdat,"w");
	binmatrix(k  ,l  ,squeeze(PTz(:,:,i)),PTdat,"w");
	binmatrix(Dx ,Dy ,squeeze(RTz(:,:,i)),RTdat,"w");
#
	fid = fopen([tmp "SurfTempStat" num ".plt"],"w");
	fprintf(fid,"set term png size 1536,1024 truecolor linewidth 2\n");
	fprintf(fid,"set output '%s'\n",[output_dir "SurfTempStat_gnu" num ".png"]);	
	fprintf(fid,"set view map\n");
	fprintf(fid,"set size ratio -1\n");
	fprintf(fid,"set pm3d\n");
	fprintf(fid,"set multiplot layout 2,2\n");
	fprintf(fid,"set palette mode HSV\n");
	fprintf(fid,"tri(x) = (x-floor(x))\n");
	fprintf(fid,"set palette function %s,%s,%s\n" , '(.5+.5*+tanh(pi*(.5-gray)))*.8' , '.5+.5*tanh(4*pi*(1-gray))', '.5+.5*tanh(4*pi*gray)');
	fprintf(fid,"unset surface\n");
	fprintf(fid,"unset key\n");
#
	fprintf(fid,"set title 'Temp. anomaly (C) at t = %f'\n",tnc(i));
	fprintf(fid,"set xrange [%f:%f]\n",min(xnc),max(xnc));
	fprintf(fid,"set xlabel 'Crosswind Dist. (m)'\n");
	fprintf(fid,"set yrange [%f:%f]\n",min(ync),max(ync));
	fprintf(fid,"set ylabel 'Upwind Dist. (m)'\n");
	fprintf(fid,"set cbrange [-%e:%e]\n",6*rmsTz(i),6*rmsTz(i));
	fprintf(fid,"splot '%s' matrix binary notitle\n",DTdat);
#
	fprintf(fid,"set title 'Spectral Density (C^2 m^2 / rad^2)'\n");
	fprintf(fid,"set xrange [%f:%f]\n",min(k),max(k));
	fprintf(fid,"set yrange [%f:%f]\n",0,max(l));
	fprintf(fid,"set xlabel 'Crosswind Wave # (rad/m)'\n");
	fprintf(fid,"set ylabel 'Upwind Wave # (rad/m)'\n");
	fprintf(fid,"set cbrange [%e:%e]\n",rmsTz(i)/sqrt(Nxnc*Nync),6*rmsTz(i));
	fprintf(fid,"set logscale cb\n");
	fprintf(fid,"set palette function %s,%s,%s\n" , '(1-gray)*.8' , '.5+.5*tanh(4*pi*gray)', '.5+.5*tanh(4*pi*(1-gray))');
	fprintf(fid,"splot '%s' matrix binary notitle\n",PTdat);
#
	fprintf(fid,"set title 'Autocorrelation^2'\n");
	fprintf(fid,"set xrange [%f:%f]\n",min(Dx),max(Dx));
	fprintf(fid,"set yrange [%f:%f]\n",0,max(Dy));
	fprintf(fid,"set xlabel 'Crosswind Dist. (m)'\n");
	fprintf(fid,"set ylabel 'Upwind Dist. (m)'\n");
	fprintf(fid,"set cbrange [%f:1]\n",3/(Nxnc*Nync));
	fprintf(fid,"splot '%s' matrix binary notitle\n",RTdat);
#
	fprintf(fid,"unset colorbox\n");
	fprintf(fid,"set logscale y\n");
	fprintf(fid,"set title 'Conditional Autocorrelation^2'\n");
	fprintf(fid,"set size ratio 0\n");
	fprintf(fid,"set key\n");
	fprintf(fid,"set xrange [%f:%f]\n",0,max(Dx));
	fprintf(fid,"set x2range [%f:%f] reverse\n",0,max(Dy));
	fprintf(fid,"set x2tics\n");
	fprintf(fid,"set yrange [%f:1]\n",3/(Nxnc*Nync));
	fprintf(fid,"set ylabel 'Autocorrelation^2'\n");
	fprintf(fid,"set xlabel 'Crosswind Dist. (m)'\n");
	fprintf(fid,"set x2label 'Upwind Dist. (m)'\n");
	fprintf(fid,"plot '%s' matrix binary u 1:3 every :::192::192 w filledcurves x1 title 'Crosswind', '%s' matrix binary u 2:3 every ::192::192 w impulses axes x2y1 title 'Upwind'\n",RTdat, RTdat);
#
	fclose(fid);
unix(["gnuplot " tmp "SurfTempStat" num ".plt"])
endfor
#
# Import Observations
#
#Wave_file = "Wave_20111124.mat"
#Currents_file = "Nov24.mat"
load(wave_file);
load(currents_file);
#
Cur = [Nov24.cspd;Nov24.cdir,]; # current speed and direction (from as compass heading)
Win = [Nov24.U10;Nov24.wdir]; # current speed and direction (from as compass heading)
phiavg = (pi/180)*sum([Win(2,:)-Cur(2,:)].*sqrt(Win(1,:).^2+Cur(1,:)))/sum(sqrt(Win(1,:).^2+Cur(1,:))); # Weighted mean angle of incidence 
Cavg = mean(Cur(1,:)) # Find and average current velocity

#
#	figure(1)
#	subplot(2,2,1)
#	pcolor(xx,yy,DTz(:,:,i)); 	shading flat; axis([min(xnc),max(xnc),min(ync),max(ync)]); caxis([-.04,.04]); colorbar; title(["Temp. Anomoly (C) at t=" tstamp "(s)"]); xlabel("Cross-wind Dist. (m)"); ylabel("Down-wind Distance (m)")
#	subplot(2,2,2)
#	pcolor(kk,ll,log(PTz(:,:,i))/log(10)); shading flat; axis(2*pi*[-Nxnc/Lx,Nxnc/Lx,-Nync/Ly,Nync/Ly]/5); caxis(log([1e-3,1])/log(10)); colorbar; title("log_{10} Pow. Spec. Den. (C^2 m^2 / rad^2)"); xlabel("Cross-wind Wave-# (rad/m)"); ylabel("Down-wind Wave-# (rad/m)")
#	subplot(2,2,3)
#	pcolor(dxx,dyy,RTz(:,:,i)); shading flat; axis([-Lx,Lx,-Ly,Ly]/5); caxis([0,1]); colorbar; title("Autocorrelation"); xlabel("Cross-wind Dist. (m)"); ylabel("Down-wind Distance (m)")
#	subplot(2,2,4)
#	plot(dxx(Nync/2+1,Nxnc/2+1:Nxnc),RTz(Nync/2+1,Nxnc/2+1:Nxnc,i),";Across-wind;",dyy(Nync/2+1:Nync,Nxnc/2+1),RTz(Nync/2+1:Nync,Nxnc/2+1,i),";Down-wind;"); shading flat; axis([[0,1]*max([Lx,Ly])/2,0,1]); title("Conditional Autocorrelation"); xlabel("Dist. (m)"); ylabel("Autocorrelation")
#	print([output_dir "SurfTempStat" num ".png"],"-dpng","-S1536,1024")
#	close()
endfor
#
#Create artificial samples times
Ntsam = max(tnc)*Cavg/dxnc;
tsam = dxnc/Cavg:dxnc/Cavg:max(tnc);
idxsam = 1:Ntsam;
idxsam = mod(idxsam-1,Nxnc)+1;
Ty = zeros(Nznc,Ntsam);
for i=1:Ntsam
 t1idx = min(find(tnc>tsam(i)));
 t2idx = max(find(tnc<tsam(i)));
 [w1,w2] = weights(tsam(i),tnc(t1idx),tnc(t2idx));
 Ty(:,i) = w1*Tync(t1idx,:,idxsam(i))+w2*Tync(t2idx,:,idxsam(i));
endfor
#
[tx,zz] = meshgrid(tsam,znc);
Nsteps = 8;
lincolors = 'kmbcgr';
Nzstep = floor(Nznc/Nsteps);
#
#figure(Ntnc+1)
#
# subplot(1,1,1)
#  plot(tsam,Ty(Nzstep,:)',[ 'k;' num2str(squeeze(zz(Nzstep,1))) ' m;']); 
#   axis([0,max(tsam),29.0,29.8]);
#   xlabel("time (s)");
#   ylabel("Temperature (C)");
#   hold on;
#    for j=2:Nsteps
#     plot(tsam,squeeze(Ty(j*Nzstep,:))',[lincolors(mod(j-1,6)+1) ';' num2str(squeeze(zz(j*Nzstep,1))) ' m;']); 
#    endfor
#   hold off;
   #
# print([  'Stiched_T-chain.png' ], '-dpng' )
#close
#
binmatrix(tsam,znc,Ty,[output_dir "Stiched_T-chain.dat"],"w");
#fid = fopen("Stiched_T-chain.dat","w");
#plottable = zeros(Nznc+1,Ntsam+1);
#plottable(1,:) = [Ntsam,tsam];
#plottable(2:Nznc+1,1) = znc;
#plottable(2:Nznc+1,2:Ntsam+1) = Ty;
#plottable = plottable';
#fwrite(fid,plottable,'float');
#fclose(fid);
fid = fopen([tmp "Stiched_T-chain.plt"],"w");
fprintf(fid,"set xrange [%f:%f]\n",min(tsam),max(tsam));
fprintf(fid,"set view map\n");
fprintf(fid,"set pm3d\n");
fprintf(fid,"set palette mode HSV\n");
fprintf(fid,"set isosamples 128,128\n");
fprintf(fid,"tri(x) = (x-floor(x))\n");
fprintf(fid,"set palette function %s,%s,%s\n" , '(1-gray)*.8' , '.5*tanh(4*pi*(1-gray))+.5*tri(5*gray)', '.5*tanh(4*pi*(gray))+.5*tri(-5*gray+)');
fprintf(fid,"unset surface\n");
fprintf(fid,"set xlabel 'time (s)'\n");
fprintf(fid,"set key bmargin\n");
fprintf(fid,"set key horizontal\n");
fprintf(fid,"set output '%s'\n",[output_dir "Stiched_T-chain_gnu.png"]);
fprintf(fid,"set term png size 1536,1024 truecolor linewidth 2\n");
fprintf(fid,"splot '%s' matrix binary lc 'black' notitle\n",[output_dir "Stiched_T-chain.dat"]);
#splot 'Stiched_T-chain.dat' matrix binary lc 'black' notitle
#
fclose(fid);
unix(["gnuplot " tmp "Stiched_T-chain.plt"]);
#
save("-V7",[output_dir "Stiched_T-chain.mat"],"tsam","znc","Ty");
#
eta = Wave.ht; # Wave height in meters
t2 = Wave.time-min(Wave.time); # Time in seconds of wave height measurement
idx = find(~isnan(eta)); # Indecies where eta != NaN
t2g = t2(idx); # times when eta != NaN
etabar = mean(eta(idx)); # Mean Sea Surface height
eta = eta-etabar; # Remove mean
etag = eta(idx); # Measured eta
etaI = interp1 (t2g, etag, t2,'cubic'); # Interpolated eta
unix(["rm " tmp "*"])
endfunction
