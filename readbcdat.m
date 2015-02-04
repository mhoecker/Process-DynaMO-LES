function bcdat = readbcdat(bcfile,tI)
 [fid,MSG] = fopen(bcfile,'r');
 vals = fread(fid,[10,Inf],"float");
 fclose(fid);
 vals(1,:) = vals(1,:)*3600;
 if(nargin>1)
  valsold = vals;
  vals = zeros(10,length(tI));
  for i=1:10
   vals(i,:) = interp1(valsold(1,:),valsold(i,:),tI,"nearest");
  end%for
 end%if
 bcdat.t = vals(1,:)';
 bcdat.swf = vals(2,:)';
 bcdat.hf = vals(3,:)';
 bcdat.lhf = vals(4,:)';
 bcdat.rain = vals(5,:)';
 bcdat.ustr = vals(6,:)';
 bcdat.vstr = vals(7,:)';
 bcdat.waveL = vals(8,:)';
 bcdat.waveH = vals(9,:)';
 bcdat.waveAng = vals(10,:)';
end%function
