function waterfall(slab_file,wave_file,currents_file,output_dir,termtype)
# function waterfall(slab_file,wave_file,currents_file,output_dir)
# using simulation and observartional data create
# an artificial observatoin time series 
#
# slab_file = netCDF file containing 2-D snapshots
# 	dimensions:
#		time
#		xw Zonal distance
#		zu Depth (0 at surface increasing downward)
#		t_y temperature allong a constant y slice
#
tmp = "/home/mhoecker/tmp/";
if(nargin()<5)
	termtype="";
endif
#
# Import Simulation Data
# 
nc = netcdf(slab_file , 'r');
tnc = nc{'time'}(:);
xnc = nc{'xw'}(:)';
ync = nc{'yu'}(:)';
znc = nc{'zu'}(:);
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
#
ncclose(nc);
#
Tav = zeros(Ntnc);
DTz = zeros(Nxnc,Nync,Ntnc);
rmsTz = zeros(1,Ntnc);
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
Cavg = mean(Cur(1,:)); # Find and average current velocity
#
#Create artificial samples times
#
Ntsam = floor(max(tnc)*Cavg/dxnc);
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
Tymax = max(max(Ty));
Tymin = min(min(Ty));
#
[tx,zz] = meshgrid(tsam,znc);
Nsteps = 8;
lincolors = 'kmbcgr';
Nzstep = floor(Nznc/Nsteps);
#
#
[termtxt,termsfx] = termselect(termtype);
factor(Ntsam)
pieces = max(factor(Ntsam))
if(pieces>Ntsam/pieces)
	pieces=Ntsam/pieces;
endif
chunk =Ntsam/pieces
places = 1+floor(log(pieces)/log(10));
for i=1:pieces
	FakeTfile =  ["Stiched_T-chain" padint2str(i,places)];
	jstart = 1+chunk*(i-1);
	jstop = chunk*i;
	tchunk = tsam(jstart:jstop);
	Tychunk = Ty(:,jstart:jstop);
	binmatrix(tchunk,znc,Tychunk,[tmp FakeTfile ".dat"]);
	fid = fopen([tmp FakeTfile ".plt"],"w");
	fprintf(fid,"set xrange [%f:%f]\n",min(tchunk),max(tchunk));
	fprintf(fid,"set view map\n");
	fprintf(fid,"set pm3d\n");
	fprintf(fid,"set isosamples 128,128\n");
	fprintf(fid,"tri(x) = (x-floor(x))\n");
	fprintf(fid,"set palette mode HSV\n");
	fprintf(fid,"set palette maxcolor 128 function .8*(1-gray),.5+.5*ceil(127./128-gray),.5+.5*floor(127./128+gray)\n");
	fprintf(fid,"unset surface\n");
	fprintf(fid,"set xlabel 'time (s)'\n");
	fprintf(fid,"set ylabel 'depth (m)'\n");
	fprintf(fid,"set cblabel 'Temperature (C)'\n");
	fprintf(fid,"set cbrange [%f:%f]\n",Tymin,Tymax);
	fprintf(fid,"set yrange [*:*] reverse\n");
	fprintf(fid,"set key bmargin\n");
	fprintf(fid,"set key horizontal\n");
	fprintf(fid,"set output '%s'\n",[output_dir FakeTfile termsfx]);
	fprintf(fid,"set term %s\n",termtxt);
	fprintf(fid,"splot '%s' matrix binary lc 'black' notitle\n",[tmp FakeTfile ".dat"]);
#
	fclose(fid);
	unix(["gnuplot " tmp  FakeTfile ".plt"]);
#
	clear tchunk Tychunk jstart jstop	
end
save("-V7",[output_dir FakeTfile ".mat"],"tsam","znc","Ty");
#
eta = Wave.ht; # Wave height in meters
t2 = Wave.time-min(Wave.time); # Time in seconds of wave height measurement
idx = find(~isnan(eta)); # Indecies where eta != NaN
t2g = t2(idx); # times when eta != NaN
etabar = mean(eta(idx)); # Mean Sea Surface height
eta = eta-etabar; # Remove mean
etag = eta(idx); # Measured eta
etaI = interp1 (t2g, etag, t2,'cubic'); # Interpolated eta
#unix(["rm " tmp "*"])
endfunction
