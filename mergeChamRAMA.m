function merged = MergeChamRAMA(chamnc,ramanc,mergenc)
%
%

% Read Cham, get Cham.(S,T,Z,t)

% Read RAMA get RAMA.(U,V,Z,t,lat,long)

% Convert to Absolute Salinity and conservative temperature (if nec)
%Cham.SA,Cham.CT=SA_CT_from_Spsu_Tinsitu(S,T,z,lat,long)

% Determine which is more fine grained (probably Cham)
% and use it for the mereged data

%Cham.dt = abs(mean(diff(Cham.t)));
%RAMA.dt = abs(mean(diff(RAMA.t)));
%if(RAMA.dt>CHAM.dt)
% mereged.t = Cham.t
%else
% mereged.t = RAMA.t
%end%if

%Cham.dz = abs(mean(diff(Cham.Z)));
%RAMA.dz = abs(mean(diff(RAMA.Z)));
%if(RAMA.dz>Cham.dz)
% mereged.z = Cham.z
%else
% mereged.z = RAMA.z
%end%if
%
% Interpolate the course Z onto the fine z
% RAMAzval = ddzinterp(RAMA.Z,mereged.z,interp_order);
% Interpolate the course t onto the fine t
% RAMAtval = ddzinterp(RAMA.t,mereged.t,interp_order);

% mereged.u = RAMAzval*RAMA.U*RAMAtval;
% mereged.v = RAMAval*RAMA.V*RAMAtval;

% Interpolate the course Z onto the fine z
% Chamzval = ddzinterp(Cham.Z,mereged.z,interp_order);
% Interpolate the course t onto the fine t
% Chamtval = ddzinterp(Cham.t,mereged.t,interp_order);

%mereged.T = Chamzval*Cham.T*Chamtval;
%mereged.S = Chamzval*Cham.S*Chamtval;
%
