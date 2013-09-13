	function [readme] = cham2NetCDF(inloc,fname,outloc)
#	function [readme] = cham2NetCDF(inloc,fname,outloc)
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
#  fieldnames(cham)
#	[1,1] = depth
#	[2,1] = pmax
#	[3,1] = starttime
#	[4,1] = endtime
#	[5,1] = direction
#	[6,1] = lon
#	[7,1] = lat
#	[8,1] = time
#	[9,1] = castnumber
#	[10,1] = P
#	[11,1] = FALLSPD
#	[12,1] = T
#	[13,1] = TP
#	[14,1] = C
#	[15,1] = T2
#	[16,1] = MHC
#	[17,1] = S
#	[18,1] = THETA
#	[19,1] = SIGMA
#	[20,1] = SIGMA_ORDER
#	[21,1] = N2
#	[22,1] = EPSILON1
#	[23,1] = EPSILON2
#	[24,1] = EPSILON
#	[25,1] = CHI
#	[26,1] = AZ2
#	[27,1] = DTDZ
#	[28,1] = DRHODZ
#	[29,1] = VARAZ
#	[30,1] = VARLT
#	[31,1] = SCAT
#	[32,1] = AX_TILT
#	[33,1] = AY_TILT
#
 size(cham.time)
 size(cham.depth)
 size(cham.EPSILON)
	val = {cham.time(:)-datenum(2011,1,0),cham.depth(:),cham.EPSILON(:),cham.T(:),cham.S(:),cham.CHI(:)};

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
	end%for
#
k=0;
#
# Dimension Variable Title
if((k<Nvar)*(k<Ndim))
	k = k+1;
	vars{k} = 't';
	units{k} = 'd';
	longname{k} = '2011 Julian day';
	dims{k} = vars{k};
endif
if((k<Nvar)*(k<Ndim))
	k = k+1;
	vars{k} = 'z';
	units{k} = 'm';
	longname{k} = '2011 Julian day';
	dims{k} = vars{k};
endif
# Variable Title
if(k<Nvar)
	k = k+1;
	vars{k} = 'epsilon';
	units{k} = 'W/kg';
	dims{k} = [ vars{1} "," vars{2} ];
	longname{k} = 'Average Turbulent dissipation';
	formulae{k} = '';
end%if
if(k<Nvar)
	k = k+1;
	vars{k} = 'T';
	units{k} = 'C';
	dims{k} = [ vars{1} "," vars{2} ];
	longname{k} = 'Temperature';
	formulae{k} = '';
end%if
if(k<Nvar)
	k = k+1;
	vars{k} = 'S';
	units{k} = 'psu';
	dims{k} = [ vars{1} "," vars{2} ];
	longname{k} = 'Salinity';
	formulae{k} = '';
end%if
if(k<Nvar)
	k = k+1;
	vars{k} = 'chi';
	units{k} = 'C^2/s';
	dims{k} = [ vars{1} "," vars{2} ];
	longname{k} = 'Dissipation of temperature variability';
	formulae{k} = '';
end%if
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
fprintf(cdlid,':instrument = "Chameleon";\n');
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
#readme = "";
#fprintf(cdlid,':readme = "%s";\n',readme);
# Declare Data
fprintf(cdlid,'data:\n')
for i=1:Nvar
 y = val{i}(:);
 fprintf(cdlid,'%s =\n',vars{i});
 for j=1:length(y)
  if(isnan(y(j))==1)
   fprintf(cdlid,'NaN');
  else
   fprintf(cdlid,'%20.20g',y(j));
  endif
  if(j<length(y))
   fprintf(cdlid,', ');
  else
   fprintf(cdlid,';\n');
  endif
 endfor
endfor
fprintf(cdlid,'}\n',fname)
fclose(cdlid)
unix(['ncgen -k1 -x -b ' cdffile ' -o ' outfile '&& rm ' cdffile])
endfunction
