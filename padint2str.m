function str = padint2str(int,len)
if(int==0)
	prepad=1;
else
	prepad = 1+floor(log(abs(int))/log(10));
endif
str = int2str(abs(int));
for i=prepad:len-1
	str = ["0" str];
endfor
if(int<0)
	str = ["-" str];
endif
end
