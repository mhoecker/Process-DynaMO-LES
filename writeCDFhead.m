function writeCDFhead(cdffile,dim_names,dim_sizes,descriptions,metaname)
 cdfid = fopen(cdffile,'w');
 if(nargin<3)
  metaname = cdffile;
 end%if
 fprintf(cdfid,'netcdf %s {\n',metaname);

 # Declare Dimensions
 fprintf(cdfid,'dimensions:\n');
 for i=1:length(dim_sizes)
  fprintf(cdfid,'%s=%i; ',dim_names{i},dim_sizes(i));
 end%for
fprintf(cdfid,'\n');
# Declare Variables
fprintf(cdfid,'variables:\n')
 for i=1:length(descriptions)
  fprintf(cdfid,'%s',descriptions{i})
 end%for
 fclose(cdfid)
end%function
