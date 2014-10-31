#plotLESbc.plt
# need to skip first 3 lines
# data order
# time, swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle
#
set term png
set style data
set lines lc -1
file = "Surface_Flux_328-330"
set output file."swf_top.png"
plot file.".bc" using 1:2 every ::3
set output file."hf_top.png"
plot file.".bc" using 1:3 every ::3
set output file."lhf_top.png"
plot file.".bc" using 1:4 every ::3
set output file."rain.png"
plot file.".bc" using 1:5 every ::3
set output file."ustr_t.png"
plot file.".bc" using 1:6 every ::3
set output file."vstr_t.png"
plot file.".bc" using 1:7 every ::3
set output file."wave_l.png"
plot file.".bc" using 1:8 every ::3
set output file."wave_h.png"
plot file.".bc" using 1:9 every ::3
set output file."w_angle.png"
plot file.".bc" using 1:10 every ::3
