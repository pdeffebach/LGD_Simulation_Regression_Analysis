function [] = variance_cdfs_dropping_vars(phat, X, drops, res)

% Plots the cdfs of some random observations. Variance means how different
% they all are. Should be more variance with full model. 

v = 'variance_cdfs';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);


label_models = {'true', 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};

m = 3; 
% 2 = OLS 
% 3 = IGD
% 4 = FRR
% 5 = CG
% 6 = TTG
% 7 = BR
% 8 = IB

model = label_models{m};

N = size(X, 1);
T  = 10;
p = randperm(N, T);
X1 = X(p, :);

K = size(X, 2);

D = length(drops);
label_drops = cell(1, D+1);
label_drops{1} = 'true params';
for d = 2:1:D+1
        label_drops{d} = [num2str(drops(d-1)), ' Vars Dropped'];
end

parameters_true = phat{1};
phat_ols        = phat{2};
phat_igd        = phat{3};
phat_frr        = phat{4};
phat_cg         = phat{5};
phat_ttg        = phat{6};
phat_br         = phat{7};
phat_ib         = phat{8};

D   = size(drops, 2);



%       Generating Histograms and Inverted CDFs
%-------------------------------------------------------------------------%
P = linspace(0, 1, res)';


%       Plotting the way the models match variation in X (X2 changes)
%-------------------------------------------------------------------------%
% a = ones(H, 1);
% b = linspace(-5, 5, H)';
% c = zeros(H, K-2);
xx = X1;
K = size(X, 2);

qq = cell(1, D);
for d = 1:1:D    
    kk = K - drops(d);
    xx1 = X1(:, 1:kk);
    
    [~, sigma2hat_ols, thetahat_ols]  = extract_ols(phat_ols{d}, xx1);
    [~, ahat_frr, bhat_frr, ~] = extract_frr(phat_frr{d}, xx1);
    [~, sigma2hat_igd, thetahat_igd] = extract_igd(phat_igd{d}, xx1);
    [~, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg{d}, xx1);
    [~, ~, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg{d}, xx1);
    [~, ~, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br{d}, xx1);
    [~, ~, ~, ~, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib{d}, xx1);

    for h = 1:1:T
        [~, qq{d}(h, :, 1)]        = quantile_true(res, parameters_true, xx(h, :));         % True
        [~, qq{d}(h, :, 2)]        = quantile_ols(res, sigma2hat_ols, thetahat_ols(h));     % OLS
        [~, qq{d}(h, :, 3)]        = quantile_igd(res, sigma2hat_igd, thetahat_igd(h));     % IGD
        [~, qq{d}(h, :, 4)]        = quantile_frr(res, ahat_frr, bhat_frr(h));              % FRR
        [~, qq{d}(h, :, 5)]        = quantile_cg(res, epsilonhat_cg, alphahat_cg, thetahat_cg(h));  % CG
        [~, qq{d}(h, :, 6)]        = quantile_ttg(res, epsilonhat_ttg, alphahat_ttg, thetahat_ttg(h), thetatilhat_ttg(h));  % TTG
        [~, qq{d}(h, :, 7)]        = quantile_br(res, clhat_br, cuhat_br, ahat_br(h), bhat_br(h));  % BR
        [~, qq{d}(h, :, 8)]        = quantile_ib(res, P0hat_ib(h), P1hat_ib(h), ahat_ib(h), bhat_ib(h));    % IB
    end
end    

for d = 1:1:D
    figure()
    hold on
    for t = 1:1:T
        y = qq{d}(t, :, m);
        plot(y, P)
    end
    title(['CDFs for ', num2str(T), ' random observations : ', num2str(drops(d)), ' variables dropped ', '(', model, ')'])
    hold off;
    
    t1 = ['variance_cdfs_', model, '_', num2str(drops(d)), '_vars_dropped'];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end

close all








