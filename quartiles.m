function [quart1 quart3 q02 q98]=quartiles(x)
x=sort(x,'ascend');nx=length(x);

n02=floor(nx*.02);q02=x(n02);
nx1=floor(nx/4);quart1=x(nx1);
nx3=ceil(3*nx/4);quart3=x(nx3);
n98=floor(nx*.98);q98=x(n98);
end