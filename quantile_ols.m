function [P, YQ ] = quantile_ols( res, sigma2, theta)
%quantileOLS Reports the quantiles of the OLS which assumes normal distribution 
%   Inverse of the cumulative distributive function is probit (invnorm)
%   For a normal random variable, quantile is 
%   F-1(p) = mu + sigma * probit(p)
%   In this case P is the quantile we want to know, mu is conditional mean
%   EY values, and sigma is standard deviation of EY

P = linspace(0, 1, res)';
sigma = sqrt(sigma2);


YQ = norminv(P, theta, sigma);

end