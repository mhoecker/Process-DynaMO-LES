function outfile = plotslice(output,z,x,y,axeslabels,termtype)
#function outfile = plotslice(output,z,x,y,axeslabels,termtype)
#
	tmp = '/home/mhoecker/tmp/';
#
#	Set default values
	switch nargin()
		case 2	# fill x,y with index numbers
			N = size(z);
			x = 1:N(1);
			y = 1:N(2);
			clear N
			axeslabels = {'x','y','z'}
			termtype = 'png';
		case 3	# fill y with index numbers
			N = size(z);
			y = 1:N(2);
			clear N
			axeslabels = {'x','y','z'}
			termtype = 'png';
		case 4
			axeslabels = {'x','y','z'}
			termtype = 'png';
		case 5
			termtype = 'png';
	end
#	Hopefully unique idstring;
	idstring = padint2str(mod(floor(100*time),1e6),6);
	datfile = [tmp idstring '.dat'];
	pltfile = [tmp idstring '.plt'];
	binmatrix(x,y,z,datfile,"w");
	[termtxt,termsfx] = termselect(termtype);
	outfile = [output termsfx];
	zmax = max(max(z));
	zmin = min(min(z));
#
	fid = fopen(pltfile,"w");
#
	fprintf(fid,"set terminal %s\n",termtxt);
	fprintf(fid,"set output '%s'\n",outfile);	
	fprintf(fid,"set view map\n");
	fprintf(fid,"set size ratio -1\n");
	fprintf(fid,"set pm3d\n");
	fprintf(fid,"set palette mode HSV\n");
	fprintf(fid,"set palette maxcolor 128 function .8*(1-gray),.5+.5*ceil(127./128-gray),.5+.5*floor(127./128+gray)\n");
	fprintf(fid,"unset surface\n");
	fprintf(fid,"unset key\n");
	fprintf(fid,"set xtics out nomirror rotate by -30\n");
	fprintf(fid,"set ytics out nomirror\n");
	fprintf(fid,"set size ratio -1\n");
#
	fprintf(fid,"set xlabel '%s'\n",axeslabels{1});
	fprintf(fid,"set ylabel '%s'\n",axeslabels{2});
	fprintf(fid,"set title '%s'\n",axeslabels{3});
	fprintf(fid,"set xrange [%f:%f]\n",min(x),max(x));
	fprintf(fid,"set yrange [%f:%f]\n",min(y),max(y));
	if(zmax*zmin>=0)
		fprintf(fid,"set cbrange [%e:%e]\n",min(min(z)),max(max(z)));
	else
		fprintf(fid,"set cbrange [-%e:%e]\n",sqrt(-zmax*zmin),sqrt(-zmax*zmin));
	end
	for i=4:length(axeslabels)
		fprintf(fid,'%s\n',axeslabels{i});
	endfor
	fprintf(fid,"splot '%s' matrix binary notitle\n",datfile);
	fclose(fid);
	unix(['gnuplot ' pltfile ' && rm ' datfile ' ' pltfile]);
