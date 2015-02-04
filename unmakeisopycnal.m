%
%
%
%
% finish off the isopycnal average and return to z co-ordinate
datdir = "/home/mhoecker/work/Dynamo/Observations/netCDF/chamRAMA/";
isopfile = [datdir "isoPchamAndRAMA.nc"]
isopzfile = [datdir "isoPZchamAndRAMA.nc"]
makeplots = 0;
%Read in isopycnal averaged from netcdf
% subset the data if neccecary
isopnc = netcdf(isopfile,"r");
t = isopnc{"t0"}(:)';
rho = isopnc{"rho"}(:)';
fields = {isopnc{"zbar"}(:)'};
fields = {fields{:},isopnc{"Ubar" }(:)'};
fields = {fields{:},isopnc{"Vbar" }(:)'};
fields = {fields{:},isopnc{"CTbar"}(:)'};
fields = {fields{:},isopnc{"SAbar"}(:)'};
ncclose(isopnc)

% set depths for interpolation
z = floor(min(min(fields{1}))):ceil(max(max(fields{1})));
%feed to changevar2 to get z variable
[changed]=changevar2(t,rho,fields,z);

%plot variables for debuging
if(makeplots!=0)
 [zz,tt] = meshgrid(z,t);
 titles = {"rho","U","V","CT","SA"};
 medfil = 13;
 Nt = length(t);
 Nz = length(z);
 for i=1:length(changed.fields);
  for j=1:Nz
   jmin = max([1,ceil( j-medfil/2)]);
   jmax = min([length(z),floor(j+medfil/2)]);
   for k=1:Nt
    varin = changed.fields{i}(k,jmin:jmax);
    idxgood = find(~isnan(varin));
    vargood = varin(idxgood);
    changed.fields{i}(k,j)=median(vargood);
   end%for
  end%for
 end%for
 for i=1:length(changed.fields);
  figfile = ["/home/mhoecker/tmp/unmakeisop" num2str(i,"%03i") ".png"];
  xyrange = [min(min(changed.fields{i})),max(max(changed.fields{i})),min(z),max(z)];
  figure(i)
  %for j=6:8
   %subplot(1,,j-5)
   %plot(changed.fields{i}(j,:)',z);
   %axis(xyrange);
   %title([titles{i} "(t0) =" num2str(t(j),"%6.2f")]);
  %end%for
   subplot(1,1,1)
   pcolor(tt,zz,changed.fields{i}); shading flat; colorbar
   title([titles{i} " t0 =" num2str(t(1),"%6.2f") " to " num2str(t(end),"%6.2f")]);
  print(figfile,"-dpng")
 end%for
end%if
%save new netcdf with varibles of z,t


val = {z,t};
for i=1:length(changed.fields);
 val = {val{:},changed.fields{i}};
end%for
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
 vars{k} = 'Z';
 units{k} = 'm';
 longname{k} = 'Depth';
 dims{k} = vars{k};
end%if
if((k<Nvar)*(k<Ndim))
 k = k+1;
 vars{k} = 't';
 units{k} = 'd';
 longname{k} = '2011 Julian day';
 dims{k} = vars{k};
end%if
%Data Variables
if(k<Nvar)
 k = k+1;
 vars{k} = 'rho';
 units{k} = 'kg/m^3';
 longname{k} = 'Density';
 dims{k} = [vars{1} "," vars{2}];
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
 fname = "isoPavgZmergeChamRAMA";
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
unix(['ncgen -k1 -x -b ' cdffile ' -o ' isopzfile '&& rm ' cdffile])
