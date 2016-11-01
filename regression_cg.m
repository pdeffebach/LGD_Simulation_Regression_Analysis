function [phat, EY, stats, std_errors] =  regression_cg(X, Y)

% Performs the CG regression

            % This function runs the censored gamma regression. Given X and
            % Y vectors, the function gives you the estimated parameters.
            % The math used in this regression can be found in Sigrist
            % (2010). If there are K independent variables in the
            % regression, this function gives K + 2 parameters. There are K
            % beta values that multiply directly the value of each
            % independent variable. Then there is an alpha (ahat, in this
            % code) that works as a dispersion parameter for the gamma
            % distribution. Finally there is an epsilon which shifts the
            % distribution to the left, enabling us to censor at zero. 

K = size(X, 2);
p0 = 0.01*rand(K+2,1); % the random starting values of betas, alpha, and epsilon shift for optimization
options = optimset('MaxFunEvals', 1000000);

% Minimize the negative log likelihood (ie maximize). Note that we are
% optimizating with respect to the log(alpha) and log(epsilon) terms
% because the logged terms are unrestricted on the real line. We will use
% delta method to get the standard errors.
f = @(p)negloglikcg_peter(p, X, Y);
[params,~,~,~,~,hessian] = fminunc(f,p0,options);


%       Taking alpha and epsilon outside of the logarithm
%-------------------------------------------------------------------------%
phat = [params(1:K); exp(params(K+1)); exp(params(K+2))];
%-------------------------------------------------------------------------%

%       Getting the Standard Errors using the delta method. 
%-------------------------------------------------------------------------%
deriv_beta = ones(K, 1);
deriv_alpha = exp(params(K+1));
deriv_epsilon = exp(params(K+2));

t = [deriv_beta;  deriv_alpha; deriv_epsilon];
g_prime = diag(t);    

covariance = (g_prime / hessian) * g_prime';
std_errors=sqrt(diag(covariance));
%-------------------------------------------------------------------------%



% Calculate E(Y) (equation 10 in Sigrist) 
EY = expected_cg(phat, X);

% SSE, R2
SSE = sum((EY-Y).^2);
SST = sum((EY-mean(Y)).^2);
R2 = 1-SSE/SST;

Pearson=corr(EY,Y,'type','Pearson');
Kendall=corr(EY,Y,'type','Kendall');
Spearman=corr(EY,Y,'type','Spearman');

stats = [SSE; SST; R2; Pearson; Kendall; Spearman];
