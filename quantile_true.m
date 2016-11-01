function [P, quantile] = quantile_true(res, parameters_true, obs)

% Generates an inverted CDF for one observation for the true model.
% Supports CG, TTG, and IB

% all inputs are scalars because we are working with one observation.


model = parameters_true{1};


if strcmp(model, 'CG')
    [~, ~, ~, alpha_cg, epsilon_cg, theta_cg] = extract_true(parameters_true, obs);
    [P, quantile] = quantile_cg(res, epsilon_cg, alpha_cg, theta_cg);
end

if strcmp(model, 'TTG')
    [~, ~, ~, alpha_ttg, epsilon_ttg, thetas] = extract_true(parameters_true, obs);
    thetatil_ttg = thetas(:, 1);
    theta_ttg       = thetas(:, 2);
    
    [P, quantile] = quantile_ttg( res, epsilon_ttg, alpha_ttg, theta_ttg, thetatil_ttg);
end

if strcmp(model, 'IB')
    
        [~, ~, ~, ~, ~, probspq] = extract_true(parameters_true, obs);
    
    P0_ib      = probspq(:, 1);
    P1_ib      = probspq(:, 2);
    a_ib       = probspq(:, 3);
    b_ib       = probspq(:, 4);
    
    [P, quantile] = quantile_ib(res, P0_ib, P1_ib, a_ib, b_ib);
end