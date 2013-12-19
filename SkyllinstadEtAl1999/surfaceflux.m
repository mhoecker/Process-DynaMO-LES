function [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,cp,sigH] = surfaceflux(sfxnc,trange)
 % Extract Flux data
 field = ["Yday";"stress";"P";"Wdir";"SST";"SalTSG";"cp";"sigH"];
 field = [field;"shf";"lhf";"rhf";"Solarup";"Solardn";"IRup";"IRdn"];
 % Some other things to extract
 % "Precip";
 sfx = surfluxvars(sfxnc,field,trange);
 tsfx = sfx.Yday;
 stress = sfx.stress;
 p = sfx.P;
 Jh = sfx.shf+sfx.lhf+sfx.rhf+sfx.Solarup+sfx.Solardn+sfx.IRup+sfx.IRdn;
 wdir = sfx.Wdir;
 sst = sfx.SST;
 SalTSG = sfx.SalTSG;
 SolarNet = sfx.Solarup+sfx.Solardn;
 cp = sfx.cp;
 sigH = sfx.sigH;
end%function
