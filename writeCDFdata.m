function writeCDFdata(fileid,data,vars)
% writeCDFdata(fileid,data)
% data is a 2-D array data(:,i) is the data in the ith variable
% vars is a cell aray with the variable names
fprintf(fileid,'data:\n')
for i=1:M
 y = data(:,i);
 fprintf(fileid,'%s =\n',vars{i});
 for j=1:N
  if(isnan(y(j))==1)
   fprintf(fileid,'NaN');
  else
   fprintf(fileid,'%20.20g',y(j));
  end%if
  if(j<N)
   fprintf(fileid,', ');
  else
   fprintf(fileid,';\n');
  end%if
 end%for
end%for
fprintf(fileid,'}\n', fname)
fclose(fileid)
end%function
