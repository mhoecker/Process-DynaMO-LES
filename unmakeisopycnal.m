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
t = isopnc{"t"}(:)';
rho = isopnc{"rho"}(:)';
fields = {isopnc{"zbar"}(:)'};
fields = {fields{:},isopnc{"Ubar" }(:)'};
fields = {fields{:},isopnc{"Vbar" }(:)'};
fields = {fields{:},isopnc{"CTbar"}(:)'};
fields = {fields{:},isopnc{"SAbar"}(:)'};
ncclose(isopnc)

% set depths for interpolation
z = -100:0;
%feed to changevar2 to get z variable
[changed]=changevar2(t,rho,fields,z);

%plot variables for debuging
if(makeplots!=0)
 [zz,tt] = meshgrid(z,t);
 size(zz)
 size(tt)
 size(changed.fields{1})
 size(changed.fields{2})
 for i=1:length(changed.fields);
  figfile = ["/home/mhoecker/tmp/unmakeisop" num2str(i,"%03i") ".png"];
  figure(i)
  subplot(1,1,1)
  pcolor(tt,zz,changed.fields{i}); shading flat
  print(figfile,"-dpng")
 end%for
end%if
%save new netcdf with varibles of z,t

