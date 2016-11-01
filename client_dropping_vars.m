% The code for dropping variables that everything runs from. Client means that no math is actually
% done in this code, it only calls functions. 

clear
close all
clc

rng(1234)

global FIGURES_PATH
FIGURES_PATH = '/Users/peterdeffebach/Dropbox/Job Applications/Matlab Code/Figures';


res = 1000;         % Resolution of analytic function in quantile-plot.
def = 1000;         % Density of Range of X2 for quantiles.
J   = 5000;         % Amount of observations to use when making simulated distributions.
N_1 = 1000;         % How many draws you will use in the simulated distributions.
lower_x2 = -4.9;
upper_x2 = 5.1;       % The range you would like to use for quantile plots.
drops = [0 4 8];  % How many variables to drop each time.

%       Setting the Shape of LGD distribution
% M = ratio of zeros to ones. P = probability of being zero or one a and b
% are shape parameters for the beta distribution in the middle. mu_x is a
% vector consisting of the means of each variable. the outputs beta, gamma,
% and r are all vectors of size K, and phi is a scalar.
%-------------------------------------------------------------------------%
M = 3;
P = .4;
a = .4;
b = .5;
%-------------------------------------------------------------------------%

%       Initializing econ array and setting mean of X and standard
%       deviation of X.
%-------------------------------------------------------------------------%
K = 11;
vars = K -2;    % The number of randomly generated X variables you want.

file = fopen('unemployment.csv');
econ = textscan(file, '%f');
fclose(file);
econ = econ{1};
econ = econ(1:10) / 100; 
mu_econ = mean(econ);
sigma_econ = std(econ);

T = size(econ, 1);
C = 10;             % Number of Companies. When testing things consider setting C to as low as 10 so you are only regressing on 400 observations. 
N = C * T;          % Total number of observations.

mu_random = .1;
sigma_random = 1;

mu_x = [mu_econ mu_random];
sigma_x = [sigma_econ sigma_random];
%-------------------------------------------------------------------------%


% What are the true parameter values you would like to use in constructing
% this simulated distribution? (uncomment to use). The first parameter in
% the coefficient vector goes on the constant. The second parameter goes on
% the economic variables. If you are setting coefficients yourself, pay
% attention to the magnitude of the economic variables. If they are small,
% you will need to increase the size of the coefficient. 

%       Censored Gamma
%-------------------------------------------------------------------------%
% The length of this vector depends on the amount of economic panel
% variables are added in. You will get errors if these vectors are not the
% correct length.
% beta    = [.1; .5; .1; .1; .1; .1; .1; .1; .1; .1; .1]; 
% gamma   = [0;  0;  0;  0;  0;  0;  0;  0;  0;  0;   0];
% r       = [0;  0;  0;  0;  0;  0;  0;  0;  0;  0;   0];
% alpha   = .7;
% epsilon = .2;
% model_type = 'CG';
% parameters = [beta; alpha; epsilon];
% parameters_true = {model_type, parameters};
%-------------------------------------------------------------------------%

%       Two Tiered Gamma
%-------------------------------------------------------------------------%
% beta    = [.3; .3; .3; .3; .3; .3; .3; .3; .3; .3; .3];
% gamma   = [.6; .6; .6; .6; .6; .6; .6; .6; .6; .6; .6];
% r       = [0;  0;  0;  0;  0;  0;  0;  0;  0;  0;   0];
% alpha   = .70;
% epsilon = .2;
% model_type = 'TTG';
% parameters = [beta; gamma; alpha; epsilon];
% parameters_true = {model_type, parameters};
%-------------------------------------------------------------------------%


%       Inflated Beta Distribution
%-------------------------------------------------------------------------%
% If you have a distribution in mind for how you want your LGD distribution
% to look, use the coefficients_ib code. If you want to set the
% coefficients yourself, use the code below that. 

% [beta, gamma, r, phi] = coefficients_ib(M, P, a, b, mu_x, sigma_x, vars);
 

beta    = .3    * ones(K, 1);
gamma   = -.45  * ones(K, 1);
r       = -.1    * ones(K, 1);
phi     = 1;

beta(2)    = 3;
gamma(2)   = -3;
r(2)       = -1;

model_type = 'IB';
parameters = [beta; gamma; r; phi];
parameters_true = {model_type, parameters};
%-------------------------------------------------------------------------%

% Values used in paper: beta,   gamma,  r       alpha, epsilon
% Censored gamma:       0.01,   0,      0,      0.7,    0.2
% Two-Tiered Gamma:     0.2,    0.4,    0,      0.7,    0.2
% Inflated Beta:        0.3,   -0.45,   0.1,    0,      0

%       Creating the Xs and Ys, true distribution, and true expected Y
%-------------------------------------------------------------------------5
[ X, Y] = datageneration_peter(parameters_true, C, vars, econ, mu_x, sigma_x);


%       Showing you some properties of the distribution
%-------------------------------------------------------------------------%
edges = 0:.05:1;

% To see what the the whole LGD distribution looks like. 
figure()
histogram(Y, edges, 'Normalization', 'probability');
ylim([0 1])

% To see what the interior part looks like.
figure()
histogram(Y(Y > 0 & Y < 1), edges, 'Normalization', 'probability');

g = sum(Y == 0) / sum(Y == 1);
disp(['Ratio of Zeros to Ones: ' num2str(g)]);

h = sum(Y == 0 | Y == 1) / size(Y, 1);
disp(['Ratio of Ones and Zeros to observations in between: ' num2str(h)]);
%pause % Gives you time to check the LGD distribution
%-------------------------------------------------------------------------%

%close all



%       For the simulated Distribution Process
% When creating simulated distributions, you don't need them for N
% observations. That would be prohibitively expensive to run, for no real
% benefit. Instead, we take a random selection of observations and use
% those as the basis for our simulated distributions. We use J as our
% number of observations. The matrix that holds all of these is X1.
% randperm() is what we use to make the random selection.
%-------------------------------------------------------------------------%
if (J > N)  % In case you selected your 'smaller' X to be bigger than X.
    J = N;
end
p = randperm(N, J);
X1 = X(p, :);
[dist_true]   = predicted_true(parameters_true, X1, N_1);
%-------------------------------------------------------------------------%



% Creating the expected Y using the true parameters. 
%-------------------------------------------------------------------------%
[ey_true] = expected_true(parameters_true, X);
%-------------------------------------------------------------------------%



%       Initializing all cells for storing information
%-------------------------------------------------------------------------%
D = length(drops);
phat_ols    = cell(1, D);
phat_igd    = cell(1, D);
phat_frr    = cell(1, D);
phat_cg     = cell(1, D);
phat_ttg    = cell(1, D);
phat_br     = cell(1, D);
phat_ib     = cell(1, D);

stats_ols   = cell(1, D);
stats_igd   = cell(1, D);
stats_frr   = cell(1, D);
stats_cg    = cell(1, D);
stats_ttg   = cell(1, D);
stats_br    = cell(1, D);
stats_ib    = cell(1, D);

dist_ols    = cell(1, D);
dist_igd    = cell(1, D);
dist_frr    = cell(1, D);
dist_cg     = cell(1, D);
dist_ttg    = cell(1, D);
dist_br     = cell(1, D);
dist_ib     = cell(1, D);

ey_ols      = cell(1, D);
ey_igd      = cell(1, D);
ey_frr      = cell(1, D);
ey_cg       = cell(1, D);
ey_ttg      = cell(1, D);
ey_br       = cell(1, D);
ey_ib       = cell(1, D);

errors_igd  = cell(1, D);

std_errors_ols  = cell(1, D);
std_errors_igd  = cell(1, D);
std_errors_frr  = cell(1, D);
std_errors_cg   = cell(1, D);
std_errors_ttg  = cell(1, D);
std_errors_br   = cell(1, D);
std_errors_ib   = cell(1, D);
%-------------------------------------------------------------------------%


%       Creating the xx vector for use in these quantile plots. If we want,
%       we can use change the economic variable with this. However if you
%       want to do that, you have to also go into the 
%-------------------------------------------------------------------------%
x1 = ones(def, 1);
x2 = mu_x(1) * ones(def, 1);
x3 = linspace(lower_x2, upper_x2, def)';
s = 3;
xz = mu_x(2) * ones(def, K-3);
xx = [x1 x2 x3 xz];
%-------------------------------------------------------------------------%

%       For loop for the regressions
%-------------------------------------------------------------------------%
for d = 1:1:D
    kk  = K - drops(d);
    XX  = X(:, 1:kk);
    XX1 = XX(p, :);
    
    step = ['step ', num2str(d), ' of ', num2str(D)];
    
    
    disp(['beginning regressions ', step])
    [estimated_params, ey_all, stats, estimated_std_errors, errors] = main_dropping_vars(XX, Y);
    disp(['finished regressions ', step])
    
    clc
    
    disp(['beginning to generate distributions ', step])
    tic
    [dist] = dist_dropping_vars(estimated_params, XX1, N_1);
    disp(['finished generating distributions', step])
    toc
    
    phat_ols{d}     = estimated_params{1};
    phat_igd{d}     = estimated_params{2};
    phat_frr{d}     = estimated_params{3};
    phat_cg{d}      = estimated_params{4};
    phat_ttg{d}     = estimated_params{5};
    phat_br{d}      = estimated_params{6};
    phat_ib{d}      = estimated_params{7};
    
    stats_ols{d}    = stats{1};
    stats_igd{d}    = stats{2};
    stats_frr{d}    = stats{3};
    stats_cg{d}     = stats{4};
    stats_ttg{d}    = stats{5};
    stats_br{d}     = stats{6};
    stats_ib{d}     = stats{7};
    
    dist_ols{d}     = dist{1};
    dist_igd{d}     = dist{2};
    dist_frr{d}     = dist{3};
    dist_cg{d}      = dist{4};
    dist_ttg{d}     = dist{5};
    dist_br{d}      = dist{6};
    dist_ib{d}      = dist{7};
    
    ey_ols{d}       = ey_all{1};
    ey_igd{d}       = ey_all{2};
    ey_frr{d}       = ey_all{3};
    ey_cg{d}        = ey_all{4};
    ey_ttg{d}       = ey_all{5};
    ey_br{d}        = ey_all{6};
    ey_ib{d}        = ey_all{7};
    
    errors_igd{d}   = errors;
    
    std_errors_ols{d}   = estimated_std_errors{1};
    std_errors_igd{d}   = estimated_std_errors{2};
    std_errors_frr{d}   = estimated_std_errors{3};
    std_errors_cg{d}    = estimated_std_errors{4};
    std_errors_ttg{d}   = estimated_std_errors{5};
    std_errors_br{d}    = estimated_std_errors{6};
    std_errors_ib{d}    = estimated_std_errors{7};
end


%
% %       Putting all the information from above into just 2 packets
% %       This is done for consistency of input arguments for functions.
% %-------------------------------------------------------------------------%
phat = {parameters_true, phat_ols, phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib};
errors_igd; % To remind you that it is here and needs to be used.
dist = {dist_true, dist_ols, dist_igd, dist_frr, dist_cg, dist_ttg, dist_br, dist_ib};
ey   = {ey_true, ey_ols, ey_igd, ey_frr, ey_cg, ey_ttg, ey_br, ey_ib};
stats = {stats_ols, stats_igd, stats_frr, stats_cg, stats_ttg, stats_br, stats_ib};
std_errors = {std_errors_ols, std_errors_igd, std_errors_frr, std_errors_cg, std_errors_ttg, std_errors_br, std_errors_ib};
%-------------------------------------------------------------------------%

close all


%   Saving the Workspace. This may be slow! uncomment if you anticipate
%   making changes above this line!
%-------------------------------------------------------------------------%
save('workspace')
%-------------------------------------------------------------------------%




%}
%% Analysis

%       Colors and Styles for Graphs
%-------------------------------------------------------------------------%
colors =   [.81 .32 .32;... % You can figure out these colors by plotting. 
            .32 .81 .66;...
            .32 .45 .81;...
            .96 .60 .96;...
            1.0 .80 .49];
        
        
styles = {'-','--','-.'};

color_map = colors;     % For using the histogram() function. Not useful. 

set(groot,'defaultAxesLineStyleOrder', styles)
set(groot,'defaultAxesColorOrder', colors)
set(0,'defaultlinelinewidth',1)
set(groot,'DefaultFigureColormap', color_map)
set(0,'DefaultfigurePaperOrientation','landscape') 
%-------------------------------------------------------------------------%
%}


%       Boxplots and Inverted CDF Analysis
% The following is done in a for loop because we don't want to increment X
% in a separate function, and the way I store information makes it clunky
% to un-pack paramaters in a way that would make this easy. Also since both
% functions are so large, putting the for loop inside the function would be
% messier than having it out here. 
%-------------------------------------------------------------------------%
close all
set(0,'DefaultFigureVisible','off');

p_stats     = zeros(J, 7, D);
k_stats     = zeros(J, 7, D);
for d = 1:1:D
    kk  = K - drops(d);
    XX  = X(:, 1:kk);
    XX1 = XX(p, :);
    
    % saved in 'quantile_*_vars_dropped
    quantile_plot_dropping_vars(parameters_true, phat_ols{d},...
        phat_igd{d}, phat_frr{d}, phat_cg{d}, phat_ttg{d}, phat_br{d}, phat_ib{d}, xx, errors_igd{d}, kk, s)
    
    [p_stats(:, :, d), k_stats(:, :, d)] = ks_draws_dropping_vars(dist_true, dist_ols{d},...
        dist_igd{d}, dist_frr{d}, dist_cg{d}, dist_ttg{d}, dist_br{d}, dist_ib{d});
    
end

% Saved in 'boxplots'
boxplot_ks_dropping_vars(p_stats, k_stats, drops)
%-------------------------------------------------------------------------%

save('workspace')

%       Graphs
%-------------------------------------------------------------------------%

% saved in 'histogram_one_obs'
hist_one_obs_dropping_vars(dist, drops)

% saved in 'expected_y'
hist_ey_dropping_vars(ey, drops)

% saved in 'histogram_unconditional_Y'
hist_unconditional_Y(phat, dist, drops);

% saved in random_cdfs_*_vars_dropped
random_cdfs_dropping_vars(phat, X, res, drops)

% saved in 'cdfs_mean_obs'
cdfs_mean_obs(phat, res, mu_x, drops)

% saved in 'marginal_effects'
mfx_dropping_vars(phat, drops, mu_x, errors_igd)

% saved in 'variance_cdfs'
variance_cdfs_dropping_vars(phat, X, drops, res)

% saved in 'histogram_frr_changing_a'
frr_changing_a(xx, Y, phat)
%-------------------------------------------------------------------------%


%       Tables
%-------------------------------------------------------------------------%
t = [FIGURES_PATH, 'tables'];
mkdir(t);

t_mean_Y = table_diff_mean_Y(ey, Y, drops);

t_SSE = table_SSE(stats, drops);

t_diff_ey = table_diff_ey(ey, drops);

table_marginal_effects = table_mfx(phat, drops, mu_x, errors_igd);

[t_stats_full_model, t_stats_first_drops] = table_stats(stats);

[t_coeffs_full_model, t_coeffs_first_drops] = table_coeffs(phat, std_errors);
%-------------------------------------------------------------------------%



close all
set(0,'DefaultFigureVisible','on');
%}
%}
%}
