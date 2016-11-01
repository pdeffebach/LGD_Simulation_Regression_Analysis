function [ey_ols] = expected_ols(phat_ols, xx)

% Generates a vector of expected LGD for OLS given a set of
% parameters and an X vector.


[~, ~, ey_ols] = extract_ols(phat_ols, xx);