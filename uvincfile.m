function outname = uvincfile(inloc,adcpfile,wantdate,maxdepth,outloc,order)
 # Crate a file like
 #        integer parameter :: lmax=6
 #        real dimension(lmax) :: UCoef,VCoef
 #C projection of U velocity from 2011-Nov-24 upper 150 m
 #        parameter(Ucoef=(/+0.090021,-0.324402,+0.048989,+0.143456,+0.028982,-0.119650/))
 #C projection of V velocity from 2011-Nov-24 upper 150 m
 #        parameter(Vcoef=(/-0.0278478 +0.1446929 +0.0751749 +0.0310151 +0.0487805 -0.0327094/))
 outname = ["UVCoefz0to" num2str(maxdepth) datestr(wantdate,"mmm-dd-yyyy") ".inc"];
 [Ucoef,Vcoef] = uvLegendre(inloc,adcpfile,wantdate,maxdepth,order);
 leadspace = "        ";
 incid = fopen([outloc outname],"w")
 fprintf(incid,"%s\n",["C low pass velocity from " adcpfile ".nc"]);
 fprintf(incid,"%s\n",[leadspace "integer parameter :: lmax=" num2str(order) ]);
 fprintf(incid,"%s\n",[leadspace "real dimension(lmax) :: UCoef,VCoef" ]);
 fprintf(incid,"%s\n",["C projection of U velocity from " datestr(wantdate,"mmm-dd-yyyy") " upper " num2str(maxdepth) " m"]);
 fprintf(incid,"%s\n",[leadspace "parameter(Ucoef=(/" num2str(Ucoef) "/))" ]);
 fprintf(incid,"%s\n",["C projection of V velocity from " datestr(wantdate,"mmm-dd-yyyy") " upper " num2str(maxdepth) " m"]);
 fprintf(incid,"%s\n",[leadspace "parameter(Vcoef=(/" num2str(Vcoef) "/))" ]);
 fclose(incid)
end%function