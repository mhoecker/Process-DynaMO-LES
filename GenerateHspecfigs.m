ensureSkyllingstad1999;
addpath spectra
plotdir = "/home/mhoecker/work/Dynamo/plots/";
datsdir = "/home/mhoecker/work/Dynamo/output/";
% run 7
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_7200_rst.nc"],[ plotdir "run7/dissipation/7200"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_14400_rst.nc"],[ plotdir "run7/dissipation/14400"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_21600_rst.nc"],[ plotdir "run7/dissipation/21600"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_28800_rst.nc"],[ plotdir "run7/dissipation/28800"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_36000_rst.nc"],[ plotdir "run7/dissipation/36000"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_43200_rst.nc"],[ plotdir "run7/dissipation/43200"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_50400_rst.nc"],[ plotdir "run7/dissipation/50400"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_57600_rst.nc"],[ plotdir "run7/dissipation/57600"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_64800_rst.nc"],[ plotdir "run7/dissipation/64800"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_72000_rst.nc"],[ plotdir "run7/dissipation/72000"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_79200_rst.nc"],[ plotdir "run7/dissipation/79200"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-a_86400_rst.nc"],[ plotdir "run7/dissipation/86400"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-b_108000_rst.nc"],[ plotdir "run7/dissipation/108000"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-b_129600_rst.nc"],[ plotdir "run7/dissipation/129600"]);
%Hspectra([ datsdir "run7/dyno_328Rev_4-b_151200_rst.nc"],[ plotdir "run7/dissipation/151200"]);
%
% run 8
%/home/mhoecker/work/Dynamo/output/run8/dyno_328Rev_5-a_21600_rst.nc
%Hspectra([ datsdir "run8/dyno_328Rev_5-a_64800_rst.nc"],[ plotdir "run8/dissipation/108000"]);
%Hspectra([ datsdir "run8/dyno_328Rev_5-a_64800_rst.nc"],[ plotdir "run8/dissipation/86400"]);
%Hspectra([ datsdir "run8/dyno_328Rev_5-a_64800_rst.nc"],[ plotdir "run8/dissipation/64800"]);
%Hspectra([ datsdir "run8/dyno_328Rev_5-a_43200_rst.nc"],[ plotdir "run8/dissipation/43200"]);
%Hspectra([ datsdir "run8/dyno_328Rev_5-a_21600_rst.nc"],[ plotdir "run8/dissipation/21600"]);
%
% yellowstone 2
%plotdir = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone2/";
%datsdir = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone2/";
%Hspectra([ datsdir "o512_1-b_3600_rst.nc" ],[ plotdir "03600"]);
%Hspectra([ datsdir "o512_1-c_14400_rst.nc"],[ plotdir "14400"]);
%Hspectra([ datsdir "o512_1-d_28800_rst.nc"],[ plotdir "28800"]);
%Hspectra([ datsdir "o512_1-e_36000_rst.nc"],[ plotdir "36000"]);
%Hspectra([ datsdir "o512_1-f_43200_rst.nc"],[ plotdir "43200"]);
%Hspectra([ datsdir "o512_1-g_50400_rst.nc"],[ plotdir "50400"]);
%
% yellowstone 3
%plotdir = [plotdir "/yellowstone3/dissipation/"];
%datsdir = [datsdir "/yellowstone3/"];
%Hspectra([ datsdir "o1024_1-a_7200_rst.nc" ], [ plotdir "07200a"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "07200aSpectra-tke -n " plotdir "07200aHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-a_21600_rst.nc" ],[ plotdir "21600a"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "21600aSpectra-tke -n " plotdir "21600aHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-b_14400_rst.nc" ],[ plotdir "14400b"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "14400bSpectra-tke -n " plotdir "14400bHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-b_21600_rst.nc" ],[ plotdir "21600b"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "21600bSpectra-tke -n " plotdir "21600bHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-b_43200_rst.nc" ],[ plotdir "43200b"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "43200bSpectra-tke -n " plotdir "43200bHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-c_14400_rst.nc" ],[ plotdir "14400c"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "14400cSpectra-tke -n " plotdir "14400cHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-c_28800_rst.nc" ],[ plotdir "28800c"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "28800cSpectra-tke -n " plotdir "28800cHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-c_64800_rst.nc" ],[ plotdir "64800c"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "64800Spectra-tke -n " plotdir "64800Hspectra -t mov"])
%Hspectra([ datsdir "o1024_1-d_86400_rst.nc" ],[ plotdir "86400d"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "86400dSpectra-tke -n " plotdir "86400dHspectra -t mov"])
%Hspectra([ datsdir "o1024_1-e_108000_rst.nc" ],[ plotdir "108000e"]);
%unix(["/home/mhoecker/bin/pngmovie.sh -l " plotdir "108000eSpectra-tke -n " plotdir "108000eHspectra -t mov"])
% yellowstone 6
plotdir = [plotdir "yellowstone7/dissipation/"];
datsdir = [datsdir "yellowstone7/"];
dagfile = 'd1024_1_dag.nc';
commonroot = 'yellowstone6/dissipation/';
commonsfxs = {'Spectra-tke','Spectra-u','Spectra-v','Spectra-w','Spectra-t'};
%
newtime = 21600;
newroot = [num2str(newtime,"%i") "a"];
%
%Hspectra([ datsdir "d1024_1-a_21600_rst.nc" ], [ plotdir newroot],[datsdir dagfile]);
roots = {};
for i=1:length(commonsfxs)
 roots = {roots{:},[newroot commonsfxs{i}]};
end%for
plotspecVvar(roots,plotdir,plotdir);
%
newtime = 43200;
newroot = [num2str(newtime,"%i") "a"];
%Hspectra([ datsdir "d1024_1-a_43200_rst.nc" ], [ plotdir newroot],[datsdir dagfile]);
%
roots = {};
for i=1:length(commonsfxs)
 roots = {roots{:},[newroot commonsfxs{i}]};
end%for
plotspecVvar(roots,plotdir,plotdir)
%
newtime = 64800;
newroot = [num2str(newtime,"%i") "b"];
%Hspectra([ datsdir "d1024_1-b_64800_rst.nc" ], [ plotdir newroot],[datsdir dagfile]);
%
roots = {};
for i=1:length(commonsfxs)
 roots = {roots{:},[newroot commonsfxs{i}]};
end%for
plotspecVvar(roots,plotdir,plotdir)
%
newtime = 86400;
newroot = [num2str(newtime,"%i") "b"];
%Hspectra([ datsdir "d1024_1-b_86400_rst.nc" ], [ plotdir newroot],[datsdir dagfile]);
%
roots = {};
for i=1:length(commonsfxs)
 roots = {roots{:},[newroot commonsfxs{i}]};
end%for
plotspecVvar(roots,plotdir,plotdir)
%
newtime = 86400;
newroot = [num2str(newtime,"%i") "c"];
%Hspectra([ datsdir "d1024_1-c_86400_rst.nc" ], [ plotdir newroot],[datsdir dagfile]);
%
roots = {};
for i=1:length(commonsfxs)
 roots = {roots{:},[newroot commonsfxs{i}]};
end%for
plotspecVvar(roots,plotdir,plotdir)
%
%
%
removeSkyllingstad1999;
