% Performs all regressions and analysis without dropping variables. Useful
% when testing regressions. 


clear 
close all
clc
rng(1234)
%%       Data Generation Portion
                    % This section generates an original distribution
                    % using K covariates. The X variables are normal(0, 1),
                    % The input 1 in datageneration() indicates a Censored
                    % Gamma Distribution. 2 means Two-Tiered Gamma, and 3
                    % means Inflated Beta. 
%-------------------------------------------------------------------------%
%for k_value = 1:1:10
%K   = k_value;
      
% Number of variables (including constant and variables that only change by
% year). Number of 'random' variables is (K-2)

C = 100;           % Number of Companies.            
res = 1000;          % Resolution of analytic function in quantile-plot
def = 1000;
J   = 1000;            % Amount of observations to use when making box plots
draws   = [100 5000];    % Number of random draws for each observation 
N_1     = max(draws); % For use when creating the random distributons. 
lower_xx = -3;
upper_xx = 4;      % The range you would like to use for quantile plots.



%       Parameters Used in finding the coefficients for IB M = ratio of
% zeros to ones. P = probability of being zero or one a and b are shape
% parameters for the beta distribution in the middle. mu_x is a vector
% consisting of the means of each variable. the outputs beta, gamma, and r
% are all vectors of size K, and phi is a scalar.
%-------------------------------------------------------------------------%
M = 10;
P = .5;
a = .5;
b = .5;
K = 11;
vars = K - 2; % Because we have both a constant and an economic variable.
%-------------------------------------------------------------------------%




% What are the true parameter values you would like to use in constructing
% this simulated distribution? (uncomment to use). The first parameter in
% the coefficient vector goes on the constant, the last two go on the
% 'yearly' variables. 

%       Censored Gamma
%-------------------------------------------------------------------------%
% beta    = [1;  1;  1;  1;  1;  1;  1;  1; 1; 1; 1; 1 ];
% gamma   = [0;  0;  0;  0;  0;  0;  0;  0;  0;  0;  0 ];  
% r       = [0;  0;  0;  0;  0;  0;  0;  0;  0;  0;  0 ];
% alpha   = .7;      
% epsilon = .2;
% model_type = 'CG';
% parameters = [beta; alpha; epsilon];
% parameters_true = {model_type, parameters};
%-------------------------------------------------------------------------%

%       Two Tiered Gamma
%-------------------------------------------------------------------------%
% beta    = [.2; .2; .2; .2; .2; .2; .2; .2; .2; .2; .2]; 
% gamma   = [.4; .4; .4; .4; .4; .4; .4; .4; .4; .4; .2];   
% r       = [0;  0;  0;  0;  0;  0;  0;  0;  0;  0;  .2];
% alpha   = .70;      
% epsilon = .2;
% model_type = 'TTG';
% parameters = [beta; gamma; alpha; epsilon];
% parameters_true = {model_type, parameters};
%-------------------------------------------------------------------------%


%       Getting ready to find coefficients for IB
%-------------------------------------------------------------------------%
constant = .1;

file = fopen('unemployment.csv');
econ = textscan(file, '%f');
fclose(file);
econ = econ{1};
econ = econ / 100;
T = size(econ, 1);
mu_econ = mean(econ);
sigma_econ = std(econ);     

mu_random = 1;
sigma_random = 1;

mu_x = [mu_econ mu_random];
sigma_x = [sigma_econ sigma_random];
%-------------------------------------------------------------------------%


%       Inflated Beta Distribution
%-------------------------------------------------------------------------%
[beta, gamma, r, phi] = coefficients_ib(M, P, a, b, mu_x, sigma_x, vars);
model_type = 'IB';
parameters = [beta; gamma; r; phi];
parameters_true = {model_type, parameters};
disp(beta);
disp(gamma);
disp(r);
%-------------------------------------------------------------------------%

% Values used in paper: beta,   gamma,  r       alpha, epsilon
% Censored gamma:       0.01,   0,      0,      0.7,    0.2
% Two-Tiered Gamma:     0.2,    0.4,    0,      0.7,    0.2
% Inflated Beta:        0.3,   -0.45,   0.1,    0,      0
        
K = length(beta);
[X, Y] = datageneration_peter(parameters_true, C, vars, econ, mu_x, sigma_x);

edges = linspace(0, 1, 60);
histogram(Y, edges, 'Normalization', 'probability');
ylim([0 1])

figure()
histogram(Y(Y > 0 & Y < 1), edges, 'Normalization', 'probability');

g = sum(Y == 0) / sum(Y == 1);
disp(g);

h = sum(Y == 0 | Y == 1) / size(Y, 1);
disp(h);
%-------------------------------------------------------------------------%



%       Random Subset of Observations for Distributions
%-------------------------------------------------------------------------%
N = C * T;    
if (J > N)  % In case you selected your 'smaller' X to be bigger than X.
    J = N;
end
p = randperm(N, J);
X1 = X(p, :);
%-------------------------------------------------------------------------%



%% Model Fitting Portion
% This section runs the MLE regressions for censored gamma, two tiered
% gamma, and the beta regression.
% The stats vectors all have the following form:
% stats = [SSE; SST; R2; Pearson; Kendall; Spearman];

%       Ordinary Least Squares Regression
%-------------------------------------------------------------------------%
[phat_ols, EY_ols, stats_ols, std_errors_ols]               =  regression_ols(X, Y);
[betahat_ols, sigma2hat_ols, thetahat_ols]  = extract_ols(phat_ols, X);
%-------------------------------------------------------------------------%

%       Inverse Gaussian with Duan Smearing Regression
%-------------------------------------------------------------------------%
[phat_igd, EY_igd, stats_igd, std_errors_igd, errors_igd]               = regression_igd(X, Y);
[betahat_igd, sigma2hat_igd, thetahat_igd]  = extract_igd(phat_igd, X);
%-------------------------------------------------------------------------%

%       Fractional Response Regression
%-------------------------------------------------------------------------%
[phat_frr, EY_frr, stats_frr, std_errors_frr]   =  regression_frr(X, Y);
[betahat_frr, ahat_frr, bhat_frr, thetahat_frr] = extract_frr(phat_frr, X);


%       Censored Gama Regression
%-------------------------------------------------------------------------%
[phat_cg, EY_cg, stats_cg, std_errors_cg]  =  regression_cg(X, Y);
[betahat_cg, alphahat_cg, epsilonhat_cg, thetahat_cg] = ...
    extract_cg(phat_cg, X);
%-------------------------------------------------------------------------%


%       Two Tiered Gamma Regression
%-------------------------------------------------------------------------%
[phat_ttg, EY_ttg, stats_ttg, std_errors_ttg] = regression_ttg(X, Y);
[betahat_ttg, gammahat_ttg, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg,...
    thetahat_ttg] = extract_ttg(phat_ttg, X);
%-------------------------------------------------------------------------%



%       Beta Regression
% The output for the Beta Regression has a different naming convention than
% the others. To stay consistent with the math in the paper, thetahat_br
% and psi_hat br are both K by 1 vectors of model coefficients. The ahat_br
% and bhat_br are used to generate the distributions for each observation,
% so they are N by 1 vectors. ahat_br and bhat_br are the equivelent of
% thetahat_cg from the censored gamma regression and thetahat_ttg and
% thetatilhat_ttg from the two tiered gamma regression.
%-------------------------------------------------------------------------%
[phat_br, EY_br, stats_br, std_errors_br] = regression_br(X, Y);
[thetahat_br, psihat_br, clhat_br, cuhat_br, ahat_br, bhat_br] =...
    extract_br(phat_br, X);
%-------------------------------------------------------------------------%

%       Inflated Beta Regression (called Zero-One Beta in previous versions
%-------------------------------------------------------------------------%
[phat_ib, EY_ib, stats_ib, std_errors_ib] = regression_ib(X, Y) ;
[betahat_ib, gammahat_ib, rhat_ib, phihat_ib, P0hat_ib, P1hat_ib,...
    ahat_ib, bhat_ib] = extract_ib(phat_ib, X);
%-------------------------------------------------------------------------%


%% Predicted Distributions and KS Statistics

% Generating random distributions using true and estimated
% parameters. 
%-------------------------------------------------------------------------%
disp('beginning to generate distributions');
tic
[total_dist_true]   = predicted_true(parameters_true, X1, N_1);
[total_dist_ols]    = predicted_ols(phat_ols, X1, N_1);
[total_dist_igd]    = predicted_igd(phat_igd, X1, N_1);
[total_dist_frr]    = predicted_frr(phat_frr, X1, N_1);
[total_dist_cg]     = predicted_cg(phat_cg, X1, N_1);
[total_dist_ttg]    = predicted_ttg(phat_ttg, X1, N_1);
[total_dist_br]     = predicted_br(phat_br, X1, N_1);
[total_dist_ib]     = predicted_ib(phat_ib, X1, N_1);
toc
%-------------------------------------------------------------------------%

% Generating the p statistics and k statistis from our random
% distributions.

% The convention from this point forward is to store information from each
% estimated model according to the following numbering system. 
%   1. OLS      5. TTG 
%   2. IGD      6. BR
%   3. FRR      7. IB
%   4. CG      
%-------------------------------------------------------------------------%
disp('beginning ks tests');
tic
[p_stats_draws, k_stats_draws] = ks_draws(total_dist_true, total_dist_ols,...
    total_dist_igd, total_dist_frr, total_dist_cg, total_dist_ttg,...
    total_dist_br, total_dist_ib, draws);
toc
%-------------------------------------------------------------------------%


%
%%       Box Plots for KS Statistics
%-------------------------------------------------------------------------%
 boxplots_ks(p_stats_draws, k_stats_draws, draws, 'draws'); 

% The last argument in this function lets the code graph the boxplots with
% the right label. Letting the reader know that the ks-statistics apply to
% distributions of random draws, and not analytic distributions. 

%%      Quantile Plots With Analytic Distribution
x1 = ones(def, 1);
x2 = mu_x(1) * ones(def, 1);
x3 = linspace(lower_xx, upper_xx, def)';
s = 3;
xz = mu_x(2) * ones(def, K-3);
xx = [x1 x2 x3 xz];
s = 3;
disp('beginning analytical quantile generation and plotting')
tic
quantile_plot_analytic(parameters_true, phat_ols,...
    phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib, xx, errors_igd, res, s)
toc


%%      Plotting Quantiles for A Selection of Observations from X

plot_random_cdfs(parameters_true, phat_ols,...
    phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib, X, res)


%%
%}
%}
%}
