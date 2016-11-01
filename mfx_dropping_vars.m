function [] = mfx_dropping_vars(phat, drops, mu_x, errors_igd)

% Plots the marginal effects of x3 on E(LGD). 


v = 'marginal_effects';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);

D = length(drops);
H = 10000;

parameters_true = phat{1};
phat_ols        = phat{2};
phat_igd        = phat{3};
phat_frr        = phat{4};
phat_cg         = phat{5};
phat_ttg        = phat{6};
phat_br         = phat{7};
phat_ib         = phat{8};

K = size(phat_ols{1}, 1) - 1;

x1 = ones(H, 1);
x2 = mu_x(1) * ones(H, 1);
x3 = linspace(-5, 5, H)';
xz = mu_x(2) * ones(H, K-3);

xx = [x1 x2 x3 xz];

ey = cell(1, D);
mfx = cell(1, D);

for d = 1:1:D
    kk = K - drops(d);
    xx1 = xx(:, 1:kk);
    ey{d}(:, 1) = expected_true(parameters_true, xx);
    ey{d}(:, 2) = expected_ols(phat_ols{d}, xx1);
    ey{d}(:, 3) = expected_igd(phat_igd{d}, xx1, errors_igd{d});
    ey{d}(:, 4) = expected_frr(phat_frr{d}, xx1);
    ey{d}(:, 5) = expected_cg(phat_cg{d}, xx1);
    ey{d}(:, 6) = expected_ttg(phat_ttg{d}, xx1);
    ey{d}(:, 7) = expected_br(phat_br{d}, xx1);
    ey{d}(:, 8) = expected_ib(phat_ib{d}, xx1);
    
end

for d = 1:1:D
    mfx{d}(:, 1) = diff(ey{d}(:, 1)) ./ diff(x3);
    mfx{d}(:, 2) = diff(ey{d}(:, 2)) ./ diff(x3);
    mfx{d}(:, 3) = diff(ey{d}(:, 3)) ./ diff(x3);
    mfx{d}(:, 4) = diff(ey{d}(:, 4)) ./ diff(x3);
    mfx{d}(:, 5) = diff(ey{d}(:, 5)) ./ diff(x3);
    mfx{d}(:, 6) = diff(ey{d}(:, 6)) ./ diff(x3);
    mfx{d}(:, 7) = diff(ey{d}(:, 7)) ./ diff(x3);
    mfx{d}(:, 8) = diff(ey{d}(:, 8)) ./ diff(x3);
end


true_model = 'True';
label_models = {true_model, 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};

label_drops = cell(1, D + 1);
label_drops{1} = 'True';

for d = 1:1:D
        label_drops{d+1} = [num2str(drops(d)), ' Vars Dropped'];
end

p = x3(1:end-1);

% all mfx_MODEL graphs. 
for m = 2:1:8
    figure()
    hold on
    plot(p, mfx{1}(:, 1))
    for d = 1:1:D
        plot(p, mfx{d}(:, m))
    end
    legend(label_drops)
    title(['Marginal Effects: ', label_models{m}])
    ylim([-.22, .12])
    hold off
    
    t1 = ['mfx_', label_models{m}];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end



