function [] = random_cdfs_dropping_vars(phat, X, res, drops)

% Plots the Inverted CDFs for A set of randomly selected observations
global FIGURES_PATH

N = size(X, 1);
D = length(drops);
K = size(phat{2}{1}, 1) - 1;

T = 4;

p = randperm(N, T);
X = X(p, :);


parameters_true = phat{1};

for d = 1:1:D
    kk  = K - drops(d);
    XX  = X(:, 1:kk);
    
    phat_ols        = phat{2}{d};
    phat_igd        = phat{3}{d};
    phat_frr        = phat{4}{d};
    phat_cg         = phat{5}{d};
    phat_ttg        = phat{6}{d};
    phat_br         = phat{7}{d};
    phat_ib         = phat{8}{d};
    
    
    z = [num2str(drops(d)), '_vars_dropped'];
    v = ['random_cdfs_', z];
    folder_name = [FIGURES_PATH, v];
    mkdir(folder_name);
    
    H = size(XX,1);
    
    if (size(XX, 2) ~= (size(phat_ols, 1) - 1))
        error('You do not have the right dimensions with your OLS paramaters')
    end
    
    [~, sigma2hat_ols, thetahat_ols]  = extract_ols(phat_ols, XX);
    [~, ahat_frr, bhat_frr, ~] = extract_frr(phat_frr, XX);
    [~, sigma2hat_igd, thetahat_igd] = extract_igd(phat_igd, XX);
    [~, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg, XX);
    [~, ~, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg, XX);
    [~, ~, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br, XX);
    [~, ~, ~, ~, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib, XX);
    
    
    
    
    %% CDFS
    %       Generating Analytic Quantile Distributions
    % At each observation, the quantile* functions generate a
    % function F(p) = LGD* where the collection of all {LGD : LGD <
    % LGD*} comprise a fraction p of the total distribution.
    
    % It is stored so that each level in the z dimension represents
    % a different model.
    %---------------------------------------------------------------------%
    yy = zeros(H, res, 8);
    P = linspace(0, 1, res)';
    for h = 1:1:H
        [~, yy(h, :, 1)]        = quantile_true(res, parameters_true, X(h, :));        % True
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
    
    
    for h = 1:1:T;
        figure()
        hold on
        for m = 1:1:8
            plot(yy(h, :, m), P)
        end
        hold off
        legend(label_model, 'Location', 'Northwest');
        title('cdfs for a given observation: all')
        
        t1 = ['r_cdfs_ALL_', num2str(h), '_', z];
        set(gcf, 'Name', t1,'NumberTitle','off')
        full_path = [folder_name, '\', t1];
        screen2pic(full_path);
    end
    
    
    
    g = [1 2 3 4];
    for h = 1:1:T;
        figure()
        hold on
        for m = g;
            plot(yy(h, :, m), P)
        end
        hold off
        legend(label_model(g), 'Location', 'Northwest');
        title('cdfs for a given observation: True, OLS, IGD, FRR')
        
        t1 = ['r_cdfs_OLS_IGD_FRR_', num2str(h), '_', z];
        set(gcf, 'Name', t1,'NumberTitle','off')
        full_path = [folder_name, '\', t1];
        screen2pic(full_path);
    end
    
    
    
    
    g = [1 5 6 7 8];
    for h = 1:1:T;
        figure()
        hold on
        for m = g
            plot(yy(h, :, m), P)
        end
        hold off
        legend(label_model(g), 'Location', 'Northwest');
        title('cdfs for a given observation: True, CG, TTG, BR, IB')
        
        
        t1 = ['r_cdfs_CG_TTG_BR_IB_', num2str(h), '_', z];
        set(gcf, 'Name', t1,'NumberTitle','off')
        full_path = [folder_name, '\', t1];
        screen2pic(full_path);
    end
    
    
    
    g = [1 3 4];
    for h = 1:1:T;
        figure()
        hold on
        for m = g
            plot(yy(h, :, m), P)
        end
        hold off
        legend(label_model(g), 'Location', 'Northwest');
        title('cdfs for a given observation: True, IGD, FRR')
        
        
        t1 = ['r_cdfs_IGD_FRR_', num2str(h), '_', z];
        set(gcf, 'Name', t1,'NumberTitle','off')
        full_path = [folder_name, '\', t1];
        screen2pic(full_path);
    end
    
    close all
end



