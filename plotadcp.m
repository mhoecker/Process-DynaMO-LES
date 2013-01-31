function  fields = plotadcp(ncfile,zrange,trange,basename,tmpdir)
# --- User Defined Function: [z,t] = plotadcp(NCFILE)
# --- User Defined Function: [z,t] = plotadcp(NCFILE,ZRANGE)
# --- User Defined Function: [z,t] = plotadcp(NCFILE,ZRANGE,TRANGE)
# --- User Defined Function: [z,t] = plotadcp(NCFILE,ZRANGE,TRANGE,NAME,TMP)
#
# Plot adcp data from a netCDF file NCFILE.
#
# If ZRANGE and/or TRANGE are ommited
#the entire depth and/or time range is plotted
#
# If the optional argument ZRANGE is given
#only the data which falls within min(ZRANGE)
#and max(ZRANGE) is plotted.
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
#
# IF TMP is specified the directory TMP is used as a working directiry
# otherwise the current directiry is used as a working
#
# The header of the netCDF
#dimensions:
#	t = 43560 ;
#	z = 55 ;
#variables:
#	double t(t) ;
#		t:units = "s" ;
#		t:long_name = "time" ;
#	double z(z) ;
#		z:units = "m" ;
#		z:long_name = "depth" ;
#	double Us(t) ;
#		Us:units = "m/s" ;
#		Us:long_name = "Ship Zonal Velocity (Eastward>0)" ;
#	double Vs(t) ;
#		Vs:units = "m/s" ;
#		Vs:long_name = "Ship Meridional Velocity (Northward>0)" ;
#	double lat(t) ;
#		lat:units = "deg" ;
#		lat:long_name = "Lattitude" ;
#	double lon(t) ;
#		lon:units = "deg" ;
#		lon:long_name = "Longitude" ;
#	double u(t, z) ;
#		u:units = "m/s" ;
#		u:long_name = "Current Zonal Velocity" ;
#	double v(t, z) ;
#		v:units = "m/s" ;
#		v:long_name = "Current Meridional Velocity" ;
#
#// global attributes:
#		:source = "adcp150_filled_with_140.mat" ;
#		:instrument = "ADCP" ;
#		:vessel = "R/V Roger Revelle" ;
#		:readme = "In all summary files depth is relative to sea surface.  Ship speed dependance should be removed from RDI (Bill).  HDSS140 should be re-navigated and then cleaned using existing tag file.  After that it should be combined with RDI150, HDSS50 should be navigated, cleaned and combined with RDI75" ;
#
#
nc = netcdf(ncfile,'r');
t = nc{"t"}(:);
z = nc{"z"}(:);
plotshear = true;
width = 1408;
height = 1024;
if nargin>1
	if(length(zrange)>1)
		zidx = find((z>=min(zrange))&(z<=max(zrange)));
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
Nt = length(t);
tstep = ceil(1.5*Nt/width);
tstepsize = abs(t(tstep+1)-t(1))*60*24;
t = t(1:tstep:Nt);
#
z = z(zidx);
Nz = length(z);
zstep = ceil(1.5*Nz/height);
zstepsize = abs(z(zstep+1)-z(1));
z = z(1:zstep:Nz);
#
Us = nc{"Us"}(tidx);
Us = Us(1:tstep:Nt);
#
Vs = nc{"Vs"}(tidx);
Vs = Vs(1:tstep:Nt);
#
u = nc{"u"}(tidx,zidx)';
u = u(1:zstep:Nz,1:tstep:Nt);
#
v = nc{"v"}(tidx,zidx)';
v = v(1:zstep:Nz,1:tstep:Nt);
#
uz = nc{"u_z"}(tidx,zidx)';
uz = uz(1:zstep:Nz,1:tstep:Nt);
#
vz = nc{"v_z"}(tidx,zidx)';
vz = vz(1:zstep:Nz,1:tstep:Nt);
#
ncclose(nc);
uvnans = isnan(u).+isnan(v);
nanatt = sum(uvnans,1);
goodtidx = find(nanatt<2*length(z));
tgood = t(goodtidx);
fieldname = {'u','v','u_z','v_z'};
fields = {u v uz vz};
clear u v uz vz;
dims = {z,t};
clear z t;
#
if(plotshear)
	fieldname = {fieldname{:},'Ssq'};
	Ssq = fields{3}.^2+fields{4}.^2;
	idxbad = find(isnan(fields{3}).*isnan(fields{4}));
	Ssq(idxbad) = NaN;
	fields = {fields{:},Ssq};
	clear Ssq;
endif
#
tmeans = {};
ztmeans = {};
zvars = {};
trmszvars = {};
ranges = {};
for i=1:length(fields)
	idxgood = find(~isnan(fields{i}));
	tmeans = {tmeans{:},mean(fields{i}(idxgood))};
	ztmeans = {ztmeans{:},mean(tmeans{i})};
	zvars = {zvars{:},var(fields{i}(idxgood),1)};
	trmszvars = {trmszvars{:},sqrt(mean(zvars{i}))};
	Nstd = 2;
	if (i==5)
#		ranges = {ranges{:},[trmszvars{i},ztmeans{i}+Nstd*trmszvars{i}]};
		ranges = {ranges{:},[ztmeans{i}/Nstd^3,ztmeans{i}*Nstd^3]};
	else
			ranges = {ranges{:},[-abs(ztmeans{i})-Nstd*trmszvars{i},abs(ztmeans{i})+Nstd*trmszvars{i}]};
	endif
endfor
ranges
#
for i=1:length(dims)
	dimrange = [min(dims{i}),max(dims{i})];
endfor
[tt,zz] = meshgrid(dims{2},dims{1});
if nargin>2
#Time in the ncfile is in days since Dec 31 1 BCE
#This is 0000 Jan 1 00:00:00 in gnuplot time -(2000*365+485)*24*60*60
day0 = 2000*365+485;
#print strftime("%Y-%b-%d %H:%M",-(2000*365+485)*24*60*60)
	tgnuplot = (dims{2}-1-day0)*24*60*60;
	trange = ([min(tgood),max(tgood)]-1-day0)*24*60*60;
	if nargin<4
		tmpdir = '';
	endif
#
#
	cblabel = {        ['set cblabel " E/W Velocity (m/s)"\n']};
	cblabel = [cblabel ['set cblabel "N/S Velocity (m/s)"\n']];
	cblabel = [cblabel ['set cblabel "E/W Shear (s^{-1})"\n']];
	cblabel = [cblabel ['set cblabel "N/S Shear (s^{-1})"\n']];
	if(plotshear)
		cblabel = [cblabel ['set cblabel "Shear^2 (s^{-2})"\nset logscale cb\n']]; #set autoscale cb\n
	endif
#
	pmpalette = ['set palette maxcolors 63 mode RGB; set palette function 1-2*sqrt(.25-gray**2),sqrt(1-2*abs(gray-.5)),1-2*sqrt(.25-(1-gray)**2)\n'] ;
	pdpalette = ['set palette maxcolors 63 mode HSV; set palette function .8*gray,1,1\n'];
	palette = {pmpalette};
	palette = {palette{:}, pmpalette };
	palette = {palette{:}, pmpalette };
	palette = {palette{:}, pmpalette };
	if(plotshear)
		palette = {palette{:}, pdpalette };
	endif
#
#
	for k=1:length(fields)
		datfile = [tmpdir basename '.dat'];
		datid = fopen(datfile,'w');
		fwrite(datid,length(dims{2}),'float');
		fwrite(datid,tgnuplot,'float');
		for  j=1:length(dims{1})
			fwrite(datid,dims{1}(j),'float');
			fwrite(datid,squeeze(fields{k}(j,:)),'float');
		endfor
		fclose(datid);
		pltfile = [tmpdir basename '.plt'];
		pltid = fopen(pltfile,'w');
		fprintf(pltid,'set pm3d\n');
		fprintf(pltid,'set pm3d corners2color median\n');
		fprintf(pltid,'set grid\n');
		fprintf(pltid,'unset surface\n');
		fprintf(pltid,'set xdata time\n');
		fprintf(pltid,'set xlabel "Julian Day (GMT)" offset 0,0\n');
		fprintf(pltid,'set xrange [%12.10f:%12.10f]\n',trange(1),trange(2))
		fprintf(pltid,'set ylabel "Depth (m)" offset 1,0\n');
		fprintf(pltid,'set yrange [%g:%g]\n',min(dims{1}),max(dims{1}))
		fprintf(pltid,'set ytics %g,%g,%g out  offset 1,0\n',min(dims{1}),5*zstepsize,max(dims{1}));
		fprintf(pltid,'set mytics 5\n');
		fprintf(pltid,'set title "1 min. avg.every %3.1f min. and %3.1f m"\n',tstepsize,zstepsize);
		fprintf(pltid,'set xrange [%10.5f:%10.5f]\n',trange(1),trange(2))
		if(tstepsize<6*60)
			if(tstepsize<30)
				if(tstepsize<10)
					fprintf(pltid,'set xtics out format "%s"\n','%jd_{%Hh}');
					fprintf(pltid,'set xtics %g,%g,%g out offset 0,0\n',floor(trange(1)/(60*60*24))*24*60*60,12*60*60,ceil(trange(2)/(24*60*60))*24*60*60);
					fprintf(pltid,'set mxtics 12\n');
				else
					fprintf(pltid,'set xtics out format "%s"\n','%jd');
					fprintf(pltid,'set xtics %g,%g,%g out offset 0,0\n',floor(trange(1)/(24*60*60))*24*60*60,24*60*60,ceil(trange(2)/(24*60*60))*24*60*60);
					fprintf(pltid,'set mxtics 6\n');
				endif
			else
				fprintf(pltid,'set xtics out format "%s"\n','%j');
				fprintf(pltid,'set xtics %g,%g,%g out offset .5,.5\n',floor(trange(1)/(60*60*24))*60*60*24,2*24*60*60,ceil(trange(2)/(60*60*24))*60*60*24);
				fprintf(pltid,'set mxtics 12\n');
			endif
		else
			fprintf(pltid,'set xtics out format "%s"\n','%j');
		endif
		fprintf(pltid,'set view map\n');
		fprintf(pltid,'set border 14\n');
		fprintf(pltid,'set colorbox horizontal user origin 0,0 size 1,.01\n');
		fprintf(pltid,'set rmargin at screen .95\n');
		fprintf(pltid,'set lmargin at screen .075\n');
		fprintf(pltid,'set tmargin at screen .95\n');
		fprintf(pltid,'set bmargin at screen .15\n');
		fprintf(pltid,'set colorbox horizontal user origin .05,.05 size .9,.01\n');
		fprintf(pltid,'set cbtics nomirror\n')
		fprintf(pltid,'set cbrange [%g:%g]\n',ranges{k}(1),ranges{k}(2))
		fprintf(pltid,'set cblabel offset 0,.5\n')
		fprintf(pltid,cblabel{k});
		fprintf(pltid,palette{k});
		terms = {[' canvas size ' int2str(width) ',' int2str(height) ' jsdir "js" mousing enhanced title "' basename '" linewidth 1']};
		terms = {terms{:},[' png size ' int2str(width) ',' int2str(height) ' enhanced linewidth 1']};
		out = {[' "plots/' basename fieldname{k} '.html"']};
		out = {out{:},[' "plots/' basename fieldname{k} '.png"']};
		for j=1:length(terms)
			fprintf(pltid,'set terminal %s\n',terms{j});
			fprintf(pltid,'set output %s\n',out{j});
			fprintf(pltid,'splot "%s" binary matrix notitle lc -1 pt 0\n',datfile);
		endfor
		fclose(pltid)
		unix(['gnuplot ' pltfile ])#' && rm ' datfile ])#' && rm ' pltfile])
	endfor
endif
endfunction
