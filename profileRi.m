function [Ri,rho,Sh,Nsq] = profileRi(U,V,zuv,T,Sal,zTS)
 % Calculate the Richardson given a velocity and TS profile
 findgsw;
 ddzuv = ddz(zuv);
 ddzTS = ddz(zTS);
 pTS = gsw_p_from_z(zTS,0);
 pref = mean(PTS);
 SA = gsw_SA_from_SP(sss,80.5+0*sss,0*sss,0*sss);
 rho = gsw_rho(T,SA,0);
 Ri = Nsq./(Sh.^2);
end%function

