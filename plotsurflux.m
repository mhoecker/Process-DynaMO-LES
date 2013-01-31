function [t] = plotsurflux(ncfile,trange,basename,tmpdir)
# --- User Defined Function: [z,t] = ploturflux(NCFILE)
# --- User Defined Function: [z,t] = ploturflux(NCFILE,TRANGE)
# --- User Defined Function: [z,t] = ploturflux(NCFILE,TRANGE,NAME,TMP)
#
# Plot surface flux data from a netCDF file NCFILE
#
# If TRANGE is ommited or =0
# the entire depth and/or time range is plotted
#
# If the optional argument TRANGE is given 
#there are two possibilities:
#
# 	the length(TRANGE) is 1 and a record
#	of length TRANGE from the start is plotted,
#
# 	otherwise the range plotted is bounded 
#	by  min(TRANGE) and <max(TRANGE).
#
# IF NAME is specified gnuplot is used to create an 
# interactive canvas called NAME.html
# and a PNG file called NAME.png
#
# IF TMP is specified the directory TMP is used as a working directiry
# otherwise temporary files are saved to the current directiry
#
#The header of the netCDF file 
#dimensions:
#	t = 7200 ;
#variables:
#	double t(t) ;
#		t:units = "days" ;
#		t:long_name = "2011 year day at start of average" ;
#	double WS(t) ;
#		WS:units = "meter/second" ;
#		WS:long_name = "Wind Speed" ;
#		WS:instrument = "PSD sonic" ;
#	double WH(t) ;
#		WH:units = "degrees" ;
#		WH:long_name = "Wind Heading Direction wind comes from measured clocwise from True North" ;
#		WH:instrument = "PSD sonic" ;
#	double SST(t) ;
#		SST:units = "Celcius" ;
#		SST:long_name = "Sea Surface Temperature" ;
#		SST:instrument = "Sea Snake" ;
#	double T(t) ;
#		T:units = "Celcius" ;
#		T:long_name = "Temperature" ;
#		T:instrument = "TSG" ;
#	double S(t) ;
#		S:units = "PSU" ;
#		S:long_name = "Salinity" ;
#		S:instrument = "TSG" ;
#	double AT(t) ;
#		AT:units = "Celcius" ;
#		AT:long_name = "Air Temperature" ;
#		AT:instrument = "PSD" ;
#	double SSQ(t) ;
#		SSQ:units = "gram/kilogram" ;
#		SSQ:long_name = "Sea Surface specific humidity" ;
#		SSQ:instrument = "Sea Snake" ;
#	double AQ(t) ;
#		AQ:units = "gram/kilogram" ;
#		AQ:long_name = "Air specific humidity" ;
#		AQ:instrument = "PSD" ;
#	double SWRF(t) ;
#		SWRF:units = "Watt/meter^2" ;
#		SWRF:long_name = "net Short Wave Radiation Flux + = downward (correct by multiplying by 1.01)" ;
#		SWRF:instrument = "PSD" ;
#	double LWRF(t) ;
#		LWRF:units = "Watt/meter^2" ;
#		LWRF:long_name = "incident Long Wave Radiation Flux + = downward" ;
#		LWRF:instrument = "PSD" ;
#	double PR(t) ;
#		PR:units = "mm/hour" ;
#		PR:long_name = "uncorrected Precipitation Rate" ;
#		PR:instrument = "PSD STI optical rain gauge" ;
#	double VS(t) ;
#		VS:units = "m/s" ;
#		VS:long_name = "Vessel Speed" ;
#		VS:instrument = "SCS" ;
#	double VH(t) ;
#		VH:units = "degrees" ;
#		VH:long_name = "Vessel Heading measured clocwise from True North" ;
#		VH:instrument = "SCS" ;
#	double RWS(t) ;
#		RWS:units = "m/s" ;
#		RWS:long_name = "Relative Wind Speed" ;
#		RWS:instrument = "PSD" ;
#	double RWH(t) ;
#		RWH:units = "degrees" ;
#		RWH:long_name = "Relative Wind Heading Direction wind comes from measured clocwise from the bow" ;
#		RWH:instrument = "PSD sonic" ;
#	double lat(t) ;
#		lat:units = "degrees" ;
#		lat:long_name = "Latitude" ;
#		lat:instrument = "SCS pcode" ;
#	double lon(t) ;
#		lon:units = "degrees" ;
#		lon:long_name = "Longitude" ;
#		lon:instrument = "SCS pcode" ;
#	double Zref(t) ;
#		Zref:units = "m" ;
#		Zref:long_name = "Depth for bulk flux Ts reference" ;
#		Zref:instrument = "SCS pcode" ;
#	double VSsd(t) ;
#		VSsd:units = "m/s" ;
#		VSsd:long_name = "standard deviation of Vessel Speed" ;
#		VSsd:instrument = "SCS pcode" ;
#	double Tau(t) ;
#		Tau:units = "Newton/meter^2" ;
#		Tau:long_name = "bulk wind stress magnitude" ;
#	double SF(t) ;
#		SF:units = "Watt/meter^2" ;
#		SF:long_name = "Sensible heat Flux" ;
#	double LF(t) ;
#		LF:units = "Watt/meter^2" ;
#		LF:long_name = "Latent heat Flux" ;
#	double RainF(t) ;
#		RainF:units = "Watt/meter^2" ;
#		RainF:long_name = "Rain heat Flux" ;
#	double TA2(t) ;
#		TA2:units = "Celcius" ;
#		TA2:long_name = "Air Temperature" ;
#		TA2:instrument = "IMET" ;
#	double AQ2(t) ;
#		AQ2:units = "gram/kilogram" ;
#		AQ2:long_name = "Air specific humidity" ;
#		AQ2:instrument = "IMET" ;
#	double VSOG(t) ;
#		VSOG:units = "m/s" ;
#		VSOG:long_name = "Vessel Speed Over Ground" ;
#	double VH2(t) ;
#		VH2:units = "degrees" ;
#		VH2:long_name = "Vessel Heading measured clocwise from True North" ;
#		VH2:instrument = "gyro" ;
#	double SWRF2(t) ;
#		SWRF2:units = "Watt/meter^2" ;
#		SWRF2:long_name = "Solar flux" ;
#		SWRF2:instrument = "ship pyranometer" ;
#	double LWRF2(t) ;
#		LWRF2:units = "Watt/meter^2" ;
#		LWRF2:long_name = "Infrared flux" ;
#		LWRF2:instrument = "ship pirgeometer" ;
#	double P(t) ;
#		P:units = "hectopascal" ;
#		P:long_name = "barometric Pressure" ;
#		P:instrument = "IMET" ;
#	double RH(t) ;
#		RH:units = "" ;
#		RH:long_name = "RHvais" ;
#		RH:instrument = "PSD" ;
#
#// global attributes:
#		:source = "DYNAMO_2011_Leg3_PSD_flux_5min_all.txt" ;
#		:vessel = "R/V Roger Revelle" ;
#		:Flux_Algorithm = "bulk COARE version 3.0" ;
#		:LW_Flux = "Fairall et al. Jtech, 1998." ;
#		:Sea_Snake_Depth = "0.05 meters" ;
#		:TSG_Depth = "5 meters" ;
#		:PSD_Height = "18 meters" ;
#		:PSD_sonic_Height = "18.5 meters" ;
#		:IMET_Height = "21 meters" ;
#
#
nc = netcdf(ncfile,'r');
t = nc{"t"}(:);
z = nc{"z"}(:);
if nargin>1
	if(length(zrange)>1)
		zidx = find((z>min(zrange))&(z<max(zrange)));
	else
		zidx = find(z>=min(z));
	endif
	if nargin>2
		if length(trange)==1
			if(trange==0)
				tidx = find(t>=min(t));
			else
				tidx = find(t<trange+min(t));
			endif
		else
			if(max(trange)<min(t))
				tidx = find((t-min(t)>min(trange))&(t-min(t)<max(trange)));
			else
				tidx = find((t>min(trange))&(t<max(trange)));
			endif
		endif
	else
		tidx = 1:length(t);
	endif
else
	zidx = 1:length(z);
endif
t = t(tidx);
z = z(zidx);
Us = nc{"Us"}(tidx);
Vs = nc{"Vs"}(tidx);
u = nc{"u"}(tidx,zidx)';
v = nc{"v"}(tidx,zidx)';
sizeofu = size(u)
uvnans = isnan(u).+isnan(v);
size(uvnans)
nanatt = sum(uvnans,1);
size(nanatt)
goodtidx = find(nanatt<2*length(z));
tgood = t(goodtidx);
ncclose(nc)
# find NaN replace with 0
idxnan = find(isnan(v));
v(idxnan) = 0;
idxnan = find(isnan(u));
u(idxnan) = 0;
#
utmean = mean(u);
utvar = var(u);
utmeanvar = var(utmean)
umean = mean(utmean)
vtmean = mean(v);
vtvar = var(v);
vtmeanvar = var(vtmean)
vmean = mean(vtmean)
speed = sqrt(u.^2+v.^2);
topspeed = max(max(speed));
umax = max(max(abs(u)));
vmax= max(max(abs(v)));
urange = [-6,6]*sqrt(utmeanvar)+umean
vrange = [-6,6]*sqrt(vtmeanvar)+vmean
tplot = [min(t),max(t)];
zplot = [min(z),max(z)];
[tt,zz] = meshgrid(t,z);
if nargin<3
	subplot(2,2,1)
	plot(t,Us); axis(tplot)
	subplot(2,2,2)
	plot(t,Vs); axis(tplot)
	subplot(2,2,3)
	pcolor(tt,zz,u); axis([tplot,zplot]); caxis(urange); shading flat; colorbar
	subplot(2,2,4)
	pcolor(tt,zz,v); axis([tplot,zplot]); caxis(vrange); shading flat; colorbar
endif
if nargin>2
#Time in the ncfile is in days since Dec 31 1 BCE
#This is 0000 Jan 1 00:00:00 in gnuplot time -(2000*365+485)*24*60*60
day0 = 2000*365+485
#print strftime("%Y-%b-%d %H:%M",-(2000*365+485)*24*60*60)
	width = 1536;
	height = 1024;
	tgnuplot = (t-2-day0)*24*60*60;
	trange = ([min(tgood),max(tgood)]-2-day0)*24*60*60;
	tstep = ceil(length(t)/width);
	tstepsize = abs(t(tstep+1)-t(1))*60*24;
	zstep = ceil(length(z)/height);
	zstepsize = abs(z(zstep+1)-z(1));
	if nargin<4
		tmpdir = '';
	endif
	udatfile = [tmpdir basename 'u.dat'];
	vdatfile = [tmpdir basename 'v.dat'];
	udatid = fopen(udatfile,'w');
	vdatid = fopen(vdatfile,'w');
	fwrite(udatid,length(t),'float');
	fwrite(vdatid,length(t),'float');
	fwrite(udatid,tgnuplot,'float');
	fwrite(vdatid,tgnuplot,'float');
	for  j=1:length(z)
		fwrite(udatid,z(j),'float');
		fwrite(vdatid,z(j),'float');
		fwrite(udatid,squeeze(u(j,:)),'float');
		fwrite(vdatid,squeeze(v(j,:)),'float');
	endfor
	fclose(udatid);
	fclose(vdatid);

	pltfile = [tmpdir basename '.plt']
	pltid = fopen(pltfile,'w');
	fprintf(pltid,'set pm3d\n');
	fprintf(pltid,'set grid\n');
	fprintf(pltid,'unset surface\n');
	fprintf(pltid,'set xdata time\n');
	fprintf(pltid,'set xtics format "%s"\n',"%j");
	fprintf(pltid,'set xlabel "Julian Day"\n');
	fprintf(pltid,'set xrange [%12.10f:%12.10f]\n',min(t),max(t))
	fprintf(pltid,'set ylabel "Depth (m)"\n');
	fprintf(pltid,'set ytics %g,%g,%g\n',min(z),5*zstepsize,max(z));
	fprintf(pltid,'set yrange [%g:0]\n',min(z)-zstepsize)
	fprintf(pltid,'set mytics 5\n');
	fprintf(pltid,'set cblabel "Velocity (m/s)"\n');
	fprintf(pltid,'set title "1 min. avg.every %3.1f min. and %3.1f m"\n',tstepsize,zstepsize);
	fprintf(pltid,'set xrange [%10.5f:%10.5f]\n',trange(1),trange(2))
	fprintf(pltid,'set yrange [%g:0]\n',min(z))
	fprintf(pltid,'set view map\n');
	fprintf(pltid,'set palette mode RGB; set palette function 1-2*sqrt(.25-gray**2),(2*sqrt(.25-(gray-.5)**2)),1-2*sqrt(.25-(1-gray)**2)\n');
	terms = {[' canvas size ' int2str(width) ',' int2str(height) ' jsdir "js" mousing enhanced title "' basename '" linewidth 1']};
	outu = {[' "plots/' basename 'u.html"']};
	outv = {[' "plots/' basename 'v.html"']};
	terms = [terms,[' png size ' int2str(width) ',' int2str(height) ' enhanced linewidth 1']];
	outu = [outu,[' "plots/' basename 'u.png"']];
	outv = [outv,[' "plots/' basename 'v.png"']];
	for j=1:length(terms)
		fprintf(pltid,'set terminal %s\n',terms{j});
		fprintf(pltid,'set output %s\n',outu{j});
		fprintf(pltid,'set cbrange [%g:%g]\n',urange(1),urange(2))
		fprintf(pltid,'splot "%s" binary matrix every %i:%i notitle lc -1 pt 0\n',udatfile,tstep,zstep);
		fprintf(pltid,'set output %s\n',outv{j});
		fprintf(pltid,'set cbrange [%g:%g]\n',vrange(1),vrange(2))
		fprintf(pltid,'splot "%s" binary matrix every %i:%i notitle lc -1 pt 0\n',vdatfile,tstep,zstep);
	endfor
#	fprintf(pltid,'plot x\n',basename);
#plot x
	fclose(pltid)
	unix(['gnuplot ' pltfile])
endif
endfunction
