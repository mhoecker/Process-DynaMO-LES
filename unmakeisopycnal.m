%
%
%
%
% finish off the isopycnal average and return to z co-ordinate
isopfile = "/home/mhoecker/work/Dynamo/Observations/netCDF/chamRAMA/isoPchamAndRAMA.nc"
makeplots = 1;
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
 size(zz)
 size(tt)
 size(changed.fields{1})
 size(changed.fields{2})
 titles = {"rho","U","V","CT","SA"};
 for i=1:length(changed.fields);
  figfile = ["/home/mhoecker/tmp/unmakeisop" num2str(i,"%03i") ".png"];
  figure(i)
  subplot(1,1,1)
  plot(changed.fields{i},z); shading flat
  title(titles{i})
  print(figfile,"-dpng")
 end%for
end%if
%save new netcdf with varibles of z,t

