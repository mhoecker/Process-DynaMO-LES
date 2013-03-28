function myscatter(output,x,y,r,c,axlab,termtype)
#	Set default values
	switch nargin()
		case 2	# fill y with index numbers
			y = cumsum(ones(size(x)));
			c = ones(size(x));
			r = ones(size(x))*sqrt(mean(diff(x).^2));
			axlab = {'x','y','title'};
			termtype = 'png';
		case 3	# set axes labels and term type
			c = ones(size(x));
			r = ones(size(x))*sqrt(((max(x)-min(x))*(max(y)-min(y)))/(4*length(x)));
			axlab = {'x','y','title'};
			termtype = 'png';
		case 4 # set term type
			c = ones(size(x));
			axlab = {'x','y','title'};
			termtype = 'png';
		case 5 # set term type
			axlab = {'x','y','title'};
			termtype = 'png';
		case 6 # set term type
			termtype = 'png';
	end
		
	[termtxt,termsfx] = termselect(termtype);
	outfile = [output termsfx];
	datfile = [output ".dat"];
	pltfile = [output ".plt"];
	binform = binarray(x,[y;r;c],datfile);
	fid = fopen(pltfile,"w");
#
	fprintf(fid,"set terminal %s\n",termtxt);
	fprintf(fid,"set output '%s'\n",outfile);
	fprintf(fid,"unset key\n");
	fprintf(fid,"set palette mode HSV\n");
	fprintf(fid,"set palette maxcolor 128 function .8*(1-gray),.5+.5*ceil(127./128-gray),.5+5*floor(127./128+gray)\n");
	fprintf(fid,"set xtics out nomirror rotate by -30\n");
	fprintf(fid,"set ytics out nomirror\n");
	if(max(c)==min(c))
		fprintf(fid,"set cbrange [0:1]\n");
	end		
	fprintf(fid,"set xlabel '%s'\n",axlab{1});
	fprintf(fid,"set ylabel '%s'\n",axlab{2});
	fprintf(fid,"set title '%s'\n",axlab{3});
	if(min(x)!=max(x))
		fprintf(fid,"set xrange [%f:%f]\n",min(x),max(x));
	end
	if(min(y)!=max(y))
		fprintf(fid,"set yrange [%f:%f]\n",min(min(y)),max(max(y)));
	end
	for i=4:length(axlab)
		fprintf(fid,'%s\n',axlab{i});
	endfor
	fprintf(fid,'plot "%s" %s  u 1:2:3:4 w circles fill transparent solid .25 noborder lc pal ',datfile,binform);
	fprintf(fid,"\n");
	fclose(fid);
	unix(['gnuplot ' pltfile ' && rm ' datfile ' ' pltfile]);
