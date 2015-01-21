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
 titles = {"rho","U","V","CT","SA"};
 medfil = 13;
 for i=1:length(changed.fields);
  for j=1:length(z)
   jmin = max([1,ceil( j-medfil/2)]);
   jmax = min([length(z),floor(j+medfil/2)]);
   for k=1:length(t)
    varin = changed.fields{i}(k,jmin:jmax);
    idxgood = find(~isnan(varin));
    vargood = varin(idxgood);
    changed.fields{i}(k,j)=median(vargood);
   end%for
  end%for
  figfile = ["/home/mhoecker/tmp/unmakeisop" num2str(i,"%03i") ".png"];
  figure(i)
  subplot(1,1,1)
  pcolor(tt,zz,changed.fields{i}); shading flat; colorbar
  title(titles{i})
  print(figfile,"-dpng")
 end%for
end%if
%save new netcdf with varibles of z,t


