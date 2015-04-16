function writeCDF(filename,var_names,dim_names,dim_sizes,descriptions,values,metaname);
#
# filename is a string = the file name to be saved
# var_names is a cell array of strings = the variable names
# dim_names is a cell array of strings = the dimension names
# dim_sizes is an integer array = dimension lengths
# descriptions is a cell array of strings = the variable entry in the cdf header
# values is a celll array of floats = the vaues of each variable
# metaname is a string = optional name given to the dataset
#
# Format of description entry is
#
# description{i}='
# variable_type variable_name(dimension_name,dimension_name,...);\n
# variable_name:descriptor = "value";\n
# variable_name:descriptor = "value";\n'
#
#
#
 if(nargin<7)
  metaname=filename;
 end%if
 writeCDFhead(filename,dim_names,dim_sizes,descriptions,metaname)
 writeCDFdata(filename,values,var_names)
