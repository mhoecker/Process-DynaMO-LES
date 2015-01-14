function [SA,CT] = SA_CT_from_Spsu_Tinsitu(S,T,P,lat,long)
 findgsw;
 SA = gsw_SA_from_SP(S,P,long,lat);
 CT = gsw_CT_from_t(SA,T,P);
end%function
