	function [readme] = adcp2NetCDF(inloc,fname,outloc)
#	function [readme] = adcp2NetCDF(inloc,fname,outloc)
#	inloc = the directory containing the file
#	fname = the base name of the file
#		do not include extension '.mat'
#	outloc = the directory for the netCDF file
#		creates the file FNAME.nc
#
#	uses "/home/mhoecker/tmp/" as a temporay directory
#
#
	tmp = "/home/mhoecker/tmp/";
	infile = [inloc fname '.mat'];
	cdffile = [tmp fname '.cdf'];
	outfile = [outloc fname '.nc'];
	load(infile);
	cdlid = fopen(cdffile,'w');
	fprintf(cdlid,'netcdf %s {\n', fname);
	shear = true;
#  fieldnames(adcp)
#  [1,1] = u
#  [2,1] = v
#  [3,1] = time
#  [4,1] = lat
#  [5,1] = lon
#  [6,1] = uship
#  [7,1] = vship
#  [8,1] = depth
#  [9,1] = ind
#
	val = {adcp.time(:)};
	val = {val{:},-adcp.depth(:)};
	val = {val{:},adcp.uship(:)};
	val = {val{:},adcp.vship(:)};
	val = {val{:},adcp.lat(:)};
	val = {val{:},adcp.lon(:)};
	val = {val{:},adcp.u(:,:)};
	val = {val{:},adcp.v(:,:)};
if(shear)
	dz = ddz(val{2});
#
	u  = val{7};
	idxbad = find(isnan(u));
	u(idxbad) = I*idxbad;
	uz = dz*u;
	clear u;
	idxbad = find(imag(uz)!=0);
	uz = real(uz);
	uz(idxbad) = NaN;
	val = {val{:},uz};
	clear uz;
#
	v  = val{8};
	idxbad = find(isnan(v));
	v(idxbad) = I*idxbad;
	vz = dz*v;
	clear v;
	idxbad = find(imag(vz)!=0);
	vz = real(vz);
	vz(idxbad) = NaN;
	val = {val{:},vz};
	clear vz;
#
	clear dz;
endif
	Nvar = length(val);
	Ndim = 2;
	vars = {};
	longname = {};
	units = {};
	dims = {};
	formulae = {};
	for i=1:Nvar;
		vars = {vars{:},['var' num2str(i)]};
		units = {units{:},'TBD'};
		longname = {longname{:},'TBD'};
		dims = {dims{:},''};
		formulae = {formulae{:},''};
	endfor
#	01 time
vars{1} = 't';
units{1} = 'd';
longname{1} = 'time since 1999 Dec 31 00:00:00';
dims{1} = [vars{1}];
#	02 depth
vars{2} = 'z';
units{2} = 'm';
longname{2} = 'depth';
dims{2} = [vars{2}];
#	03 U ship
vars{3} = 'Us';
units{3} = 'm/s';
longname{3} = 'Ship Zonal Velocity (Eastward>0)';
dims{3} = [vars{1}];
#	04 V Ship
vars{4} = 'Vs';
units{4} = 'm/s';
longname{4} = 'Ship Meridional Velocity (Northward>0)';
dims{4} = [vars{1}];
#	05 Lattitude
vars{5} = 'lat';
units{5} = 'degree_north';
longname{5} = 'Lattitude';
dims{5} = [vars{1}];
#	06 Longitude
vars{6} = 'lon';
units{6} = 'degree_east';
longname{6} = 'Longitude';
dims{6} = [vars{1}];
#	07 u
vars{7} = 'u';
units{7} = 'm/s';
longname{7} = 'Current Zonal Velocity';
dims{7} = [vars{1} ',' vars{2}];
#	08 v
vars{8} = 'v';
units{8} = 'm/s';
longname{8} = 'Current Meridional Velocity';
dims{8} = [vars{1} ',' vars{2}];
#	09 u_z
vars{9} = 'u_z';
units{9} = '1/s';
longname{9} = 'Zonal Current Vertical Shear';
formulae{9} = 'Three point stencil, central difference interior';
dims{9} = [vars{1} ',' vars{2}];
#	10 v_z
vars{10} = 'v_z';
units{10} = '1/s';
longname{10} = 'Meridional Current Ve	rtical Shear';
formulae{10} = 'Three point stencil, central difference interior';
dims{10} = [vars{1} ',' vars{2}];
#
#	Declare Dimensions
	fprintf(cdlid,'dimensions:\n');
	for i=1:Ndim
		fprintf(cdlid,'%s=%i;\n',vars{i},length(val{i}));
	endfor
#	Declare variables
	fprintf(cdlid,'variables:\n');
	for i=1:Nvar
		fprintf(cdlid,'double %s(%s);\n',vars{i},dims{i});
	endfor
# Add units, long_name and instrument
fprintf(cdlid,'\n');
for i=1:Nvar
	fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
	fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
	if(length(formulae{i})>0)
		fprintf(cdlid,'%s:formulae = "%s";\n',vars{i},formulae{i});
	endif
endfor
#Declare global attributes
fprintf(cdlid,':source = "%s";\n',[fname '.mat']);
fprintf(cdlid,':instrument = "ADCP";\n');
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
readme = "In all summary files depth is relative to sea surface.\
  Ship speed dependance should be removed from RDI (Bill).\
  HDSS140 should be re-navigated and then cleaned using existing tag file.\
  After that it should be combined with RDI150, HDSS50 should be navigated, cleaned and combined with RDI75";
fprintf(cdlid,':readme = "%s";\n',readme);
# Declare Data
writeCDFdata(cdlid,val,vars)
#fprintf(cdlid,'data:\n')
#for i=1:Nvar
# y = val{i}(:);
# fprintf(cdlid,'%s =\n',vars{i});
# for j=1:length(y)
#  if(isnan(y(j))==1)
#   fprintf(cdlid,'NaN');
#  else
#   fprintf(cdlid,'%20.20g',y(j));
#  end%if
#  if(j<length(y))
#   fprintf(cdlid,', ');
#  else
#   fprintf(cdlid,';\n');
#  end%if
# end%for
#end%for
#fprintf(cdlid,'}\n',fname)
#fclose(cdlid)
unix(['ncgen -k1 -x -b ' cdffile ' -o ' outfile '&& rm ' cdffile])
endfunction
