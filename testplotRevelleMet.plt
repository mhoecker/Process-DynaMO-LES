basename = '110928'
metfile = basename.'.MET'
termsfx = ".png"
seconds(x) = x-floor(x/100)*100
minutes(x) = (floor(x/100)-floor(x/10000)*100)
hours(x) = floor(x/10000)
secs(x) = seconds(x)+60*(minutes(x)+60*hours(x))
hrs(x) = secs(x)/3600
set xtics 1
#set ytics
set lmargin at screen .05
set rmargin at screen .7
set key out
set ytics
M = 9
topmar(n) = (2*M-0.25)/(2*M)-(n%M)/(1.0*M)
botmar(n) = (2*M-0.25)/(2*M)-(.75+n%M)/(1.0*M)
n=0;
#set term svg size 1024,768 dynamic enhanced mouse font "Arial,6"
set term png size 1280,1024 enhanced font "Arial,8"
set output basename."1".termsfx
set multiplot
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):2  w linespoints pt 6 title "AT Air Temp (C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):3  w linespoints pt 6 title "BP Barometric Pressure (Pa)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):4  w linespoints pt 6 title "BC Barometric Pressure Temp (C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):5  w linespoints pt 6 title "BS"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):6  w linespoints pt 6 title "RH Relative Humidity (%)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):7  w linespoints pt 6 title "RT Air Temp @RH (C)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):8  w linespoints pt 6 title "DP Dew Point (C)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):9  w linespoints pt 6 title "PR  Precipitation (mm)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):10 w linespoints pt 6 title "LB LWR Body Temp (K)"
unset multiplot
set output basename."2".termsfx
set multiplot
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):11 w linespoints pt 6 title "LT LWR Thermopile (V)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):12 w linespoints pt 6 title "LW Long Wave Radiation (W/m^2)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):13 w linespoints pt 6 title "SW Short Wave Radiation (W/m^2)"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):14 w linespoints pt 6 title "PA Photosynthetically Available Radiation ({/Symbol m}E/m^2s)"
set yrange [0:*]
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):15 w linespoints pt 6 title "WS Relative Wind Speed (m/s)";set autoscale y; set ytics auto
set yrange [0:360]; set ytics 90
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):16 w linespoints pt 6 title "WD Relative Wind Direction (deg)";set autoscale y; set ytics auto
set yrange [0:*]
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):17 w linespoints pt 6 title "TW True Wind Speed (m/s)";set autoscale y; set ytics auto
set yrange [0:360]; set ytics 90
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):18 w linespoints pt 6 title "TI True Wind Direction (deg)";set autoscale y; set ytics auto
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;
plot metfile u (hrs($1)):19 w linespoints pt 6 title "WS_2 Relative Wind Speed (m/s)";set autoscale y; set ytics auto
unset multiplot
set output basename."3".termsfx
set multiplot
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
set yrange [0:360]; set ytics 90
plot metfile u (hrs($1)):20 w linespoints pt 6 title "WD_2 Relative Wind Direction (deg)";set autoscale y; set ytics auto
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
set yrange [0:*]
plot metfile u (hrs($1)):21 w linespoints pt 6 title "TW_2 True Wind Speed (m/s)";set autoscale y; set ytics auto
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
set yrange [0:360]; set ytics 90
plot metfile u (hrs($1)):22 w linespoints pt 6 title "TI_2 True Wind Direction (deg)";set autoscale y; set ytics auto
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):23 w linespoints pt 6 title "TT Thermosalinograph Temp(C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):24 w linespoints pt 6 title "TC Thermosalinograph Conduct corrected (mS/cm)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):25 w linespoints pt 6 title "SA Salinity (psu)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):26 w linespoints pt 6 title "SD {/Symbol s}_t (kg/m^3)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):27 w linespoints pt 6 title "SV Sound Velocity (m/s)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):28 w linespoints pt 6 title "TG Thermosalinograph Conduct uncorrected (mS/cm)"
unset multiplot
set output basename."4".termsfx
set multiplot
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):29 w linespoints pt 6 title "FI USW Flow meter (L/min)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):30 w linespoints pt 6 title "PS Pressure (lbs/in^2)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):31 w linespoints pt 6 title "TT_2 Thermosalinigraph Temp (C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):32 w linespoints pt 6 title "TC_2 Thermosalinigraph Conduct corrected (C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):33 w linespoints pt 6 title "SA_2 Salinity (psu)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):34 w linespoints pt 6 title "SD_2 {/Symbol s}_t (kg/m^3)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):35 w linespoints pt 6 title "SV_2 Sound Velocity (m/s)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):36 w linespoints pt 6 title "TG_2 Thermosalinigraph Conduct uncorrected (C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):37 w linespoints pt 6 title "OC Oxygen Current ({/Symbol m}A)"
unset multiplot
set output basename."5".termsfx
set multiplot
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):38 w linespoints pt 6 title "OT Oxygen Temperature (C)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):39 w linespoints pt 6 title "OX Oxygen (mL/L)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):40 w linespoints pt 6 title "OS Oxygen Saturation Value(mL/L)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):41 w linespoints pt 6 title "FL Flourometer ({/Symbol m}g/L)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):42 w linespoints pt 6 title "FI_2 USW Flow Meter (L/min)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):43 w linespoints pt 6 title "PS_2 Pressure (lbs/in^2)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):44 w linespoints pt 6 title "VP VRU Pitch (deg)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):45 w linespoints pt 6 title "VR VRU Roll (deg)"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):46 w linespoints pt 6 title "VH VRU Heave (m)"
unset multiplot
set output basename."6".termsfx
set multiplot
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):47 w linespoints pt 6 title "VX Ship's List (deg)'"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):48 w linespoints pt 6 title "VY Ship's Trim (deg)'"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;
plot metfile u (hrs($1)):49 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);
set bmargin at screen botmar(n);
n = (n+1)%M ;plot metfile u (hrs($1)):50 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):51 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):52 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):53 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):54 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):55 w linespoints pt 6 title "AT"
unset multiplot
set output basename."7".termsfx
set multiplot
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):56 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):57 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):58 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):59 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):60 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):61 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):62 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):63 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):64 w linespoints pt 6 title "AT"
unset multiplot
set output basename."7".termsfx
set multiplot
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):65 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):66 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):67 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):68 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):69 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):70 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):71 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):72 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):73 w linespoints pt 6 title "AT"
unset multiplot
set output basename."8".termsfx
set multiplot
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):74 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):75 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):76 w linespoints pt 6 title "AT"
set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):77 w linespoints pt 6 title "AT"
#set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):78 w linespoints pt 6 title "AT"
#set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):79 w linespoints pt 6 title "AT"
#set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):80 w linespoints pt 6 title "AT"
#set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):81 w linespoints pt 6 title "AT"
#set tmargin at screen topmar(n);set bmargin at screen botmar(n);n = (n+1)%M ;plot metfile u (hrs($1)):82 w linespoints pt 6 title "AT"
unset multiplot
