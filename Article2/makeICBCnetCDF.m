function makeICBCnetcdf
 #
 #
 z = -200:5:0; % meters
 t = (0:36)*3600; % seconds
 #Shape parameters for tanh profiles
 zmid = -75;
 dz = 20;
 # Velocity scale
 dU = .3;
 # Temperature scale and offset
 T0 = 22;
 dT = 8;
 # Salinity scale and offset
 S0 = 33;
 dS = 2;
 #
 u = dU*tanh((z-zmid)/dz);
 v = 0*z;
 T = T0+dT*tanh((z-zmid)/dz);
 S = S0+dS*tanh((z-zmid)/dz);
 #
 storm = (1+tanh(t-3600*3))/2;
 nostorm = 1-storm;
 #
 J_sw = +50*storm  +500*nostorm;
 J_lw = -50*storm -50*nostorm;
 J_la = -300*storm-100*nostorm;
 P = 5*storm;
 tau_x = 0.3*storm;
 tau_y = 0*t;
 W_l = 100*nostorm+30*storm;
 W_h = W_l.*(nostorm/100+storm/10);
 W_d = 0*t;
 tmpdir = "/home/mhoecker/tmp/";
 filename = [tmpdir "ICBC.cdf"];
 ncname = [tmpdir "test.nc"];
 dim_names ={"t","z"};
 dim_sizes =[length(t),length(z)];
 var_names = {dim_names{:},"U","V","T","S"};
 var_names  = {var_names{:},"J_sw","J_lw","J_la"};
 var_names  = {var_names{:},"P","tau_x","tau_y"};
 var_names  = {var_names{:},"W_l","W_h","W_d"}
 descriptions = {};
 values = {};
 # Variable text
 var_desc.z = ['double %s(' dim_names{2} ');\n'];
 var_desc.t = ['double %s(' dim_names{1} ');\n'];
 var_desc.sec = ' %s:units = "s";\n';
 var_desc.vel = ' %s:units = "m/s";\n';
 var_desc.tmp = ' %s:units = "C";\n';
 var_desc.sal = ' %s:units = "g/kg";\n';
 var_desc.hot = ' %s:units = "W/m^2";\n';
 var_desc.len = ' %s:units = "m";\n';
 var_desc.tau = ' %s:units = "Pa";\n';
 var_desc.dir = ' %s:units = "deg";\n';
 var_desc.precip = ' %s:units = "mm/hr";\n';
 longname = ' %s:longname = "%s";\n';
 for i=1:length(var_names)
  switch var_names{i}
   case{"z"}
    desc = sprintf(var_desc.z,var_names{i});
    desc = [desc sprintf(var_desc.len,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"depth")];
    values = {values{:},z};
   case{"t"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.sec,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"time")];
    values = {values{:},t};
   case{"U"}
    desc = sprintf(var_desc.z,var_names{i});
    desc = [desc sprintf(var_desc.vel,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"zonal velocity")];
    values = {values{:},u};
   case{"V"}
    desc = sprintf(var_desc.z,var_names{i});
    desc = [desc sprintf(var_desc.vel,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"meridional velocity")];
    values = {values{:},v};
   case{"T"}
    desc = sprintf(var_desc.z,var_names{i});
    desc = [desc sprintf(var_desc.tmp,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Temperature")];
    values = {values{:},T};
   case{"S"}
    desc = sprintf(var_desc.z,var_names{i});
    desc = [desc sprintf(var_desc.sal,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Salinity")];
    values = {values{:},S};
   case{"J_sw"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.hot,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Short Wave Heat Flux")];
    values = {values{:},J_sw};
   case{"J_lw"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.hot,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Long Wave and Sensible Heat Flux")];
    values = {values{:},J_lw};
   case{"J_la"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.hot,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Latent Heat Flux")];
    values = {values{:},J_la};
   case{"tau_x"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.tau,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Zonal Wind Stress")];
    values = {values{:},tau_x};
   case{"tau_y"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.tau,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Meridional Wind Stress")];
    values = {values{:},tau_y};
   case{"P"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.precip,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Rain Rate")];
    values = {values{:},P};
   case{"W_l"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.len,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Wave Length")];
    values = {values{:},W_l};
   case{"W_h"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.len,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Wave Height")];
    values = {values{:},W_h};
   case{"W_d"}
    desc = sprintf(var_desc.t,var_names{i});
    desc = [desc sprintf(var_desc.dir,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Wave Direction")];
    values = {values{:},W_d};
   otherwise
    descr = "";
  end%switch
  descriptions = {descriptions{:},desc};
 end%for
 #Additional global variables
 desc = sprintf(':created = "%s";\n',date);
 descriptions = {descriptions{:},desc};
 writeCDF(filename,var_names,dim_names,dim_sizes,descriptions,values);
end%function
