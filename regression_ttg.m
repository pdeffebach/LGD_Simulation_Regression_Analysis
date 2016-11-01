function [phat, EY, stats, std_errors] =  regression_ttg(X, Y)


% Performs the TTG regression.

        % This function takes in X and Y vectors and returns a set of
        % parameters. The math for this function can be seen in Sigrist
        % (2010). If there are K independent variables, this function
        % returns 2K + 2 parameters. A set beta of scalars for the first
        % gamma distribution, used for censoring at zero, a set of gamma of
        % scalars used for the second distribution, an alpha which is a
        % dispersion parameter for the distribution, and an epsilon which
        % shifts each distribution to the left, allowing censoring. The
        % mean of the first distribution for each observation is thetahat,
        % the mean for the second distribution for each observation is
        % thetathat where the t means til. The function also returns a set
        % of correlation coefficients for the regression. 

% MLE optimization. K coefficients for each variable, 1 for alpha, 1 for
% epsilon. also, note that alpha and epsilon we are optimizing over the log
% of the parameter so we need to exponentiate the MLE results. 
K = size(X, 2);
p0 = 0.01*rand(2*K+2,1);
%p0 = 0.01*ones(2*K+2,1); % initial values
options=optimset('MaxFunEvals',100000, 'TolX', 1e-10);
f = @(p)negloglikttg_peter(p, X, Y);
[params,~,~,~,~,hessian] = fminunc(f, p0, options);

%       Getting the alpha and epsilon out of their logs
%-------------------------------------------------------------------------%
phat = [params(1:2*K); exp(params(2*K+1)); exp(params( 2*K+2))];
%-------------------------------------------------------------------------%

% The following are the transformations for the standard error
% calculation uding the data method. Since in the maximum likelihood
% funciton we maximize with the actual beta in the linking linking function, we do not need
% to do any transformation. However alpha and epsilon are both estimated
% according to their logs, so we need to take the exponential. Sometimes
% this spits out complex numbers, due to the imprecision of using just the
% 2nd term in the taylor expansion (I think). For that reason I take the
% absolute value of the standard errors, rather than the errors themselves.
% This is something that should be looked in to. 


%       Getting the Standard Errors using the delta method
%-------------------------------------------------------------------------%
deriv_beta = ones(K, 1);
deriv_gamma = ones(K, 1);
deriv_alpha = exp(params(2*K + 1));
deriv_epsilon = exp(params(2*K + 2));

t = [deriv_beta; deriv_gamma;  deriv_alpha; deriv_epsilon];
g_prime = diag(t); 
covariance = abs((g_prime / hessian) * g_prime');

std_errors=sqrt(diag(covariance));
%-------------------------------------------------------------------------%


%       Getting the Expected Y
%-------------------------------------------------------------------------%
EY = expected_ttg(phat, X);
%-------------------------------------------------------------------------%

SSE = sum((EY- Y).^2);
SST = sum((EY-mean(Y)).^2);
R2 = 1-SSE/SST;
Pearson=corr(EY,Y,'type','Pearson');
Kendall=corr(EY,Y,'type','Kendall');
Spearman=corr(EY,Y,'type','Spearman');

stats = [SSE; SST; R2; Pearson; Kendall; Spearman];