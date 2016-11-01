function [ey_ib] = expected_ib(phat_ib, xx)


% Generates a vector of expected LGD for IB given a set of
% parameters and an X vector.


[~, ~, ~, ~, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib, xx);
P01hat_ib = 1 - P0hat_ib - P1hat_ib;

mu = ahat_ib ./ (ahat_ib + bhat_ib);

ey_ib = mu .* P01hat_ib + P1hat_ib;