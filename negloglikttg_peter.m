function negll = negloglikttg_peter(parameters, X, Y)

% TTG regression negative log likelihood. 

N = length(Y);
K = size(X, 2);

b = parameters(1:K);
g = parameters(K+1:2*K);
thetat = exp(X*b);
theta = exp(X*g);
loga = parameters(2*K+1);
a = exp(loga);
loge = parameters(2*K+2);
e = exp(loge);

p1 = gamcdf(e,a,thetat);    % this is essentially P(Y=0) in eqn 24
p2 = gamcdf(e,a,theta);     % similar to denominator of 2nd and 3rd formulas in eqn 24
p3 = gampdf(Y+e,a,theta);   % first term of 2nd formula in eqn 24 
p4 = gamcdf(1+e,a,theta);
ll=zeros(N,1); % initialize

ll(Y==0) = log(p1(Y==0));
ll(Y>0 & Y<1) = log(p3(Y>0 & Y<1)) + log(1-p1(Y>0 & Y<1)) - log(1-p2(Y>0 & Y<1));
ll(Y==1) = log(1-p4(Y==1)) + log(1-p1(Y==1)) - log(1-p2(Y==1)); 
negll = -sum(ll);