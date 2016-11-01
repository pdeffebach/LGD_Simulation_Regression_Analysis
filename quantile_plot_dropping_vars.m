function [] = quantile_plot_dropping_vars(parameters_true, phat_ols,...
    phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib, xx, errors_igd, kk, s)

% Shows the change in each quantile with a specified variable, dropping
% variables each time.

K = size(xx, 2);

% s is what variable is being changed when we make these quantile plots. 

% res is the density of the inverted CDF graphs. It doesn't actually need
% to be higher than 11, since we are only interested in the 10th percentile
% through the 9th percentile. 
res = 11;



v = ['quantile_', num2str(K - kk), '_vars_dropped'];
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);


H = size(xx,1);
x = xx(:, 1:kk);

if (kk ~= (size(phat_ols, 1) - 1))
   error('You do not have the right dimensions with your OLS paramaters') 
end


[~, sigma2hat_ols, thetahat_ols]  = extract_ols(phat_ols, x);
[~, ahat_frr, bhat_frr, ~] = extract_frr(phat_frr, x);
[~, sigma2hat_igd, thetahat_igd] = extract_igd(phat_igd, x);
[~, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg, x);
[~, ~, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg, x);
[~, ~, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br, x);
[~, ~, ~, ~, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib, x);




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
    y_decimal(:, 1, h) =  yy(:, 1 + 1, h);
    y_decimal(:, 2, h) =  yy(:, 2 + 1, h);
    y_decimal(:, 3, h) =  yy(:, 3 + 1, h);
    y_decimal(:, 4, h) =  yy(:, 4 + 1, h);
    y_decimal(:, 5, h) =  yy(:, 5 + 1, h);
    y_decimal(:, 6, h) =  yy(:, 6 + 1, h);
    y_decimal(:, 7, h) =  yy(:, 7 + 1, h);
    y_decimal(:, 8, h) =  yy(:, 8 + 1, h);
    y_decimal(:, 9, h) =  yy(:, 9 + 1, h);
end
%-------------------------------------------------------------------------%


y_decimal(:, 10, 1) = expected_true(parameters_true, xx);
y_decimal(:, 10, 2) = expected_ols(phat_ols, x);
y_decimal(:, 10, 3) = expected_igd(phat_igd, x, errors_igd);
y_decimal(:, 10, 4) = expected_frr(phat_frr, x);
y_decimal(:, 10, 5) = expected_cg(phat_cg, x);
y_decimal(:, 10, 6) = expected_ttg(phat_ttg, x);
y_decimal(:, 10, 7) = expected_br(phat_br, x);
y_decimal(:, 10, 8) = expected_ib(phat_ib, x);



%% Plotting the Quantiles

%       Making labels to use in graphing
%-------------------------------------------------------------------------%
true_model = ['Original ', '(', parameters_true{1}, ')'];
label_models = {true_model, 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};
label_percentages = {' p = .1', ' p = .2', ' p = .3', ' p = .4', ' p = .5', ' p = .6', ' p = .7', ' p = .8', ' p = .9', 'mean'};
%-------------------------------------------------------------------------%

%% Plots with 10 Percentages on graph. 8 graphs, ones for each model
%-------------------------------------------------------------------------%

LB = min(x(:, s));
UB = max(x(:, s));

pp = [3 5 7 10];
P = size(pp, 2);

figure()
for q =1:1:4
    subplot(2, 2, q)
    hold on;
    for h = 1:1:P
        plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off
    
    if q == 2
        legend(label_percentages(pp))
    end
    
    title(label_models(q))
    axis([LB UB 0 1.05])
end
t1 = ['xx_m1_', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path)
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
figure()
for q =5:1:8
    subplot(2, 2, (q - 4))
    hold on;
    for h = 1:1:P
        plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off
    if (q-4) == 2
        legend(label_percentages(pp))
    end
    
    title(label_models(q))
    axis([LB UB 0 1.05])
end

t1 = ['xx_m2_', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path)
%-------------------------------------------------------------------------%



%% Plots with different models on each graph

pp = [2 4 6 8];     % Which percentiles you want to print. 
P = size(pp, 2);

figure()
g = [1 2 3 4 5 6 7 8];
for h =1:1:P
    subplot(2, 2, h)
    hold on;
    for q = g
            plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off;
    
    if (h) == 2
        legend(label_models, 'Location', 'NorthEast')
    end
    title(label_percentages(pp(h)))
    axis([LB UB 0 1.05])
end

t1 = ['xx_m_ALL_', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path)
%-------------------------------------------------------------------------%








% This variable keeps track of which percentiles you would like to plot
pp = [3 5 7 10];    
P = size(pp, 2);

%-------------------------------------------------------------------------%
figure()
g = [1 2];
for h = 1:1:P
    subplot(2, 2, h)
    hold on;
    for q = g;
        plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off
    
    if h == 2
        legend(label_models(g));
    end
    
    title(label_percentages(h))
    axis([LB UB -1.05 1.05])
end

t1 = ['xx_p_OLS', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path)
%-------------------------------------------------------------------------%




%-------------------------------------------------------------------------%
figure()
g = [1 3 4];
for h = 1:1:P
    subplot(2, 2, h)
    hold on;
    for q = g;
        plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off
    
    if h == 2
        legend(label_models(g));
    end
    
    title(label_percentages(pp(h)))
    axis([LB UB 0 1.05])
end
t1 = ['xx_p_IGD_FRR_', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path)
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
figure()
g = [1 5 6];
for h = 1:1:P
    subplot(2, 2, h)
    hold on;
    for q = g;
            plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off
    
    if h == 2
        legend(label_models(g));
    end
    
    title(label_percentages(pp(h)))
    axis([LB UB 0 1.05])
end

t1 = ['xx_p_CG_TTG_', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path);

%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
figure()
g = [1 7 8];
for h = 1:1:P
    subplot(2, 2, h)
    hold on;
    for q = g;
            plot(x(:, s), y_decimal(:, pp(h), q))
    end
    hold off
    
    if h == 2
        legend(label_models(g));
    end
    
    title(label_percentages(pp(h)))
    axis([LB UB 0 1.05])
end


t1 = ['xx_p_BR_IB_', v];
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path);
%-------------------------------------------------------------------------%

%}

%}


