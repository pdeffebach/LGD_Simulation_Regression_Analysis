function [optimal_beta, optimal_gamma, optimal_r, phi] = coefficients_ib(M, P, a, b, mu_x, sigma_x, vars)

% Generates Coefficients for the IB model that will give you an LGD
% distribution with the shape you specify. 


% P is the amount percentage of zeros and ones you want.
% M is the ratio of zeros to ones.
% a and b are shape parameters used in matalab for the beta distribution. 
% mu_x is the expected value of your variables.


options = optimset('MaxFunEvals', 1000000);

%       This equation comes from setting P0/P1 = M and setting P0 + p1 = P.
%-------------------------------------------------------------------------%
m = 1 / (((M + 1) / P) - (M + 1));
%-------------------------------------------------------------------------%

%       What we want E(exp(x*beta)) and E(exp(x*gamma)) to be equal to. 
%-------------------------------------------------------------------------%
exp_x_gamma     = m;
exp_x_beta      = M * m;
%-------------------------------------------------------------------------%


%       Our starting points for the minimization function. We only have two
%       values because we only have one coefficient applied to the constant
%       and all the random variables, and another one applied to the
%       economic variable. 
%-------------------------------------------------------------------------%
gamma   = [-.6 -.6]; 
beta    = [-.6 -.6];

% params = [gamma; beta];

NN = 10000;
X = zeros(NN, vars+2);
for n = 1:1:NN;
    X(n, :) = [1 normrnd(mu_x(1), sigma_x(1)) normrnd(mu_x(2), sigma_x(2), 1, vars)];
end


%       Our objective function. We want to minimize the distance between
%       exp(x*beta) and exp(x*gamma) from our ideal expected values (m and
%       M*m). We log everything so matlab has an easier time finding a
%       unique solution. This process has problems, especially considerin
%       the relative probabilities of P0 and P1 are conditional on the Xs.
%       This process is good enough, but works best when all X's are likely
%       to be either all positive or all negative. Unfortunately, this
%       gives TTG a lot of difficulty finding a local minimum (because the
%       coefficients must then be small). 
%-------------------------------------------------------------------------%
gg = @(gamma)((mean(log(exp(X * [gamma(1); gamma(2); gamma(1) * ones(vars, 1)]))) - log(exp_x_gamma)) .^ 2);
bb = @(beta)((mean(log(exp(X * [beta(1); beta(2); beta(1) * ones(vars, 1)]))) - log(exp_x_beta)) .^ 2);
%-------------------------------------------------------------------------%

%       Performing the minimization
%-------------------------------------------------------------------------%
gamma = fminunc(gg, gamma, options);
beta = fminunc(bb, beta, options);
%-------------------------------------------------------------------------%

%       Assembling the beta and gamma for use
%-------------------------------------------------------------------------%
optimal_gamma = [gamma(1); gamma(2); gamma(1) * ones(vars, 1)];
optimal_beta  = [beta(1); beta(2); beta(1) * ones(vars, 1)];
%-------------------------------------------------------------------------%


%       Repeating the same process for r
%-------------------------------------------------------------------------%
exp_x_neg_r = ((a + b) / a) - 1;
r = [.5 .5];
rr = @(r)((mean(log(exp(-1 * X * [r(1); r(2); r(1) * ones(vars, 1)])) - log(exp_x_neg_r))) .^ 2);
r = fminunc(rr, r, options);
optimal_r = [r(1); r(2); r(1) * ones(vars, 1)];

phi = a + b;
%-------------------------------------------------------------------------%

















