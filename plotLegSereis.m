max_order = 11;
max_depth = 228;
font_size = 10;
lw = 2;
[UC,VC,UlC,VlC,t,z]=uvLegSeries("/home/mhoecker/work/Dynamo/Observations/netCDF/ADCP/","adcp150_filled_with_140_filtered_1hr_3day",datenum([2011,11,10])+[0,0],max_order,max_depth);
zl = -1+2*z/max_depth;
yday = t-datenum([2011,1,1])-1;
Legaxis = [1.1*[-1,1],-max_depth,0];
Cofaxis = [min(yday),max(yday),-.8,.8];
for m=1:max_order
 l = legendre(m-1,zl)(1,:);
 UCoefmax = max([abs(UC(:,m))]);
 VCoefmax = max([abs(VC(:,m))]);
 Coefmax = max([UCoefmax,VCoefmax]);
 Cofaxis = [min(yday),max(yday),Coefmax*[-1,1]];
 subplot(2,1,1);
 plot(yday,UC(:,m)-UlC(:,m),[";High Pass P_{" num2str(m-1) "};"],'linewidth',lw,yday,UlC(:,m),[";Low Pass P_{" num2str(m-1) "};"],'linewidth',lw)
 ylabel("U coefficients");
 axis(Cofaxis)

 subplot(2,1,2);
 plot(yday,VC(:,m)-VlC(:,m),[";High Pass P_{" num2str(m-1) "};"],'linewidth',lw,yday,VlC(:,m),[";Low Pass P_{" num2str(m-1) "};"],'linewidth',lw);
 ylabel("V coefficients");
 xlabel("2011 Year Day");
 axis(Cofaxis)

 print(["/home/mhoecker/work/Dynamo/plots/Legendre_of_order" num2str(m) "_fit.png"],"-dpng","-S1280,1024",["-F:" num2str(font_size)])
 close
 subplot(1,1,1)
 plot(l,-z,[";P_{" num2str(m-1) "};"],'linewidth',lw)
 axis(Legaxis)
 print(["/home/mhoecker/work/Dynamo/plots/Legendre_of_order" num2str(m) ".png"],"-dpng","-S1280,1024",["-F:" num2str(font_size)])
 close
end%for
