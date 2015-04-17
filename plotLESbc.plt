#plotLESbc.plt
# need to skip first 3 lines
# data order
# time, swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle
#
form="%f%f%f%f%f%f%f%f%f%f";
print file.".bc"
set term png
set style data linespoints
#file = "Surface_Flux_328-330"
set output file."swf_top.png"
plot file.".bc" using 1:2 every ::3 title "swf_top"#,\
#file.".dat" binary format=form using 1:2
#
set output file."hf_top.png"
plot file.".bc" using 1:3 every ::3 title "hf_top"#,\
#file.".dat" binary format=form using 1:3
#
set output file."lhf_top.png"
plot file.".bc" using 1:4 every ::3 title "lhf_top"#,\
#file.".dat" binary format=form using 1:4
#
set output file."rain.png"
plot file.".bc" using 1:5 every ::3 title "rain"#,\
#file.".dat" binary format=form using 1:5
#
set output file."ustr_t.png"
plot file.".bc" using 1:6 every ::3 title "ustr_t"#,\
#file.".dat" binary format=form using 1:6
#
set output file."vstr_t.png"
plot file.".bc" using 1:7 every ::3 title "vstr_t"#,\
#file.".dat" binary format=form using 1:7
#
set output file."wave_l.png"
plot file.".bc" using 1:8 every ::3 title "wave_l"#,\
#file.".dat" binary format=form using 1:8
#
set output file."wave_h.png"
plot file.".bc" using 1:9 every ::3 title "wave_h"#,\
#file.".dat" binary format=form using 1:9
#
set output file."w_angle.png"
plot file.".bc" using 1:10 every ::3 title "w_angle"#,\
#file.".dat" binary format=form using 1:10
#
