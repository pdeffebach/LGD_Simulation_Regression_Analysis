function [total_dist_ols] = predicted_ols(phat_ols, xx, N_1)

% Generates simulated distribution for OLS model. 

[~, sigma2hat_ols, thetahat_ols] = extract_ols(phat_ols, xx);


% total_dist_ols = zeros(N, N_1);
sigma = sqrt(sigma2hat_ols);


y = repmat(thetahat_ols, 1, N_1);

total_dist_ols = normrnd(y, sigma);
