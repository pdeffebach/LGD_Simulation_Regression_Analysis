function [total_dist_igd] = predicted_igd(phat_igd, xx, N_1)

% Generates simulated distribution for the IGD model. 

[~, sigma2hat_igd, thetahat_igd] = extract_igd(phat_igd, xx);

N = size(xx, 1);
sigma = sqrt(sigma2hat_igd);
total_dist_igd = zeros(N, N_1);


h = @(Z) (normcdf(Z, 0, 1));


for n = 1:1:N;
    u = normrnd(thetahat_igd(n), sigma, 1, N_1);
    total_dist_igd(n, :) = h(u);
end







