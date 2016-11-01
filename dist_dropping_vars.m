function [total_dist] = dist_dropping_vars(params, xx, N_1)

% Generates the distributions for all models, given a certain set of drops.
% Does not generate the distribution for the true model and true
% parameters. 


% The method of organizing information in this function is inconsistent
% with the rest of the code. total_dist just refers to the distribution for
% a given set of drops. The idea is to make 7 distributions without having
% to increment X and drop variables each time. total_dist is a package of
% information that is only needed until it is un-packaged just following
% this function call. 


params_ols    = params{1};
params_igd    = params{2};
params_frr    = params{3};
params_cg     = params{4};
params_ttg    = params{5};
params_br     = params{6};
params_ib     = params{7};




[total_dist_ols]    = predicted_ols(params_ols, xx, N_1);
[total_dist_igd]    = predicted_igd(params_igd, xx, N_1);
[total_dist_frr]    = predicted_frr(params_frr, xx, N_1);
[total_dist_cg]     = predicted_cg(params_cg, xx, N_1);
[total_dist_ttg]    = predicted_ttg(params_ttg, xx, N_1);
[total_dist_br]     = predicted_br(params_br, xx, N_1);
[total_dist_ib]     = predicted_ib(params_ib, xx, N_1);

%-------------------------------------------------------------------------%


%       Compiling Everything into one Cell Array for unpacking. 
%-------------------------------------------------------------------------%
total_dist = {total_dist_ols, total_dist_igd, total_dist_frr,...
    total_dist_cg, total_dist_ttg, total_dist_br, total_dist_ib};
%-------------------------------------------------------------------------%