%Warm layer calculation as per Fairall et al. 1996
%Input data from normal flux file
%data saved in output matrix dt
%Ts=tsnk;   tsg_depth=0.05;%Use sea snake for water T, depth of snake is 0.05 m
%*******************  set constants  ****************
	tdk=273.16;
	gravx=9.72;
	Rgas=287.1;
	cpa=1004.67;
	rhoair=1010*100./(Rgas*(ta+tdk).*(1+0.61*qa/1000));
	ii=find(isfinite(tsnk));Le=(2.501-.00237*median(tsnk(ii)))*1e6;
	
	be=0.026;
	cpw=4000;
	rhow=1022;
	visw=1e-6;
	tcw=0.6;
   
%***********************   make modifications, calibrations, limit tests, etc

%**************   set instrument heights
zu=zu_etl;
zt=zt_etl;
zq=zq_etl;

jcool=1;
jwarm=1;
icount=1;
%*********************  housekeep variables  ********	
qcol_ac=0;
qjoule=0;
tau_ac=0;
jtime=0;
jamset=0;
tau_old=.06;
hs_old=10;
hl_old=100;
dsea=0;
dseag=0;
dt_wrm=0;
tk_pwp=0;
dtx=[];
fxp=.7;
nx=8080;				%# of lines of data  

[nn,nx]=size(x');
ijx=1;
d1=datenum('31-Dec-2003');
clear dt;


for ibg = 1:nx 			%major read loop
	%***********   set variables not in data base  ********
	P=barpress(ibg);                     %air pressure
	us=0;                       %surface current
	zi=600;                    %inversion ht
			%*******   decode date  ************
         
         
   [iyr mon iday ihr imin isec]=datevec(jdy(ibg)+d1);      
   
	%mon=fix(stux(1)/1e8)-iyr*100;
	%iday=fix(stux(1)/1e6)-iyr*1e4-mon*100;
	%ihr=fix(stux(1)/1e4)-iyr*1e6-mon*1e4-iday*100;
	%imin=fix(stux(1)/100)-fix(stux(1)/1e4)*100;
	%isec=0;
	timex=[iyr mon iday ihr imin isec];
	jd=jdy(ibg);
		%********   decode bulk met data ****
   u=U(ibg);%   
   phirel=reldir(ibg);%relative wind direction
	tsea=Ts(ibg);%bulk sea surface temp
	t=ta(ibg);%air temp
	qs=qse(ibg);%bulk sea surface humidity
	q=qa(ibg);%air humidity
	Rs=rs(ibg);%downward solar flux
	Rl=rl(ibg);%doward IR flux
   rain=org(ibg);%rain rate
%    jt=Jm(ibg);
%    oph=10;%ophir data quality (bad=>15)
%    tilt=tiltx(ibg);%flow tilt, fixed frame
%    jm=Jm(ibg);%ship manauver index
   lonn=Lon(ibg);%longitude
   latx=Lat(ibg);
  %  zu=17.5;%sensor height
  %  zq=zu;
  %  zt=zu;
   ts_depth=zts(ibg);%.05;%bulk water temperature sensor depth
  
   %*****  variables for warm layer  ***
	ntime=1e6*mon+1e4*iday+100*ihr+imin;
	time=(ihr*3600+imin*60)/24/3600;
	intime=time;
	loc=(lonn+7.5)/15;
	Rnl=.97*(5.67e-8*(tsea+273.16)^4-Rl);
	Rns=.945*Rs;
	%*********   set condition dependt stuff ******
	Le=(2.501-.00237*tsea)*1e6;
	cpv=cpa*(1+0.84*q/1000);
	rhoa=P*100/(Rgas*(t+tdk)*(1+0.61*q/1000));
	visa=1.325e-5*(1+6.542e-3*t+8.301e-6*t*t-4.8e-9*t*t*t);
	Al=2.1e-5*(tsea+3.2)^0.79;

	%**************   apply warm layer  ***********;
	if jwarm==1;                                            %do warm layer
		chktime=loc+intime*24;
		newtime=(chktime-24*fix(chktime/24))*3600;
		if icount>1                                     %not first time thru
			if newtime>21600 & jump==1
				%goto 16
			else
				if newtime <jtime		%re-zero at midnight
					jamset=0;
					fxp=.5;
					tk_pwp=19;
					tau_ac=0;
					qcol_ac=0;
					dt_wrm=0;
					jump=0;                   %goto 16
				else
						%****   set warm layer constants  ***
					rich=.65;                		%crit rich	
					ctd1=sqrt(2*rich*cpw/(Al*gravx*rhow));
					ctd2=sqrt(2*Al*gravx/(rich*rhow))/(cpw^1.5);
						%*********************************
					dtime=newtime-jtime;			%delta time for integrals
					qr_out=Rnl+hs_old+hl_old+RF_old;	%total cooling at surface
					q_pwp=fxp*Rns-qr_out;			%tot heat abs in warm layer
					if q_pwp<50 & jamset==0			%check for threshold
						%goto 16		
					else
						jamset=1;			%indicates threshold crossed
						tau_ac=tau_ac+tau_old*dtime;	%momentum integral
						if qcol_ac+q_pwp*dtime>0	%check threshold for warm layer existence
							for i=1:5		%loop 5 times for fxp
								fxp=1-(0.28*0.014*(1-exp(-tk_pwp/0.014))+0.25*0.357*(1-exp(-tk_pwp/0.357))+0.47*12.82*(1-exp(-tk_pwp/12.82)))/tk_pwp;
                              %	fxp=1-(0.28*0.014*(1-exp(-tk_pwp/0.014))+0.35*0.357*(1-exp(-tk_pwp/0.357))+0.37*12.82*(1-exp(-tk_pwp/12.82)))/tk_pwp;
                              %  fxp=1-(0.28*0.014*(1-exp(-tk_pwp/0.014))+0.15*0.357*(1-exp(-tk_pwp/0.357))+0.57*12.82*(1-exp(-tk_pwp/12.82)))/tk_pwp;
%                                 fxp=1-(0.50*.014*(1-exp(-tk_pwp/0.014))+0.28*1.4*(1-exp(-tk_pwp/1.4))+0.22*7.9*(1-exp(-tk_pwp/7.9)))/tk_pwp;

                                
                        %fg=fpaul(tk_pwp);fxp=fg(1);
                        qjoule=(fxp*Rns-qr_out)*dtime;
								if qcol_ac+qjoule>0
									tk_pwp=min(19,ctd1*tau_ac/sqrt(qcol_ac+qjoule));
								end;
							end;%  end i loop
						else				%warm layer wiped out
							fxp=0.75;
							tk_pwp=19;
						end;%   end sign check on qcol_ac
						qcol_ac=qcol_ac+qjoule;		%heat integral
							%*******  compute dt_warm  ******
						if qcol_ac>0
							dt_wrm=ctd2*(qcol_ac)^1.5/tau_ac;
						else 
							dt_wrm=0;
						end;
					end;%                    end threshold check
				end;%                            end midnight reset
				if tk_pwp<ts_depth
					dsea=dt_wrm;
				else
					dsea=dt_wrm*ts_depth/tk_pwp;
				end;
						end;%                                    end 6am start first time thru
		else
			jump=1;					%idicates data start period
		end;%                                            end first time thru check
		jtime=newtime;
	end;%                                                     end warm layer model appl check
	
	if tk_pwp<tsg_depth;%compute heating at tsg
		dseag=0;
	else
		dseag=dt_wrm*(tk_pwp-tsg_depth)/tk_pwp;
	end;
   ts=tsea+dsea;
   qs=qsea(ts);
	xx=[u us ts t qs q Rs Rl rain zi  P zu(ibg) zt(ibg) zq(ibg) latx jcool 0 0 0] ;		%set data for basic flux alogithm
		%********    call modified LKB routine *******
	%y=cor30a(xx);%latest version coare model
    cpx=NaN;sigHx=NaN;
   % rhx=relhum5([t q P]);
    y=[];Bx=[];Bx=coare35vn_cool_a(u,zu(ibg),t,zt(ibg),RH(ibg),zq(ibg),P,ts,Rs,Rl,latx,zi,org(ibg),cpx,sigHx);
    %B=[usr tau hsb hlb hbb hsbb hlwebb tsr qsr zot zoq Cd Ch Ce  L zet dter dqer tkt Urf Trf Qrf RHrf UrfN Rnl Le rhoa UN U10 U10N Cdn_10 Chn_10 Cen_10 RF Qs Evap];
    %   1   2   3   4   5   6    7      8   9  10  11  12 13 14 15 16   17   18   19  20  21  22  23   24   25 26  27  28  29  30    31     32     33   34 35  36
    zoux=10/exp(.4/sqrt(Bx(31)/1e3));
    y(1)=Bx(3);y(2)=Bx(4);y(3)=Bx(2);y(4)=zoux;y(5)=Bx(10);y(6)=Bx(11);y(7)=Bx(15);y(8)=Bx(1);y(9)=Bx(8);y(10)=Bx(9);
    y(11)=Bx(17);y(12)=Bx(18);y(13)=Bx(19);y(14)=Bx(34);y(15)=NaN;y(16)=Bx(12);y(17)=Bx(13);y(18)=Bx(14);y(19)=Bx(31);y(20)=Bx(32);
    y(21)=Bx(33);y(22)=NaN;
		%************* output from routine  *****************************
         hsbo=y(1);                   %sensible heat flux W/m/m
         hlbo=y(2);                   %latent
         tauo=y(3);                   %stress
%         zo=y(4);                    %vel roughness
%         zot=y(5);                   %temp "
%         zoq=y(6);                   %hum  "
%         L=y(7);                     %Ob Length
%         usr=y(8);                   %ustar
%         tsr=y(9);                   %tstar
%         qsr=y(10);                  %qstar  [g/g]
        dter=y(11);                 %cool skin delta T
         dqer=y(12);                 %  "   "     "   q
%         tkt=y(13);                  %thickness of cool skin 
       RF=y(14);                   %rain heat flux
%         Wbar_webb=y(15);            %webb mean w 
%         Cd=y(16);                   %drag @ zu
%         Ch=y(17);                   %
%         Ce=y(18);                   %Dalton
%         Cdn_10=y(19);               %neutral drag @ 10 [includes gustiness]
%         Chn_10=y(20);               %
%         Cen_10=y(21);               %
        zax(1)=jd;                  %julian day
        zax(2:10)=xx(1:9);           %
        zax(4)=ts;                %Tsea [no cool skin]
        zax(11:32)=y;               %
        zax(33:36)=[dt_wrm tk_pwp ts dseag];  %warm layer deltaT, thickness, corrected Tsea
	%*******   previous values from cwf hp basic code *****
% 	hsx=Hsb(ibg);
% 	hlx=Hlb(ibg);
%    taux=Taub(ibg);
%    
	%********************  save various parts of data **********************************
	%zax(35:38)=[hsx hlx taux zu];
   dt(ibg,:)=zax;
   %[jd  u  us  Tsea[no cool skin]  t qs q Rs  Rl rain hsb hlb tau zo zot zoq L  usr tsr qsr dter dqer tkt RF wbar Cd  Ch  Ce Cdn_10 Chn_10 Cen_10 ug dt_wrm tk_pwp  ts]
   %  1  2   3          4           5 6  7  8  9  10   11  12  13  14 15  16  17 18  19  20  21   22   23  24 25   26  27  28   29     30     31   32   33      34   35
   
   %struc(ibg,:)=[ct cq cu cw];
     
%   eyes(ibg,:)=[jt oph tilt jm phirel];
	e=[num2str(mon) '  ' num2str(iday) '  ' num2str(ihr) '   ' num2str(dter) '  ' num2str(dt_wrm) '  ' num2str(tk_pwp) ];
	disp(e)
	hs_old=hsbo;
	hl_old=hlbo;
	RF_old=RF;
	tau_old=tauo;
   icount=icount+1;
   if phirel<90 | phirel>270  %save subset with good wind direction
      dtx(ijx,:)=zax;
      %idfx(ijx,:)=[hsix hlix tauix];   
      ijx=ijx+1;
   end;
end; %  data line loop

pst=psitg(zq./dt(:,17));
[np,a]=size(dt);
dtw=dt(:,33);
zw=dt(:,34);
tkt=dt(:,23);
dtgw=dt(:,36);

Hsbb=dt(:,11);
Hlbb=dt(:,12);
HRF=dt(:,24);
Taubb=dt(:,13);

