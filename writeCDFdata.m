function writeCDFdata(fileid,data,vars)
% writeCDFdata(fileid,data,vars)
% data is a cell array of data in each variable
% vars is a cell aray with the variable names
fprintf(fileid,'data:\n')
for i=1:length(data)
 y = data{i}(:);
 fprintf(fileid,'%s =\n',vars{i});
 for j=1:length(y)
  if(isnan(y(j))==1)
   fprintf(fileid,'NaN');
  else
   fprintf(fileid,'%20.20g',y(j));
  end%if
  if(j<length(y))
   fprintf(fileid,', ');
  else
   fprintf(fileid,';\n');
  end%if
 end%for
end%for
fprintf(fileid,'}\n')
fclose(fileid)
end%function
