function [betahat_ols, sigma2hat_ols, thetahat_ols] = extract_ols(phat_ols, xx)

% Gives you all the relevant parameters for the OLS model. 

kk = size(xx, 2);

betahat_ols         = phat_ols(1:kk);
sigma2hat_ols       = phat_ols(kk+1);

thetahat_ols = xx * betahat_ols;