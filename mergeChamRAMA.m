function merged = mergeChamRAMA(chamnc,ramanc,mergenc)
%
%
 interp_order = 3;
 if(nargin<1)
  chamnc = "/home/mhoecker/Documents/work/Dynamo/Observations/netCDF/Chameleon/dn11b_sum_clean_v2.nc";
 end%if

 if(nargin<2)
  ramanc = "/home/mhoecker/Documents/work/Dynamo/Observations/netCDF/RAMA/uv_RAMA_0N80E.nc";
 end%if

 if(nargin<3)
  mergenc = "/home/mhoecker/Documents/work/Dynamo/Observations/netCDF/chamRAMA/chamAndRAMA.nc";
 end%if
% Read Cham, get Cham.(S,T,P,Z,t)
 cham = netcdf(chamnc,"r");
 Cham.t = cham{"t"}(:);
 Cham.T = cham{"T"}(:);
 Cham.S = cham{"S"}(:);
 Cham.P = cham{"P"}(:);
 Cham.Z = cham{"z"}(:);
 Cham.lat = cham{"lat"}(:);
 Cham.lon = cham{"lon"}(:);
 ncclose(cham);
% Replace NaN with I
 for [key,val]=Cham
  val = imaginan(val);
 end%for
% Read RAMA get RAMA.(U,V,Z,t,lat,long)
 rama = netcdf(ramanc,"r");
 RAMA.U = rama{"u"}(:);
 RAMA.V = rama{"v"}(:);
 RAMA.t = rama{"t"}(:);
 RAMA.Z = rama{"z"}(:);
 ncclose(rama);
% Replace NaN with I
 for [key,val]=RAMA
  val = imaginan(val);
 end%for
% Convert to Absolute Salinity and conservative temperature (if nec)
 [Cham.SA,Cham.CT] = SA_CT_from_Spsu_Tinsitu(Cham.S,Cham.T,Cham.P,Cham.lat,Cham.lon);
 Cham.SA = imaginan(Cham.SA);
 Cham.CT = imaginan(Cham.CT);
% Determine which is more fine grained (probably Cham)
% and use it for the merged data

 Cham.dt = abs(mean(diff(Cham.t)));
 RAMA.dt = abs(mean(diff(RAMA.t)));
 if(RAMA.dt>Cham.dt)
  merged.t = Cham.t;
 else
  merged.t = RAMA.t;
 end%if

 Cham.dz = abs(mean(diff(Cham.Z)));
 RAMA.dz = abs(mean(diff(RAMA.Z)));
 if(RAMA.dz>Cham.dz)
  merged.z = Cham.Z;
 else
  merged.z = RAMA.Z;
 end%if

% Interpolate the course Z onto the fine z
 RAMAzval = ddzinterp(RAMA.Z,merged.z,interp_order);
% Interpolate the course t onto the fine t
 RAMAtval = ddzinterp(RAMA.t,merged.t,interp_order);
%
 merged.U = RAMAzval*RAMA.U'*RAMAtval';
 merged.V = RAMAzval*RAMA.V'*RAMAtval';

% Interpolate the course Z onto the fine z
 Chamzval = ddzinterp(Cham.Z,merged.z,interp_order);
% Interpolate the course t onto the fine t
 Chamtval = ddzinterp(Cham.t,merged.t,interp_order);

 merged.CT = Chamzval*Cham.CT'*Chamtval';
 merged.SA = Chamzval*Cham.SA'*Chamtval';

% Replace imaginary #s with NaN
 for [key,val]=merged
  val = nanimag(val);
 end%for
% This is a cludge, for some reason some NaNs are mapping to 0
 idxzero = find(merged.SA<1);
 merged.SA(idxzero) = NaN;
 idxzero = find(merged.CT<1);
 merged.CT(idxzero) = NaN;
%
	val = {merged.t(:),merged.z(:),merged.U(:),merged.V(:),merged.CT(:),merged.SA(:)};

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
k=0;

% Dimension Variable Title
if((k<Nvar)*(k<Ndim))
	k = k+1;
	vars{k} = 't';
	units{k} = 'd';
	longname{k} = '2011 Julian day';
	dims{k} = vars{k};
end%if
if((k<Nvar)*(k<Ndim))
	k = k+1;
	vars{k} = 'z';
	units{k} = 'm';
	longname{k} = 'Depth';
	dims{k} = vars{k};
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'U';
 units{k} = 'm/s';
 longname{k} = 'Zonal Velocity';
 dims{k} = [vars{1} "," vars{2}];
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'V';
 units{k} = 'm/s';
 longname{k} = 'Meridional Velocity';
 dims{k} = [vars{1} "," vars{2}];
end%if
if(k<Nvar)
 k = k+1;
  vars{k} = 'CT';
   units{k} = 'C';
    longname{k} = 'Conservative Temperature';
     dims{k} = [vars{1} "," vars{2}];
     end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'SA';
 units{k} = 'ppt';
 longname{k} = 'Absolute Salinity';
 dims{k} = [vars{1} "," vars{2}];
end%if
% Variable Title

%
 tmp = "/home/mhoecker/tmp/";
 fname = "mergeChamRAMA";
 cdffile = [tmp fname '.cdf'];
 cdlid = fopen(cdffile,'w');
 fprintf(cdlid,'netcdf %s {\n', fname);
 fprintf(cdlid,'dimensions:\n');
 for i=1:Ndim
		fprintf(cdlid,'%s=%i;\n',vars{i},length(val{i}));
	endfor
%	Declare variables
	fprintf(cdlid,'variables:\n');
	for i=1:Nvar
		fprintf(cdlid,'double %s(%s);\n',vars{i},dims{i});
	endfor
% Add units, long_name and instrument
fprintf(cdlid,'\n');
for i=1:Nvar
	fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
	fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
	if(length(formulae{i})>0)
		fprintf(cdlid,'%s:formulae = "%s";\n',vars{i},formulae{i});
	endif
endfor
%Declare global attributes
fprintf(cdlid,':source = "%s";\n',[fname '.mat']);
fprintf(cdlid,':instrument = "Chameleon and RAMA mooring";\n');
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
writeCDFdata(cdlid,val,vars)
unix(['ncgen -k1 -x -b ' cdffile ' -o ' mergenc '&& rm ' cdffile])

end%function
