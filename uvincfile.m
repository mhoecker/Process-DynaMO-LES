function [outname,Ucoef,Vcoef] = uvincfile(adcpfile,wantdate,maxdepth,outloc,avgtime,order,varnames)
 # Crate a file like
 #C velocity data from /file/location/adcpdata.nc
 #        integer parameter :: lmax=6
 #C projection of U velocity from upper 150 m
 #        real, dimension(lmax), parameter :: UCoef=(/
 #     *   +0.090021,
 #     *   -0.324402,
 #     *   +0.048989,
 #     *   +0.143456,
 #     *   +0.028982,
 #     *   -0.119650/)
 #C projection of V velocity from upper 150 m
 #        real, dimension(lmax) :: VCoef=(/
 #     *   -0.0278478,
 #     *   +0.1446929,
 #     *   +0.0751749,
 #     *   +0.0310151,
 #     *   +0.0487805,
 #     *   -0.0327094/)
 outname = [outloc "UVCoef"];
 if nargin()<7
  [Ucoef,Vcoef,Ufit,Vfit,z,U,V] = uvLegendre(adcpfile,wantdate,maxdepth,avgtime,order);
 else
  [Ucoef,Vcoef,Ufit,Vfit,z,U,V] = uvLegendre(adcpfile,wantdate,maxdepth,avgtime,order,varnames);
 end%if
 leadspace = "        ";
 incid = fopen([outname ".inc"],"w");
 fprintf(incid,"%s\n",["C velocity data from " adcpfile]);
 fprintf(incid,"%s\n",[leadspace "integer, parameter :: lmax=" num2str(order) ]);
 #
 fprintf(incid,"%s\n",["C projection of U velocity from upper " num2str(maxdepth) " m"]);
 fprintf(incid,"%s\n",[leadspace "real, parameter, dimension(lmax) :: UCoef=(/" ]);
 for i=1:length(Ucoef)-1
  fprintf(incid,"     *   %s,\n",num2str(Ucoef(i)));
 end%for
 fprintf(incid,"     *   %s/)\n",num2str(Ucoef(end)));
 #
 fprintf(incid,"%s\n",["C projection of V velocity from upper " num2str(maxdepth) " m"]);
 fprintf(incid,"%s\n",[leadspace "real,parameter, dimension(lmax) :: VCoef=(/" ]);
 for i=1:length(Vcoef)-1
  fprintf(incid,"     *   %s,\n",num2str(Vcoef(i)));
 end%for
 fprintf(incid,"     *   %s/)\n",num2str(Vcoef(end)));
 fclose(incid)
 Umyfit = expandlegendre(Ucoef,z);
 Vmyfit = expandlegendre(Vcoef,z);
 subplot(1,2,1)
 plot(Ufit,-z,"+;fit;",U,-z,Umyfit,-z)
 ylabel("Depth (m)")
 xlabel("Zonal Velocity (m/s)")
 subplot(1,2,2)
 plot(Vfit,-z,"+;fit;",V,-z,Vmyfit,-z)
 ylabel("Depth (m)")
 xlabel("Meridional Velocity (m/s)")
 print([outname ".png"],"-dpng")
end%function
