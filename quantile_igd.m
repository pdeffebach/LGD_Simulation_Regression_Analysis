function [P, YQ] = quantile_igd(res, sigma2, theta)

% Generates an inverted CDF for one observation for the IGD model. 

% all inputs are scalars because we are working with one observation. 

P = linspace(0, 1, res);
sigma = sqrt(sigma2);


y = norminv(P, theta, sigma);

h = @(Z) (normcdf(Z, 0, 1));


YQ = h(y);