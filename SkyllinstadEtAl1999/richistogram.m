function [Z,Rirank,Ssqrank,Nsqrank,frac,phirank] = richistogram(filename,filetype)
 nargin
 if(nargin<1)
 filename = "/home/mhoecker/work/Dynamo/output/yellowstone10/dyn1024flx_s_dag.nc"
 filename = "/home/mhoecker/work/Dynamo/output/yellowstone6/d1024_1_dag.nc"
 filetype = "dag"
 end#if
 # load gibbs sea water
 findgsw;
 g = gsw_grav(0);
 # load raw data
 # resultant matricies are 2D
 # The first dimension is the z variable
 # the second dimension depends on the type of file
 #
 # filetype="dag" variables are A(Z,T)
 #
 # filetype="slb" variables are A(Z,X) or A(Z,Y)
 #
 # filetype="rst" variables are A(Z,XY)
 # where the horizontal indecies have been flattened
 #
 nc = netcdf(filename,'r');
 switch(filetype)
 #Load mean values from dag file
 # dimensions z,t
 # velocities u,v
 # state S,T
  case{"dag"}
   # dag version file
   Z = -squeeze(nc{'zzu'}(:));
   U = squeeze(nc{'u_ave'}(:));
   V = squeeze(nc{'v_ave'}(:));
   T = squeeze(nc{'t_ave'}(:));
   S = squeeze(nc{'s_ave'}(:));
   Zw = -squeeze(nc{'zzw'}(:));
   uw = interp1(Zw,squeeze(nc{'uw_ave'}(:))',Z)';
   vw = interp1(Zw,squeeze(nc{'vw_ave'}(:))',Z)';

  case{"slb"}
   # slb version
   # calculate statistics for each slab in the horizontal dimension(s)
  case{"rst"}
   # rst version
   #Calculate statistics for each restart file in the horizontal dimensions
 end#switch
 ncclose(nc);
 # Calculate derivative matrix
 dzmat = ddz(Z);
 # Calculate pressure
 P = gsw_p_from_z(Z,0);
 # Calculate Absolute Salinity
 SA = gsw_SA_from_SP(S,P,0,0);
 # Calculate Conservative Temperature
 CT = gsw_CT_from_t(SA,T,P);
 # Calculate density(S,T,Z)
 rho = gsw_rho(SA,CT,P);
 # Calculate Buoyancy frquency
 Nsq = -g*(rho*dzmat')./rho;
 Nsqrank = sort(Nsq,1);
 # Calculate Shear and Shear Production
 Uz = U*dzmat';
 Vz = V*dzmat';
 SP = uw.*Uz+vw.*Vz;
 [SPrank,SPidx] = sort(SP,1);
 Ssq = Uz.^2+Vz.^2;
 Ssqrank = sort(Ssq,1);
 # Calculate Richardson number
 Ri = Nsq./Ssq;
 Rirank = sort(Ri,1);
 frac = (1:length(Rirank(:,1)))./length(Rirank(:,1));
 phirank = Rirank./(.25+abs(Rirank));
 #plot(phi(:,1),frac)
 datdir = "/home/mhoecker/tmp/";
 abrev = "richistogram";
 binmatrix(frac,Z,Rirank' ,[datdir "Rirank.dat"])
 binmatrix(frac,Z,phirank',[datdir "phirank.dat"])
 binmatrix(frac,Z,Ssqrank',[datdir "Ssqrank.dat"])
 binmatrix(frac,Z,Nsqrank',[datdir "Nsqrank.dat"])
 binmatrix(frac,Z,SPrank' ,[datdir "SPrank.dat"])
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam(datdir,datdir,abrev);
 ["gnuplot " limitsfile " " scriptdir abrev ".plt"]
 unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"])
end
