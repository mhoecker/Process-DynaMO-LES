ncdir   = "/home/mhoecker/work/Dynamo/Observations/netCDF/chamRAMA/"
mergenc = [ncdir "chamAndRAMA.nc"];
isoPnc = [ncdir "isoPchamAndRAMA.nc"];
pltdir  = "/home/mhoecker/work/Dynamo/plots/isopycnals/";


mergec = netcdf(mergenc,"r");
t = mergec{"t"}(:);
t0 = 326.5:.25:329.5;
% filter data to T>1day to remove tides
fill_T = 1.5;
fill_order = 1;
tidx = inclusiverange(t,[min(t0)-fill_T/2,max(t0)+fill_T/2]);
%tidx = inclusiverange(t,[327.95,328.05]);
z = mergec{"z"}(:);
zidx = inclusiverange(z,[-200,0]);
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

[zz,ss] = meshgrid(z,t);

Urange = [min(min(u)),max(max(u))];
Vrange = [min(min(v)),max(max(v))];
CTrange = [min(min(ct)),max(max(ct))];
SArange = [min(min(sa)),max(max(sa))];
binmatrix(t,z,u' ,[pltdir "Uin.dat" ]);
binmatrix(t,z,v' ,[pltdir "Vin.dat" ]);
binmatrix(t,z,ct',[pltdir "CTin.dat"]);
binmatrix(t,z,sa',[pltdir "SAin.dat"]);
isoP=isopycnalize(t,z',u,v,sa,ct);
isoP.t0 = t0;
isoP.zbar  = NaN+zeros(length(isoP.t0),length(isoP.rho_cords));
isoP.Ubar  = isoP.zbar;
isoP.Vbar  = isoP.zbar;
isoP.CTbar = isoP.zbar;
isoP.SAbar = isoP.zbar;
for i=1:length(isoP.rho_cords)
 ["average for rho=" num2str(isoP.rho_cords(i))]
 isoP.zbar(:,i)  = harmfill(isoP.z(:,i) ,isoP.t,isoP.t0,fill_order,fill_T);
 isoP.Ubar(:,i)  = harmfill(isoP.U(:,i) ,isoP.t,isoP.t0,fill_order,fill_T);
 isoP.Vbar(:,i)  = harmfill(isoP.V(:,i) ,isoP.t,isoP.t0,fill_order,fill_T);
 isoP.CTbar(:,i) = harmfill(isoP.CT(:,i),isoP.t,isoP.t0,fill_order,fill_T);
 isoP.SAbar(:,i) = harmfill(isoP.SA(:,i),isoP.t,isoP.t0,fill_order,fill_T);
end%for


binmatrix(isoP.t,z             ,isoP.rho',[pltdir "rhoout.dat"]);
binmatrix(isoP.t,isoP.rho_cords,isoP.z'  ,[pltdir "Zout.dat"  ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.U'  ,[pltdir "Uout.dat"  ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.V'  ,[pltdir "Vout.dat"  ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.CT' ,[pltdir "CTout.dat" ]);
binmatrix(isoP.t,isoP.rho_cords,isoP.SA' ,[pltdir "SAout.dat" ]);

%
val = {isoP.rho_cords(:),isoP.t(:),isoP.t0(:),isoP.U(:),isoP.V(:),isoP.CT(:),isoP.SA(:),isoP.z(:),isoP.Ubar(:),isoP.Vbar(:),isoP.CTbar(:),isoP.SAbar(:),isoP.zbar(:)};

Nvar = length(val);
Ndim = 3;
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
if((k<Nvar)*(k<Ndim))
 k = k+1;
 vars{k} = 't0';
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
 dims{k} = [vars{1} "," vars{3}];
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'Vbar';
 units{k} = 'm/s';
 longname{k} = 'Low Pass Filtered Meridional Velocity';
 dims{k} = [vars{1} "," vars{3}];
end%if
if(k<Nvar)
 k = k+1;
  vars{k} = 'CTbar';
   units{k} = 'C';
    longname{k} = 'Low Pass Filtered Conservative Temperature';
     dims{k} = [vars{1} "," vars{3}];
     end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'SAbar';
 units{k} = 'ppt';
 longname{k} = 'Low Pass Filtered Absolute Salinity';
 dims{k} = [vars{1} "," vars{3}];
end%if
if(k<Nvar)
 k = k+1;
 vars{k} = 'zbar';
 units{k} = 'm';
 longname{k} = 'Low Pass Filtered Depth';
 dims{k} = [vars{1} "," vars{3}];
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
 end%for
%Declare variables
 fprintf(cdlid,'variables:\n');
 for i=1:Nvar
  fprintf(cdlid,'double %s(%s);\n',vars{i},dims{i});
 end%for
% Add units, long_name and instrument
fprintf(cdlid,'\n');
for i=1:Nvar
 fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
 fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
 if(length(formulae{i})>0)
  fprintf(cdlid,'%s:formulae = "%s";\n',vars{i},formulae{i});
 end%if
end%for
%Declare global attributes
fprintf(cdlid,':source = "%s";\n',[fname '.mat']);
fprintf(cdlid,':instrument = "Chameleon and RAMA mooring";\n');
fprintf(cdlid,':vessel = "R/V Roger Revelle";\n');
writeCDFdata(cdlid,val,vars)
unix(['ncgen -k1 -x -b ' cdffile ' -o ' isoPnc '&& rm ' cdffile])
