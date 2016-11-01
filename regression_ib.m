function [phat, EY, stats, std_errors] = regression_ib(X, Y)

% Performs the IB regression


options=optimset('MaxIter',50000, 'MaxFunEvals', 50000); % 500/500 works well
K = size(X, 2);

p0 = 0.1*ones(3*K+1,1);
f = @(p)negloglikib_peter(p, X, Y);
[phat,~,~,~,~,hessian] = fminunc(f,p0,options);


% The MLE function maximizes with respect to the log of phi, not phi. So we
% have to exponentiate phat(3*K+1). We do this in one line to make it
% easier.
betahat = phat(1:K);
gammahat = phat(K+1:2*K);
rhat = phat(2*K+1:3*K);
phihat = exp(phat(3*K+1));
phat = [betahat; gammahat; rhat; phihat];



P0hat = exp(X*betahat)./(1+exp(X*betahat)+ exp(X*gammahat) );
P1hat = exp(X*gammahat)./(1+exp(X*betahat)+ exp(X*gammahat) );
muhat = 1./(1+exp(-X*rhat));
EY = P1hat + (1-P0hat-P1hat).* muhat;

%       Getting the Standard Errors using the delta method
%-------------------------------------------------------------------------%
deriv_beta = ones(K, 1);
deriv_gamma = ones(K, 1);
deriv_r = ones(K, 1);
deriv_phi = exp(phat(3*K+1));

t = [deriv_beta; deriv_gamma; deriv_r; deriv_phi];
gprime = diag(t);
covariance = (gprime / hessian) * gprime';
std_errors = sqrt(diag(covariance));
%-------------------------------------------------------------------------%

SSE = sum((EY-Y).^2);
SST = sum((EY-mean(Y)).^2);
R2 = 1-SSE/SST;

Pearson=corr(EY,Y,'type','Pearson');
Kendall=corr(EY,Y,'type','Kendall');
Spearman=corr(EY,Y,'type','Spearman');

stats = [SSE; SST; R2; Pearson; Kendall; Spearman];