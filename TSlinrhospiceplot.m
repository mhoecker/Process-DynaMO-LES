function [TT,SS,spice,spice2,rho] = TSlinrhospiceplot(T,S,alpha,beta)
Tm = nanmean(T);
Ts = sqrt(nanvar(T))/2;
Trange = min(T)-Ts:Ts:max(T)+Ts;
Sm = nanmean(S);
Ss = sqrt(nanvar(S))/2;
Srange = min(S)-Ss:Ss:max(S)+Ss;
[TT,SS] = meshgrid(Trange,Srange);
[spice,spice2,rho] = linearSpice(TT-Tm,SS-Sm,alpha,beta);
contour(TT,SS,rho);
hold on
contour(TT,SS,spice)
contour(TT,SS,spice2)
plot(T,S,".")
hold off
end%function
