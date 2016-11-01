function [] = quantile_plot_analytic(parameters_true, phat_ols,...
    phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib, xx, errors_igd, res, s)

% Shows the change in each quantile with a specified variable. 



H = size(xx,1);


[~, sigma2hat_ols, thetahat_ols]  = extract_ols(phat_ols, xx);
[~, ahat_frr, bhat_frr, ~] = extract_frr(phat_frr, xx);
[~, sigma2hat_igd, thetahat_igd] = extract_igd(phat_igd, xx);
[~, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg, xx);
[~, ~, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg, xx);
[~, ~, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br, xx);
[~, ~, ~, ~, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib, xx);




%% Quantiles
%       Generating Analytic Quantile Distributions
% At each observation, the quantile* functions generate a
% function F(p) = LGD* where the collection of all {LGD : LGD <
% LGD*} comprise a fraction p of the total distribution.

% It is stored so that each level in the z dimension represents
% a different model.
%-------------------------------------------------------------------------%
yy = zeros(H, res, 8);
for h = 1:1:H
    [~, yy(h, :, 1)]        = quantile_true(res, parameters_true, xx(h, :));        % True
    [~, yy(h, :, 2)]        = quantile_ols(res, sigma2hat_ols, thetahat_ols(h));    % OLS
    [~, yy(h, :, 3)]        = quantile_igd(res, sigma2hat_igd, thetahat_igd(h));    % IGD
    [~, yy(h, :, 4)]        = quantile_frr(res, ahat_frr, bhat_frr(h));             % FRR
    [~, yy(h, :, 5)]        = quantile_cg(res, epsilonhat_cg, alphahat_cg, thetahat_cg(h)); % CG
    [~, yy(h, :, 6)]        = quantile_ttg(res, epsilonhat_ttg, alphahat_ttg, thetahat_ttg(h), thetatilhat_ttg(h)); % TTG
    [~, yy(h, :, 7)]        = quantile_br(res, clhat_br, cuhat_br, ahat_br(h), bhat_br(h)); % BR
    [~, yy(h, :, 8)]        = quantile_ib(res, P0hat_ib(h), P1hat_ib(h), ahat_ib(h), bhat_ib(h));     % IB
end
%-------------------------------------------------------------------------%


%       Aggregating the quantiles across observations
% For each observation, we pull out F(p) where p = .1, .2, .3,
% .4, .5, .6, .7, .8, and .9. We do this because we know that
% the ouput in the above section that is cut off by the ~ is
% linspace(0, 1, res).
%-------------------------------------------------------------------------%
y_decimal = zeros(H, 10, 8);    % 9 columns for each quantile, a 1-th for
% the mean
for h = 1:1:8
    y_decimal(:, 1, h) =  yy(:, 1 * (res / 10), h);
    y_decimal(:, 2, h) =  yy(:, 2 * (res / 10), h);
    y_decimal(:, 3, h) =  yy(:, 3 * (res / 10), h);
    y_decimal(:, 4, h) =  yy(:, 4 * (res / 10), h);
    y_decimal(:, 5, h) =  yy(:, 5 * (res / 10), h);
    y_decimal(:, 6, h) =  yy(:, 6 * (res / 10), h);
    y_decimal(:, 7, h) =  yy(:, 7 * (res / 10), h);
    y_decimal(:, 8, h) =  yy(:, 8 * (res / 10), h);
    y_decimal(:, 9, h) =  yy(:, 9 * (res / 10), h);
end
%-------------------------------------------------------------------------%


y_decimal(:, 10, 1) = expected_true(parameters_true, xx);
y_decimal(:, 10, 2) = expected_ols(phat_ols, xx);
y_decimal(:, 10, 3) = expected_igd(phat_igd, xx, errors_igd);
y_decimal(:, 10, 4) = expected_frr(phat_frr, xx);
y_decimal(:, 10, 5) = expected_cg(phat_cg, xx);
y_decimal(:, 10, 6) = expected_ttg(phat_ttg, xx);
y_decimal(:, 10, 7) = expected_br(phat_br, xx);
y_decimal(:, 10, 8) = expected_ib(phat_ib, xx);




%% Plotting the Quantiles

%       Making labels to use in graphing
%-------------------------------------------------------------------------%
true_model = ['Original ', '(', parameters_true{1}, ')'];
label_model = {true_model, 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};
label_percentage = {' p = .1', ' p = .2', ' p = .3', ' p = .4', ' p = .5', ' p = .6', ' p = .7', ' p = .8', ' p = .9', 'mean'};
%-------------------------------------------------------------------------%


LB = min(xx(:, s));
UB = max(xx(:, s));




%% Plots with 10 Percentages on graph. 8 graphs, ones for each model
%-------------------------------------------------------------------------%

figure()
for q =1:1:4
    subplot(2, 2, q)
    hold on;
    for h = 1:1:10
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off
    legend(label_percentage)
    title(label_model(q))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
figure()
for q =5:1:8
    subplot(2, 2, (q - 4))
    hold on;
    for h = 1:1:10
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off
    legend(label_percentage)
    title(label_model(q))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%



%% Plots with 8 models on each graph. 10 graphs, one for each quantile


%       True, OLS, IGD, FRR
%-------------------------------------------------------------------------%
figure()
g = [1 2 3 4 5 6 7 8];
for h =1:1:5
    subplot(2, 3, h)
    hold on;
    for q = g
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off;
    legend(label_model)
    title(label_percentage(h))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%



%
%-------------------------------------------------------------------------%
figure()
g = [1 2 3 4 5 6 7 8];
for h =6:1:10
    subplot(2, 3, (h - 5))
    hold on;
    for q = g
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off;
    legend(label_model)
    title(label_percentage(h))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%




%-------------------------------------------------------------------------%
figure()
g = [1 2];
for h = 1:1:10
    subplot(5, 2, h)
    hold on;
    for q = g;
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off
    legend(label_model(g))
    title(label_percentage(h))
    axis([LB UB -1.05 1.05])
end
%-------------------------------------------------------------------------%




%-------------------------------------------------------------------------%
figure()
g = [1 3 4];
for h = 1:1:10
    subplot(5, 2, h)
    hold on;
    for q = g;
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off
    legend(label_model(g))
    title(label_percentage(h))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
figure()
g = [1 5 6];
for h = 1:1:10
    subplot(5, 2, h)
    hold on;
    for q = g;
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off
    legend(label_model(g))
    title(label_percentage(h))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
figure()
g = [1 7 8];
for h = 1:1:10
    subplot(5, 2, h)
    hold on;
    for q = g;
        plot(xx(:, s), y_decimal(:, h, q))
    end
    hold off
    legend(label_model(g))
    title(label_percentage(h))
    axis([LB UB 0 1.05])
end
%-------------------------------------------------------------------------%






