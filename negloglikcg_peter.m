function negll = negloglikcg_peter(parameters, X, Y)

% CG regression negative log likelihood. 

N = length(Y);
K = size(X, 2);

b = parameters(1:K);
theta = exp(X*b);
loga = parameters(K+1); 
a = exp(loga);
loge = parameters(K+2);
e = exp(loge);

ll=zeros(N,1);
ll(Y==0) = log(gamcdf(e,a,theta(Y==0)));
ll(Y==1) = log(1-gamcdf(1+e,a,theta(Y==1)));
ll(Y>0 & Y<1) = log(gampdf(Y(Y>0 & Y<1)+e, a, theta(Y>0 & Y<1)));

negll = -sum(ll);