function [outnc] = fluxfromrst(ncfile,outloc)
	switch nargin()
		case 1
			idx = find('.'==ncfile);
			outnc = [ncfile(1:idx-1) '_flux.nc']
		case 2
			idx = find('.'==ncfile);
			idxdir = max(find('/'==ncfile));
			outnc = [outloc ncfile(idxdir+1:idx-1) '_flux.nc']
	end
	idstring = padint2str(mod(floor(100*time),1e6),6);
	unix(['ncap2 -O -t 4 -S /home/mhoecker/work/Dynamo/octavescripts/heatflux.nco ' ncfile ' ' outnc]);
	
