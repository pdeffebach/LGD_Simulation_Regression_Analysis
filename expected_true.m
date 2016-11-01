function [ey_true] = expected_true(parameters_true, xx)

% Generates a vector of expected LGD for the true model given a set of
% parameters and an X vector. Allows for CG, TTG, or IB. 

H = size(xx, 1);
model = parameters_true{1};




%       Assuming Censored Gamma Model
if strcmp(model, 'CG')
    [~, ~, ~, alpha_cg, epsilon_cg, theta_cg] = extract_true(parameters_true, xx);
    G1 = gamcdf(1+epsilon_cg, alpha_cg+1, theta_cg);
    G2 = gamcdf(epsilon_cg, alpha_cg+1, theta_cg);
    G3 = gamcdf(1+epsilon_cg, alpha_cg, theta_cg);
    G4 = gamcdf(epsilon_cg, alpha_cg, theta_cg);
    p1 = alpha_cg*theta_cg.*(G1-G2);
    p2 = (1+epsilon_cg)*(1-G3);
    p3 = epsilon_cg*(1-G4);
    ey_true = p1+p2-p3;

    
%       Assuming a Two Tiered Gamma Model
elseif strcmp(model, 'TTG')
    [~, ~, ~, alpha_ttg, epsilon_ttg, thetas] = extract_true(parameters_true, xx);
    thetatil_ttg = thetas(:, 1);
    theta_ttg = thetas(:, 2);
    
    p1 = gamcdf(epsilon_ttg,   alpha_ttg, thetatil_ttg);    % this is essentially P(Y=0) in eqn 24
    p2 = gamcdf(epsilon_ttg,   alpha_ttg, theta_ttg);       % similar to denominator of 2nd and 3rd formulas in eqn 24
    p4 = gamcdf(1+epsilon_ttg, alpha_ttg, theta_ttg);
    for h = 1:1:H;
        if(p2(h) && p4(h) == 1);
            p2(h) = 1 - 0.000001;     % Fixes denominator in equation for EY01
        elseif p2(h) == 1;
            p2(h) = 1 - 0.000001;     % Fixes denominator in equation for PY1
        end
    end
    PY1 = (1-p4).*(1-p1)./(1-p2); % pr(Y=1)
    PY0 = p1; % pr(Y=0)
    PY01 = 1 - PY0 - PY1; % prob that Y is between 0 and 1
    p5 = gamcdf(epsilon_ttg, alpha_ttg+1, theta_ttg);
    p6 = gamcdf(1+epsilon_ttg, alpha_ttg+1, theta_ttg);
    EY01 = (alpha_ttg*theta_ttg.*(p6-p5) - epsilon_ttg*(p4-p2))./(p4-p2);
    %The above code is from the May 19th 2016
    %paper in th appendix.
    ey_true = PY1+EY01.*PY01;
    
elseif strcmp(model, 'IB')
        [~, ~, ~, ~, ~, probspq] = extract_true(parameters_true, xx);
    
    P0_ib      = probspq(:, 1);
    P1_ib      = probspq(:, 2);
    a_ib       = probspq(:, 3);
    b_ib       = probspq(:, 4);
    P01_ib = 1 - P0_ib - P1_ib;
    
    mu = a_ib ./ (a_ib + b_ib);
    
    ey_true = mu .* P01_ib + P1_ib;
end
