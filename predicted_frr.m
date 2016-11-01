function [total_dist_frr] = predicted_frr(phat_frr, xx, N_1)

% Generates simulated distribution for FRR model. 


N = size(xx, 1);

[~, ahat_frr, bhat_frr, ~] = extract_frr(phat_frr, xx);

a = repmat(ahat_frr, N, N_1);
b = repmat(bhat_frr, 1, N_1);
total_dist_frr = betarnd(a, b);

