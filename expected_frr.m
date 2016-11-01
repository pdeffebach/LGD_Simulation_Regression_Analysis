function [ey_frr] = expected_frr(phat_frr, xx)

% Generates a vector of expected LGD for FRR given a set of
% parameters and an X vector.


[~, ~, ~, ey_frr] = extract_frr(phat_frr, xx);