function [termtxt,termsfx] = termselect(termtype)
# function [temtype,termsfx] = termselect(termtype)
# choose a consistent terminal type for gnuplot
# the options are
#
#		'epsposter' 12"x12" 48pt text
#		'epsarticle' 9"x6" 12pt text
#		'pdfarticlesmall' 4.5"x3" 10pt font
#		'pdfarticle' 9"x6" 12pt text
#		'epsarticlesmall' 4.5"x3" 10pt font
#		'pngposter' is intended to be blown up to 12"x12"
#		'canvas' cerates an interactive web page
#		'epsposterbw' 12"x12" 48pt text monochrome
#		'epsarticlebw' 9"x6" 12pt text monochrome
#		'pdfarticlesmallbw' 4.5"x3" 10pt font monochrome
#		'pdfarticlebw' 9"x6" 12pt text monochrome
#		'epsarticlesmallbw' 4.5"x3" 10pt font monochrome
#		'pngposterbw' is intended to be blown up to 12"x12" monochrome
#
#		if the term type is unrecognized the funtion returns values for a png
#
if(nargin<1)
	termtype = "";
endif
	switch(termtype)
		case 'epsposter'
			type = 'postscript eps'
			termtxt = 'postscript eps enhanced color size 12in,12in font "Helvetica,48" blacktext dashed linewidth 2';
			termsfx = '.eps';
		case 'pngposter'
			# if blown up to 12inx12in creates a 72dpi image
			termtxt = 'png enhanced truecolor size 864,864 nocrop font "Helvetica,16" linewidth 2';
			termsfx = '.png';
		case 'epsarticle'
			termtxt = 'postscript eps enhanced color size 9in,6in font "Helvetica,12" blacktext dashed linewidth 2';
			termsfx = '.eps';
		case 'epsarticlesmall'
			termtxt = 'postscript eps enhanced color size 4.5in,3in font "Helvetica,10" blacktext dashed linewidth 2';
			termsfx = '.eps';
		case 'pdfarticle'
			termtxt = 'pdf enhanced color size 9in,6in font "Helvetica,12" dashed linewidth 2';
			termsfx = '.pdf';
		case 'pdfarticlesmall'
			termtxt = 'pdf enhanced color size 4.5in,3in font "Helvetica,10" dashed linewidth 2';
			termsfx = '.eps';
		case 'canvas'
			termtxt = ' canvas size 1536,1024 jsdir "js" mousing enhanced dashed linewidth 2';
			termsfx = '.html';
		case 'epsposterbw'
			type = 'postscript eps'
			termtxt = 'postscript eps enhanced mono size 12in,12in font "Helvetica,48" blacktext dashed linewidth 2';
			termsfx = '.eps';
		case 'epsarticlebw'
			termtxt = 'postscript eps enhanced mono size 9in,6in font "Helvetica,12" blacktext dashed linewidth 2';
			termsfx = '.eps';
		case 'epsarticlesmallbw'
			termtxt = 'postscript eps enhanced mono size 4.5in,3in font "Helvetica,10" blacktext dashed linewidth 2';
			termsfx = '.eps';
		case 'pdfarticlebw'
			termtxt = 'pdf enhanced mono size 9in,6in font "Helvetica,12" dashed linewidth 2';
			termsfx = '.pdf';
		case 'pdfarticlesmallbw'
			termtxt = 'pdf enhanced mono size 4.5in,3in font "Helvetica,10" dashed linewidth 2';
			termsfx = '.eps';
		otherwise
			termtxt = "png enhanced size 1536,1024 truecolor nocrop linewidth 2";
			termsfx = '.png';
	end
end
