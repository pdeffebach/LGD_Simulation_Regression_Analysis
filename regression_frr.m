function [phat, EY, stats, std_errors] =  regression_frr(X, Y)

% Performs the FRR regression

K = size(X, 2);

options = optimset('MaxFunEvals', 100000);
p0 = 0.01*rand(K,1); 


%       This section sets the objective function so that now it only needs
%       just the parameters as an input. If you need help understanding
%       this, look up anonymous functions for matlab. 
%-------------------------------------------------------------------------%
f = @(p)neglogliklogit_peter(p, X, Y);
[betahat,~,~,~,~,hessian] = fminunc(f, p0, options);
%-------------------------------------------------------------------------%

EY = exp(X*betahat)./(1+(exp(X*betahat)));


%       Parameters used in the simulated distributions from FRR. 
% Since FRR doesn't have a distribution attached to it, we need to include
% another paramter in order to create a simulated distribution. The beta
% distribution in matlab needs an "a" and "b". In general, we can solve for
% a and b given mu and some dispersion parameter phi. But given that we
% only have mu, we need to set either a or b arbitrily. The brute force way
% of doing this is just through using betafit(Y), but in general the value
% outputted using this is really bad for generating distributions. So we
% set it to .1. We can examine what the best alpha to use is in another
% function. 
%-------------------------------------------------------------------------%
ahat = .1;
%-------------------------------------------------------------------------%

phat = [betahat; ahat]; 

%       Getting the Standard Errors
%-------------------------------------------------------------------------%
deriv_beta = ones(K, 1);

t = deriv_beta;
g_prime = diag(t);    

covariance = (g_prime / hessian) * g_prime';
std_errors = sqrt(diag(covariance));
%-------------------------------------------------------------------------%


% SSE, R2, Performance metrics
SSE = sum((EY-Y).^2);
SST = sum((EY-mean(Y)).^2);
R2 = 1 - SSE/SST;

Pearson=corr(EY,Y,'type','Pearson');
Kendall=corr(EY,Y,'type','Kendall');
Spearman=corr(EY,Y,'type','Spearman');

stats = [SSE; SST; R2; Pearson; Kendall; Spearman];