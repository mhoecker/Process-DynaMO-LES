%Plot data from filtered series
clear all
xyranges = [0,500,-230,0];
adcpfile = "/home/mhoecker/work/Dynamo/Observations/mat/ADCP/adcp150_filled_with_140_filtered_1hr_3day.mat";
load(adcpfile);
whos
dzmatrix = ddz(z);
thours = 1:size(uhp)(1);
[tt,zz] = meshgrid(thours,z);
Sxhp = dzmatrix*uhp';
Syhp = dzmatrix*vhp';
Sshp = Sxhp.^2+Syhp.^2;
Sxlp = dzmatrix*ulp';
Sylp = dzmatrix*vlp';
Sslp = Sxlp.^2+Sylp.^2;
figure(1)
pcolor(tt,zz,Sshp);shading flat;colorbar; axis(xyranges)
figure(2)
pcolor(tt,zz,Sslp);shading flat;colorbar; axis(xyranges)
clear all
TCChfile = "/home/mhoecker/work/Dynamo/Observations/AurelieObs/TCCham10_leg3filtered.mat";
load(TCChfile);
fileloc = "/home/mhoecker/work/Dynamo/Observations/AurelieObs/";
filename = "TCCham10_leg3";
load([fileloc filename ".mat"])
whos
xyranges = [0,500,-230,0];
dzmatrix = ddz(-TCCham.depth);
thours = 1:size(rhohourly)(2);
[tt,zz] = meshgrid(thours,-TCCham.depth);
nanderhourly = nanstencil(rhohourly,3,1);
sighourly = rhohourly-1000;
sighourly(find(isnan(sighourly)))=0;
drhodzhourly = nanderhourly+dzmatrix*sighourly;
figure(3)
pcolor(tt,zz,drhodzhourly);shading flat; axis(xyranges); caxis([-.3,0]);colorbar
%
nanderlp = nanstencil(rholp,3,1);
siglp = rholp-1000;
siglp(find(isnan(siglp)))=0;
drhodzlp = nanderlp+dzmatrix*siglp;
figure(4)
pcolor(tt,zz,drhodzlp);shading flat;axis(xyranges); caxis([-.3,0]);colorbar
whos
