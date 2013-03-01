function myplot(output,x,y,axeslabels,termtype)
	tmp = '/home/mhoecker/tmp/';
#	Set default values
	switch nargin()
		case 2	# fill y with index numbers
			N = length(x);
			y = 1:N;
			clear N
			axeslabels = {'x','y','title'};
			termtype = 'png';
		case 3	# fill y with index numbers
			axeslabels = {'x','y','title'};
			termtype = 'png';
		case 4
			termtype = 'png';
	end
	Sy = size(y);
	[termtxt,termsfx] = termselect(termtype);
#	Hopefully unique idstring;
	idstring = padint2str(mod(floor(100*time),1e6),6);
	datfile = [tmp idstring '.dat'];
	pltfile = [tmp idstring '.plt'];
	form = binarray(x,y,datfile);
	[termtxt,termsfx] = termselect(termtype);
	outfile = [output termsfx];
#
	fid = fopen(pltfile,"w");
#
	fprintf(fid,"set terminal %s\n",termtxt);
	fprintf(fid,"set output '%s'\n",outfile);	
	fprintf(fid,"set xtics out nomirror rotate by -30\n");
	fprintf(fid,"set ytics out nomirror\n");
	fprintf(fid,"set xlabel '%s'\n",axeslabels{1});
	fprintf(fid,"set ylabel '%s'\n",axeslabels{2});
	fprintf(fid,"set title '%s'\n",axeslabels{3});
	fprintf(fid,"set xrange [%f:%f]\n",min(x),max(x));
	fprintf(fid,"set yrange [%f:%f]\n",min(min(y)),max(max(y)));
	for i=4:length(axeslabels)
		fprintf(fid,'%s\n',axeslabels{i});
	endfor
	fprintf(fid,"plot '%s' %s u 1:2 notitle\\\n",datfile,form);
	for i=1:Sy(1)-1
		fprintf(fid,", '%s' %s u 1:%s notitle\\\n",datfile,form,int2str(i+2));
	endfor
	fprintf(fid,"\n");
	fclose(fid);
	unix(['gnuplot ' pltfile ' && rm ' datfile ' && mv ' pltfile ' ' tmp 'old.plt']);

