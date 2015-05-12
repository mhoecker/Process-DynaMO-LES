function testfig(outdir)
 [useoctplot,t0sim,dsim,tfsim] = plotparam(outdir);
 if(useoctplot!=1)
  testfile = [outdir "test.plt"];
  fid = fopen(testfile,"w");
  fprintf(fid,"load '%slimits.plt'\n",outdir);
  fprintf(fid,"set output outdir.'test'.termsfx\n");
  fprintf(fid,"test\n",tfsim);
  fclose(fid);
  unix(["gnuplot " testfile]);
 end%if
end%function
