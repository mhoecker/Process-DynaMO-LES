function [outtke,outzavg,outAVG,outAVGdat] = tkeBudget(dagnc,outnc,trange,zrange)
# output is a ascii file with the mean terms in the tke budget
# Toatal Stokes Production
# Total Shear Production
# Total Buoyancy Production
# Total Dissipation
# data = cell array of flattened data to be saved
# vars = cell array of corresponding variable names
# fileid = identifier of file to use as cdf file
 if(nargin<3)
  [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss,badSt,badwP,Szdag,fave] = DAGtkeprofiles(dagnc);
 elseif(nargin<4)
  [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss,badSt,badwP,Szdag,fave] = DAGtkeprofiles(dagnc,trange);
 else
  [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss,badSt,badwP,Szdag,fave] = DAGtkeprofiles(dagnc,trange,zrange);
 end%if
 val = {zdag(:),tdag(:),tkeavg(:),tkePTra(:),tkeAdve(:),BuoyPr(:),tkeSGTr(:),ShPr(:),StDr(:),Diss(:),badSt(:),badwP(:),fave(:)};
 Nvar = length(val);
 Ndim = 2;
# Initialize cell arrays
 vars = {};
 longname = {};
 units = {};
 dims = {};
 formulae = {};
 for i=1:Nvar;
  vars = {vars{:},['var' num2str(i)]};
  units = {units{:},'TBD'};
  longname = {longname{:},'TBD'};
  dims = {dims{:},''};
  formulae = {formulae{:},''};
 end%for
#
k=0;
#
# Dimension Variable Title
if((k<Nvar)*(k<Ndim)) #Depth
 k = k+1;
 vars{k} = 'z';
 units{k} = 'm';
 longname{k} = 'depth';
 dims{k} = vars{k};
end%if
if((k<Nvar)*(k<Ndim)) #Simulation time
 k = k+1;
 vars{k} = 't';
 units{k} = 's';
 longname{k} = 'Simulation time';
 dims{k} = vars{k};
end%if
# Variable Title
if(k<Nvar) #tke
 k = k+1;
 vars{k} = 'tke';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Average Turbulent Kinetic Energy';
 formulae{k} = 'tke_ave';
end%if
if(k<Nvar) # Pressure Transport
 k = k+1;
 vars{k} = 'wP';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Pressure Transport';
 formulae{k} = 'p_ave+sd_ave-S_0*(2*pi/wave_l)*exp(2*z*2*pi/wave_l)*[uw_ave*cos(wave_a)+vw_ave*sin(wave_a)]';
end%if
if(k<Nvar) # Advective Transport
 k = k+1;
 vars{k} = 'wtke';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Advective Transport';
 formulae{k} = 'a_ave-sp_ave';
end%if
if(k<Nvar) # Buoyancy Production
 k = k+1;
 vars{k} = 'wb';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Buoyancy Production';
 formulae{k} = 'b_ave';
end%if
if(k<Nvar) # Subgridscale Transport
 k = k+1;
 vars{k} = 'sgs';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Subgridscale Transport';
 formulae{k} = 'sg_ave-disp_ave';
end%if
if(k<Nvar) # Shear Production
 k = k+1;
 vars{k} = 'SP';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Shear Production';
 formulae{k} = 'sp_ave';
end%if
if(k<Nvar) # Stokes Production
 k = k+1;
 vars{k} = 'St';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Stokes Production';
 formulae{k} = 'S_0*(2*pi/wave_l)*exp(2*z*2*pi/wave_l)*[uw_ave*cos(wave_a)+vw_ave*sin(wave_a)]';
end%if
if(k<Nvar) # Dissipation
 k = k+1;
 vars{k} = 'eps';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Dissipation';
 formulae{k} = 'disp_ave';
end%if
if(k<Nvar) # Model Stokes
 k = k+1;
 vars{k} = 'sd_ave';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Stokes Production';
 formulae{k} = 'sd_ave';
end%if
if(k<Nvar) # Model wP
 k = k+1;
 vars{k} = 'p_ave';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Pressure Transport';
 formulae{k} = 'p_ave';
end%if
if(k<Nvar)
 k=k+1;
 vars{k} = 'f_ave';
 units{k} = 'W/kg';
 dims{k} = [ vars{1} "," vars{2} ];
 longname{k} = 'Filter Dissipation';
 formulae{k} = 'f_ave=uf_ave+vf_ave+wf_ave';
end%if

 [inpath,inname,inext] = fileparts(dagnc);
 if(nargin<2)
  outnc = [inpath '/' inname "tke" inext];
 end%if
 [outpath,outname,outext] = fileparts(outnc);
 outtke = outnc;
 outzavg = [outpath '/' outname 'zavg' outext];
 outAVG =  [outpath '/' outname 'AVG' outext];
 outAVGdat = [outpath '/' outname '.dat'];
 cdffile = [tempname("/home/mhoecker/tmp/")  ".cdf"];
 cdlid = fopen(cdffile,'w');
# Write header
 fprintf(cdlid,'netcdf %s.nc {\n', outname);
# Declare Dimensions
 fprintf(cdlid,'dimensions:\n');
 for i=1:Ndim
  fprintf(cdlid,'%s=%i;\n',vars{i},length(val{i}));
 end%for
# Declare variables
 fprintf(cdlid,'variables:\n');
 for i=1:Nvar
  fprintf(cdlid,'double %s(%s);\n',vars{i},dims{i});
 end%for
# Add units, long_name and instrument
fprintf(cdlid,'\n');
for i=1:Nvar
 fprintf(cdlid,'%s:units = "%s";\n',vars{i},units{i});
 fprintf(cdlid,'%s:long_name = "%s";\n',vars{i},longname{i});
 if(length(formulae{i})>0)
  fprintf(cdlid,'%s:formulae = "%s";\n',vars{i},formulae{i});
 end%if
 end%for
#Declare global attributes
 fprintf(cdlid,':source = "%s";\n',[dagnc]);
 fprintf(cdlid,':Function_called = "%s";\n',mfilename);
 fclose(cdlid)


 writeCDFdata(cdffile,val,vars);
% "wrote CDF file"
 unix(['ncgen -k1 -x -b ' cdffile ' -o ' outnc '&& rm ' cdffile]);
% "Generateg netcdf file"
 unix(['ncwa -O -a z ' outnc ' ' outzavg]);
% "Taking z avwerage"
 unix(['ncwa -O -a z,t ' outnc ' ' outAVG]);
 AVG = netcdf(outAVG,'r');
 ZVG = netcdf(outzavg,'r');
 netdtke = -ZVG{'tke'}(end)/ZVG{'t'}(end);
 tkeflow = [AVG{'St'}(:),AVG{'SP'}(:),AVG{'wb'}(:), AVG{'eps'}(:),AVG{'sd_ave'}(:),AVG{'p_ave'}(:),netdtke,AVG{'f_ave'}(:)];
 ncclose(AVG)
 ncclose(ZVG)
 AVGdat = fopen(outAVGdat,'w');
 for i=1:length(tkeflow)
  fprintf(AVGdat,'%20.20f ',tkeflow(i));
 end%for
 fclose(AVGdat);
end%function
