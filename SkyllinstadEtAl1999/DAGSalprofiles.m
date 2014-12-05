function [DAGSal] = DAGSalprofiles(dagnc,trange,zrange)
 # Get variables with time and zzu as dimensions
 field1 = ['time';'zzu'];
 field1 = [field1;'s_ave';'s2_ave'];#
 DAGSal1 = dagvars(dagnc,field1,trange,zrange);
 for i=1:length(field1(:,1))
  fieldname = deblank(field1(i,:));
  DAGSal.(fieldname) = DAGSal1.(fieldname);
 end%for
 # Get variables with time and zzw as dimensions
 field2 = ['time';'zzw'];
 field2 = [field2;'sf_ave';'ws_ave'];
 DAGSal2 = dagvars(dagnc,field2,trange,zrange);
 for i=1:length(field2(:,1))
  fieldname = deblank(field2(i,:));
  DAGSal.(fieldname) = DAGSal2.(fieldname);
 end%for
 # Get variables with time and z as dimensions
 field3 = ['time';'z'];
 field3 = [field3;'rain';];
 DAGSal3 = dagvars(dagnc,field3,trange,zrange);
 for i=1:length(field3(:,1))
  fieldname = deblank(field3(i,:));
  DAGSal.(fieldname) = DAGSal3.(fieldname);
 end%for
end%function

