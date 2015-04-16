function writeCDFtest
# Show that
# writeCDF(filename,var_names,dim_names,dim_sizes,descriptions,values,metaname);
# works
tmpdir = "/home/mhoecker/tmp/";
filename = [tmpdir "test.cdf"];
ncname = [tmpdir "test.nc"];
dim_names ={"x","y","z","t"};
dim_sizes =[1,2,3,4];
var_names = {dim_names{:},"u","v","w","T","S"}
descriptions = {};
values = {};
dimdesc = 'double %s(%s);\n %s:units = "%s";\n %s:longname = "%s";\n';
#
for i=1:length(dim_names)
 d = dim_names{i};
 if(i<4)
  u = "m";
 else
  u = "s";
 end%if
 desc = sprintf(dimdesc,d,d,d,u,d,d);
 descriptions = {descriptions{:},desc};
 values = {values{:},1:abs(dim_sizes(i))};
end%for
values
d = dim_names;
var_desc.xyzt = ['double %s(' dim_names{1} ',' dim_names{2} ',' dim_names{3} ',' dim_names{4} ');\n'];
var_desc.vel = ' %s:units = "m/s";\n';
var_desc.tmp = ' %s:units = "C";\n';
var_desc.sal = ' %s:units = "g/kg";\n';
for i=length(dim_names)+1:length(var_names)
 desc = sprintf(var_desc.xyzt,var_names{i});
 if(i<8)
  desc = [desc sprintf(var_desc.vel,var_names{i})];
 elseif(i==8)
  desc = [desc sprintf(var_desc.tmp,var_names{i})];
 else
  desc = [desc sprintf(var_desc.sal,var_names{i})];
 end%if
 descriptions = {descriptions{:},desc};
 values = {values{:},(ones(abs(dim_sizes))+eps())};
end%for
writeCDF(filename,var_names,dim_names,dim_sizes,descriptions,values);
unix(['ncgen -k 3 -o ' ncname ' ' filename])
end%function
