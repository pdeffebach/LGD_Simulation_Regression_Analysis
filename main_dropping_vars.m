function [phat, ey_all, stats, std_errors, errors_igd] = main_dropping_vars(X, Y) 

% Runs all regressions for dropping variables. 


% This section runs the MLE regressions for all the models.
% The stats vectors all have the following form:

% stats = [SSE; SST; R2; Pearson; Kendall; Spearman];

% Pay attentionto the bottom where it puts everything together. You need to
% understand how the function packages information for when it un-bundles
% all the parameters in the for loop in client_dropping vars. phat_ols is
% not the same in this code as it is in client_dropping_vars.

%       Ordinary Least Squares Regression
%-------------------------------------------------------------------------%
[phat_ols, EY_ols, stats_ols, std_errors_ols]       =  regression_ols(X, Y);
%-------------------------------------------------------------------------%

%       Inverse Gaussian with Duan Smearing Regression
%-------------------------------------------------------------------------%
[phat_igd, EY_igd, stats_igd, std_errors_igd, errors_igd]       = regression_igd(X, Y);
%-------------------------------------------------------------------------%

%       Fractional Response Regression
%-------------------------------------------------------------------------%
[phat_frr, EY_frr, stats_frr, std_errors_frr]       =  regression_frr(X, Y);
%-------------------------------------------------------------------------%

%       Censored Gama Regression
%-------------------------------------------------------------------------%
[phat_cg, EY_cg, stats_cg, std_errors_cg]          =  regression_cg(X, Y);
%-------------------------------------------------------------------------%

%       Two Tiered Gamma Regression
%-------------------------------------------------------------------------%
[phat_ttg, EY_ttg, stats_ttg, std_errors_ttg]       = regression_ttg(X, Y);
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
%-------------------------------------------------------------------------%

%       Inflated Beta Regression (called Zero-One Beta in previous versions
%-------------------------------------------------------------------------%
[phat_ib, EY_ib, stats_ib, std_errors_ib] = regression_ib(X, Y) ;
%-------------------------------------------------------------------------%

clc

%       Putting Everything Together 
% Formatting is different. This phat and stats and ey is not the same as
% that in the client_dropping_vars code. all is immediately unpacked. 
%-------------------------------------------------------------------------%
phat = {phat_ols, phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib};
stats = {stats_ols, stats_igd, stats_frr, stats_cg, stats_ttg, stats_br, stats_ib};
ey_all = {EY_ols, EY_igd, EY_frr, EY_cg, EY_ttg, EY_br, EY_ib};
std_errors = {std_errors_ols, std_errors_igd, std_errors_frr, std_errors_cg, std_errors_ttg, std_errors_br, std_errors_ib};
%-------------------------------------------------------------------------%





