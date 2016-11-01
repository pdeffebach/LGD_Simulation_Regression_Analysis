function negll = negloglikib_peter(parameters, X, Y)

% IB regression negative log likelihood. 

K = size(X, 2);
N = size(X, 1);

beta = parameters(1:K);
gamma = parameters(K+1:2*K);
r = parameters(2*K+1:3*K);

logph = parameters(3*K+1);

ph = exp(logph);
P0 = exp(X*beta)./(1+exp(X*beta)+ exp(X*gamma) );
P1 = exp(X*gamma)./(1+exp(X*beta)+ exp(X*gamma) );
P01 = 1 - P0 - P1;
mu = 1./(1+exp(-X*r));

% Solve for beta parameters that set the mean equal to mu and phi to what
% we want.
%-------------------------------------------------------------------------%
a = mu*ph;  % parametrizing to put into matlab. See Ospina Ferrari (2010a)
b = (1-mu)*ph;
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
ll=zeros(N,1);
ll(Y==0) = log(P0(Y==0));
ll(Y==1) = log(P1(Y==1));
asubset = a(Y>0 & Y<1);
bsubset = b(Y>0 & Y<1);
ll(Y>0 & Y<1) = log(P01(Y>0 & Y<1)) + log(betapdf(Y(Y>0 & Y<1),asubset,bsubset));
%-------------------------------------------------------------------------%

negll = -sum(ll);
    
    
         
        
        

