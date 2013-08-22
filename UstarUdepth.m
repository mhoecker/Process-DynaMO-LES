function UstarUdepth(dagnc,outname,term)
 if(nargin()<3)
  term = 'png';
 end%if
 nc = netcdf(dagnc,'r');
 x = nc{'time'}(:)';
 x = x/3600;
 y = nc{'ustr_t'}(:)';
 z = -nc{'zzu'}(:)';
 c = nc{'u_ave'}(:)';
 cmin = min(min(c));
 cmax = max(max(c));
 crange = cmax-cmin;
 upperlabels = {"set ylabel 'Zonal Stress'"};
 lowerlabels = {
 "set xlabel 'time (hrs)'",
 "set ylabel 'Depth (m)'",
 "set cblabel 'U_{mean}'"
 };
 lineovercolorplot(x,y,z,c,[outname "UstrUmean"],upperlabels,lowerlabels,term)
 x = nc{'time'}(:)';
 x = x/3600;
 y = nc{'vstr_t'}(:)';
 z = -nc{'zzu'}(:)';
 c = nc{'v_ave'}(:)';
 cmin = min(min(c));
 cmax = max(max(c));
 crange = cmax-cmin;
 upperlabels = {"set ylabel 'Meridional Stress'"};
 lowerlabels = {
 "set xlabel 'time (hrs)'",
 "set ylabel 'Depth (m)'",
 "set cblabel 'V_{mean}'"
 };
 lineovercolorplot(x,y,z,c,[outname "VstrVmean"],upperlabels,lowerlabels,term)
 x = nc{'time'}(:)';
 x = x/3600;
 y = nc{'rain'}(:)';
 z = -nc{'zzu'}(:)';
 c = nc{'s_ave'}(:)';
 cmin = min(min(c));
 cmax = max(max(c));
 upperlabels = {"set ylabel 'Rain'"};
 lowerlabels = {
 "set xlabel 'time (hrs)'",
 "set ylabel 'Depth (m)'",
 "set cblabel 'S_{mean}'"
  };
 lineovercolorplot(x,y,z,c,[outname "rainSmean"],upperlabels,lowerlabels,term)
 x = nc{'time'}(:)';
 x = x/3600;
 y = nc{'hf_top'}(:)';
 z = -nc{'zzu'}(:)';
 c = nc{'t_ave'}(:)';
 cmin = min(min(c));
 cmax = max(max(c));
 upperlabels = {"set ylabel 'Heat Flux'"};
 lowerlabels = {
 "set xlabel 'time (hrs)'",
 "set ylabel 'Depth (m)'",
 "set cblabel 'T_{mean}'"
 };
 lineovercolorplot(x,y,z,c,[outname "HeatTmean"],upperlabels,lowerlabels,term)
 ncclose(nc);
end%function
