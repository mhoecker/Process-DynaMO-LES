ncdir   = "/home/mhoecker/work/Dynamo/Observations/netCDF/chamRAMA/"
mergenc = [ncdir "chamAndRAMA.nc"];
isoPnc = [ncdir "isoPchamAndRAMA.nc"];
pltdir  = "/home/mhoecker/work/Dynamo/plots/isopycnals/";


mergec = netcdf(mergenc,"r");
t = mergec{"t"}(:);
tidx = inclusiverange(t,[325,333]);
z = mergec{"z"}(:);
zidx = inclusiverange(z,[-100,0]);
t = mergec{"t"}(tidx);
dt = mean(diff(t));
z = mergec{"z"}(zidx);
dz = mean(diff(z));
zmax = max(z);
zmin = min(z);
u = mergec{"U"}(tidx,zidx);
v = mergec{"V"}(tidx,zidx);
ct = mergec{"CT"}(tidx,zidx);
sa = mergec{"SA"}(tidx,zidx);
ncclose(mergec);
% sub sample time and depth
ds = 2*dt;
s = min(t):ds:max(t);
[zz,ss] = meshgrid(z,s);
%
U  = 0*zz;
V  = U;
CT = U;
SA = U;
% filter data using 2*ds to fill small gaps
fill_order = 3;
for i=1:length(z)
 U(:,i)  = harmfill(u(:,i) ,t,s,fill_order,2*ds);
 V(:,i)  = harmfill(v(:,i) ,t,s,fill_order,2*ds);
 CT(:,i) = harmfill(ct(:,i),t,s,fill_order,2*ds);
 SA(:,i) = harmfill(sa(:,i),t,s,fill_order,2*ds);
end%for

Urange = [min(min(U)),max(max(U))];
Vrange = [min(min(V)),max(max(V))];
CTrange = [min(min(CT)),max(max(CT))];
SArange = [min(min(SA)),max(max(SA))];
binmatrix(s,z,U' ,[pltdir "Uin.dat" ]);
binmatrix(s,z,V' ,[pltdir "Vin.dat" ]);
binmatrix(s,z,CT',[pltdir "CTin.dat"]);
binmatrix(s,z,SA',[pltdir "SAin.dat"]);

isoP=isopycnalize(s,z',U,V,SA,CT);

% filter data using T=3days to remove tides
fill_order = 4;
for i=1:length(isoP.rho_cords)
 isoP.zbar(:,i)  = harmfill(isoP.z(:,i) ,isoP.t,isoP.t,fill_order,3);
 isoP.Ubar(:,i)  = harmfill(isoP.U(:,i) ,isoP.t,isoP.t,fill_order,3);
 isoP.Vbar(:,i)  = harmfill(isoP.V(:,i) ,isoP.t,isoP.t,fill_order,3);
 isoP.CTbar(:,i) = harmfill(isoP.CT(:,i),isoP.t,isoP.t,fill_order,3);
 isoP.SAbar(:,i) = harmfill(isoP.SA(:,i),isoP.t,isoP.t,fill_order,3);
end%for


binmatrix(isoP.t,z             ,isoP.rho',[pltdir "rhoout.dat"]);
binmatrix(isoP.t,isoP.rho_cords,isoP.z'  ,[pltdir "Zout.dat"  ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.U'  ,[pltdir "Uout.dat"  ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.V'  ,[pltdir "Vout.dat"  ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.CT' ,[pltdir "CTout.dat" ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.SA' ,[pltdir "SAout.dat" ]);

%
	val = {isoP.rho_cords(:),isoP.t(:),isoP.U(:),isoP.V(:),isoP.CT(:),isoP.SA(:),isoP.z(:),isoP.Ubar(:),isoP.Vbar(:),isoP.CTbar(:),isoP.SAbar(:),isoP.zbar(:)};

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
	vars{k} = 'rho';
	units{k} = 'kg/m^3';
	longname{k} = 'Density';
	dims{k} = vars{k};
end%if
if((k<Nvar)*(k<Ndim))
	k = k+1;
	vars{k} = 't';
	units{k} = 'd';
	longname{k} = '2011 Julian day';
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
if(k<Nvar)
 k = k+1;
 vars{k} = 'z';
 units{k} = 'm';
 longname{k} = 'Depth';
 dims{k} = [vars{1} "," vars{2}];
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'Ubar';
 units{k} = 'm/s';
 longname{k} = 'Low Pass Filtered Zonal Velocity';
 dims{k} = [vars{1} "," vars{2}];
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'Vbar';
 units{k} = 'm/s';
 longname{k} = 'Low Pass Filtered Meridional Velocity';
 dims{k} = [vars{1} "," vars{2}];
end%if
if(k<Nvar)
 k = k+1;
  vars{k} = 'CTbar';
   units{k} = 'C';
    longname{k} = 'Low Pass Filtered Conservative Temperature';
     dims{k} = [vars{1} "," vars{2}];
     end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'SAbar';
 units{k} = 'ppt';
 longname{k} = 'Low Pass Filtered Absolute Salinity';
 dims{k} = [vars{1} "," vars{2}];
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'zbar';
 units{k} = 'm';
 longname{k} = 'Low Pass Filtered Depth';
 dims{k} = [vars{1} "," vars{2}];
end%if
% Variable Title

%
 tmp = "/home/mhoecker/tmp/";
 fname = "isoPmergeChamRAMA";
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
unix(['ncgen -k1 -x -b ' cdffile ' -o ' isoPnc '&& rm ' cdffile])

