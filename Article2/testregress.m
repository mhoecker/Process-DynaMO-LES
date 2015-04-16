#testregress
N = 10;
x = [ones(1,N);1:10]
y = rand(1,N)+[1,2]*x
[p,e_var,r,p_var,y_var] = LinearRegression(x',y');
p'*x
plot(y-p'*x)
