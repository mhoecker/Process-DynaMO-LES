function RAMAmat2netcdf(inloc,fname,outloc)
# convert RAMA mooring .mat file to netcdf
#
# fieldnames(rama) =
# {
#  [1,1] = u
#  [2,1] = v
#  [3,1] = t
#  [4,1] = z
#  [5,1] = readme
# }
	shear = false;
	tmp = "/home/mhoecker/tmp/";
	infile = [inloc fname '.mat'];
	cdffile = [tmp fname '.cdf'];
	outfile = [outloc fname '.nc'];
	# open mat file
	load(infile);
	# start wriing cdf file
	cdlid = fopen(cdffile,'w');
	fprintf(cdlid,'netcdf %s {\n', fname);
	#
 Nz = length(rama.z);
 Nt = length(rama.t);
 rama.u = reshape(rama.u,Nt,Nz)';
 rama.v = reshape(rama.v,Nt,Nz)';
	#
 val = {rama.t(:)-datenum(2011,1,0)};
 val = {val{:},-rama.z(:)};
 val = {val{:},rama.u(:)};
 val = {val{:},rama.v(:)};
 if(shear)
  dz = ddz(val{2});
  #
  u  = val{3};
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
  v  = val{4};
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
 end%if
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
 #	01 time
 vars{1} = 't';
 units{1} = 'd';
 longname{1} = '2011 yearday';
 dims{1} = [vars{1}];
 #	02 depth
 vars{2} = 'z';
 units{2} = 'm';
 longname{2} = 'depth';
 dims{2} = [vars{2}];
 #	03 u
 vars{3} = 'u';
 units{3} = 'm/s';
 longname{3} = 'Current Zonal Velocity';
 dims{3} = [vars{1} ',' vars{2}];
 #	04 v
 vars{4} = 'v';
 units{4} = 'm/s';
 longname{4} = 'Current Meridional Velocity';
 dims{4} = [vars{1} ',' vars{2}];
 if(shear)
  #	05 u_z
  vars{5} = 'u_z';
  units{5} = '1/s';
  longname{5} = 'Zonal Current Vertical Shear';
  formulae{5} = 'Three point stencil, central difference interior';
  dims{5} = [vars{1} ',' vars{2}];
  #	06 v_z
  vars{6} = 'v_z';
  units{6} = '1/s';
  longname{6} = 'Meridional Current Ve	rtical Shear';
  formulae{6} = 'Three point stencil, central difference interior';
  dims{6} = [vars{1} ',' vars{2}];
  #
 end%if
 #
 #	Declare Dimensions
 fprintf(cdlid,'dimensions:\n');
 for i=1:Ndim
  fprintf(cdlid,'%s=%i;\n',vars{i},length(val{i}));
 end%for
 #Declare variables
 fprintf(cdlid,'variables:\n');
 for i=1:Nvar
  fprintf(cdlid,'double %s(%s);\n',vars{i},dims{i});
 end%for
 # Add units, long_name and instrument
 fprintf(cdlid,'\n');
 for i=1:Nvar
  fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
  fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
  if(length(formulae{i})>0)
   fprintf(cdlid,'%s:formulae = "%s";\n',vars{i},formulae{i});
  end%if
 end%for
 #Declare global attributes
 fprintf(cdlid,':source = "%s";\n',[fname '.mat']);
 readme = strtrim(rama.readme(5,:));
 fprintf(cdlid,':readme = "%s";\n',readme);
 # Declare Data
 writeCDFdata(cdlid,val,vars)
 unix(['ncgen -k1 -x -b ' cdffile ' -o ' outfile '&& rm ' cdffile])
end%function
