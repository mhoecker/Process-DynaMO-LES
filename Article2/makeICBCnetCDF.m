function makeICBCnetCDF(outpath,Uparams,Tparams,Sparams,fluxes)
 tmpdir = "/home/mhoecker/tmp/";
 if(nargin<1)
  outpath = tmpdir;
 else
    if(exist(outpath,"dir")==0); unix(["mkdir " outpath]); end%if
 end%if
 #
 #
 z = -300.0:1.0:0.0; % meters
 t = 0:.5:36;    % hours
 # Start the storm after 3 hours
 storm = (1+tanh(t-3))/2;
 nostorm = 1-storm;
 #Shape parameters for default tanh profiles
 zmid = -15.0;
 dz   =   5.0;
 # Velocity scale
 dU   = 0.0;
 U0   = dU;
 # Temperature scale and offset
 T0   = 20.0;
 dT   = 5.0;
 # Salinity scale and offset
 S0   = 35.0;
 dS   = -0.5;
 if(nargin<5)
  fluxes.JSW = [20.0,20.0];
  fluxes.JLW = [-10.0,-10.0];
  fluxes.JLA = [-10.0,-10.0];
  fluxes.P   = [0.5,0.5];
  fluxes.Tx  = [0.01,0.01];
  fluxes.Ty  = [0.0,0.0];
  fluxes.Wl  = [10,10];
  fluxes.Wh  = [0.2,0.2];
  fluxes.Wd  = atan2(fluxes.Tx,fluxes.Ty)*180.0/pi
 end%if
 # If no parameters are given use dfault values for U profile
 if(nargin<2)
  Uparams = [dU,zmid,dz,U0]
 end%if
 # If no parameters are given use dfault values for T profile
 if(nargin<3)
  Tparams = [dT,zmid,dz,T0]
 end%if
 # If no parameters are given use dfault values for T profile
 if(nargin<4)
  Sparams = [dS,zmid,dz,S0]
 end%if
 u = pofz(z,Uparams);
 v = 0*z;
 T = pofz(z,Tparams);
 S = pofz(z,Sparams);
 #
 J_sw  = cos(2*pi*t/24);
 J_sw  = J_sw.*(1+sign(J_sw))/2;
 J_sw  =(fluxes.JSW(1) * nostorm + fluxes.JSW(2) * storm).*J_sw ;
 J_la  = fluxes.JLA(1) * nostorm + fluxes.JLA(2) * storm;
 J_lw  = fluxes.JLW(1) * nostorm + fluxes.JLW(2) * storm -J_la;
 P     = fluxes.P(  1) * nostorm + fluxes.P(  2) * storm;
 tau_x = fluxes.Tx( 1) * nostorm + fluxes.Tx( 2) * storm;
 tau_y = fluxes.Ty( 1) * nostorm + fluxes.Ty( 2) * storm;
 W_l   = fluxes.Wl( 1) * nostorm + fluxes.Wl( 2) * storm;
 W_h   = fluxes.Wh( 1) * nostorm + fluxes.Wh( 2) * storm;
 W_d   = fluxes.Wd( 1) * nostorm + fluxes.Wd( 2) * storm;
 #
 filename = [tmpdir "ICBC.cdf"];
 ncname = [outpath "UVinit.nc"];
 dim_names ={"t","Z"};
 dim_sizes =[length(t),length(z)];
 var_names = {dim_names{:},"U","V","CT","SA"};
 var_names  = {var_names{:},"J_sw","J_lw","J_la"};
 var_names  = {var_names{:},"P","tau_x","tau_y"};
 var_names  = {var_names{:},"W_l","W_h","W_d"};
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
   case{"Z"}
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
   case{"CT"}
    desc = sprintf(var_desc.z,var_names{i});
    desc = [desc sprintf(var_desc.tmp,var_names{i})];
    desc = [desc sprintf(longname,var_names{i},"Temperature")];
    values = {values{:},T};
   case{"SA"}
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
 unix(["ncgen -k 3 -o " ncname " " filename " && rm " filename]);
 LESinitialTS(ncname,outpath)
 fileout = [outpath "bc.dat"]
 outid = fopen(fileout,"w");
 fprintf(outid,' text\n');
 fprintf(outid,' \n');
 fprintf(outid,' swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle\n');
 dthrs = abs(mean(diff(t)));
 for i=1:length(t);
  fprintf(outid,'%f %f %f %f %f %f %f %f %f %f\n',t(i),J_sw(i),J_lw(i),J_la(i),P(i)*dthrs,tau_x(i),tau_y(i),W_l(i),W_h(i),W_d(i))
 end%for
 fclose(outid)
end%function
