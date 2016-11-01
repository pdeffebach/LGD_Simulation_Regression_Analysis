function [phat, EY, stats, std_errors] =  regression_ols(X, Y)

% Performs the OLS regression

N = size(X, 1); % number of observations
K = size(X, 2); % number of variables

beta = (X'*X)\(X'*Y); % coefficients

if sum(isnan(beta)) >0;      
    beta = regress(Y,X);
end

EY = X*beta;             

sigma2hat = (Y-EY)'*(Y-EY)/(N-K);       % Sample variance (N-K accounts for degrees of freedom)


phat = [beta; sigma2hat]; % packaging for later use. 


%       Getting the standard errors
%-------------------------------------------------------------------------%
covariance = sigma2hat * inv(X' * X);         % covariance matrix
std_errors = sqrt(diag(covariance));         % standard errors
%-------------------------------------------------------------------------%


% SSE, R2, Pearson, Kendall, Spearman
SSE = sum((EY-Y).^2);
SST = sum((EY-mean(Y)).^2);
R2 = 1-SSE/SST;

Pearson=corr(EY,Y,'type','Pearson');
Kendall=corr(EY,Y,'type','Kendall');
Spearman=corr(EY,Y,'type','Spearman');

stats = [SSE; SST; R2; Pearson; Kendall; Spearman];