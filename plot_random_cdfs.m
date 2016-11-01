function [] = plot_random_cdfs(parameters_true, phat_ols,...
    phat_igd, phat_frr, phat_cg, phat_ttg, phat_br, phat_ib, xx, res)


% Plots random cdfs of for each model, without dropping variables. Useful
% for seeing if regressions are working. 

H = 10;
N = size(xx, 1);
p = randperm(N, H);

xx = xx(p, :);

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
    [P, yy(h, :, 1)]        = quantile_true(res, parameters_true, xx(h, :));        % True
    [~, yy(h, :, 2)]        = quantile_ols(res, sigma2hat_ols, thetahat_ols(h));    % OLS
    [~, yy(h, :, 3)]        = quantile_igd(res, sigma2hat_igd, thetahat_igd(h));    % IGD
    [~, yy(h, :, 4)]        = quantile_frr(res, ahat_frr, bhat_frr(h));              % FRR
    [~, yy(h, :, 5)]        = quantile_cg(res, epsilonhat_cg, alphahat_cg, thetahat_cg(h)); % CG 
    [~, yy(h, :, 6)]        = quantile_ttg(res, epsilonhat_ttg, alphahat_ttg, thetahat_ttg(h), thetatilhat_ttg(h)); % TTG
    [~, yy(h, :, 7)]        = quantile_br(res, clhat_br, cuhat_br, ahat_br(h), bhat_br(h)); % BR
    [~, yy(h, :, 8)]        = quantile_ib(res, P0hat_ib(h), P1hat_ib(h), ahat_ib(h), bhat_ib(h));     % IB
end



true_model = ['Original ', '(', parameters_true{1}, ')'];
label_model = {true_model, 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};



figure()
for h = 1:1:6;
    subplot(3, 2, h);
    hold on
    for m = 1:1:8
        plot(yy(h, :, m), P)
    end
    legend(label_model, 'Location', 'NortheastOutside');
    title('quantiles for a given observation: all')
end


g = [1 2 3 4];
figure()
for h = 1:1:6;
    subplot(3, 2, h);
    hold on
    for m = g;
        plot(yy(h, :, m), P)
    end
    legend(label_model(g), 'Location', 'NortheastOutside');
    title('quantiles for a given observation: True, OLS, IGD, FRR')
end


g = [1 5 6 7 8];
figure()
for h = 1:1:6;
    subplot(3, 2, h);
    hold on
    for m = g
        plot(yy(h, :, m), P)
    end
    legend(label_model(g), 'Location', 'NortheastOutside');
    title('quantiles for a given observation: True, CG, TTG, BR, IB')
end




g = [1 3 4];
figure()
for h = 1:1:6;
    subplot(3, 2, h);
    hold on
    for m = g
        plot(yy(h, :, m), P)
    end
    legend(label_model(g), 'Location', 'NortheastOutside');
    title('quantiles for a given observation: True, IGD, FRR')
end






