function testpaltext(dir,N)
 %
 if(nargin<1)
  dir="/home/mhoecker/tmp/"
 end%if
 if nargin<2
  N=21;
 end%if
 paltypes = {"hue","euh","pos","neg","negnan","posnan","pm","pmnan","circle","zissou","zissoublocks","grey"};
 types = length(paltypes);
 [term,sfx] = termselect("pngposter");
 for i=1:types
  paltype = paltypes{i};
  outfile = [dir paltype];
  outplt = [outfile ".plt"];
  outsfx = [outfile sfx];
  fid = fopen(outplt,"w");
  pal = paltext(paltype,N);
  fprintf(fid,'set term %s\n',term);
  fprintf(fid,'set output "%s"\n',outsfx);
  fprintf(fid,'set samples %i\n',2*N-1);
  fprintf(fid,'%s\n',pal);

  fprintf(fid,'test palette\n');
  fclose(fid)
  unix(["gnuplot " outplt]);
 end%for
end%function
