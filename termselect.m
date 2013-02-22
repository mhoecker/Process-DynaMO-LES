function [termtxt,termsfx] = termselect(termtype)
# function [temtype,termsfx] = termselect(termtype)
# choose a consistent terminal type for gnuplot
# the options are
#
# 		'epsposter' 15"x10" 48pt text
#		'epsarticle' 9"x6" 12pt text
#		'epsarticlesmall' 4.5"x3" 10pt font
#		
#		if the term type is unrecognized the funtion returns values for a png
#
if(nargin<1)
	termtype = "";
endif
	switch(termtype)
		case 'epsposter'
			termtxt = 'postscript eps enhanced color size 12in,9in font "Helvetica,48" blacktext linewidth 2';
			termsfx = '.eps';
		case 'pngposter'
			# if blown up to 12inx9in creates a 300dpi image
			termtxt = 'png enhanced butt truecolor size 3600,2700 crop font "Helvetica,64" linewidth 6';
			termsfx = '.png';
		case 'epsarticle'
			termtxt = 'postscript eps enhanced color size 9in,6in font "Helvetica,12" blacktext linewidth 2';
			termsfx = '.eps';
		case 'epsarticlesmall'
			termtxt = 'postscript eps enhanced color size 4.5in,3in font "Helvetica,10" blacktext linewidth 2';
			termsfx = '.eps';
		otherwise
			termtxt = "png enhanced size 1536,1024 truecolor crop linewidth 2";
			termsfx = '.png';
	end
end
