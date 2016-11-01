function [table_mfx] = table_mfx(phat, drops, mu_x, errors_igd)

% Makes a graph of the marginal effects as it changes with a random
% variable. Uses mean of all other variabels as a basis. 

h = .0001;

D = length(drops);

parameters_true = phat{1};
phat_ols        = phat{2};
phat_igd        = phat{3};
phat_frr        = phat{4};
phat_cg         = phat{5};
phat_ttg        = phat{6};
phat_br         = phat{7};
phat_ib         = phat{8};

K = size(phat_ols{1}, 1) - 1;



g = [-2 -1 0 1 2] + mu_x(1);
G = length(g);
x3 = zeros(2 * G, 1);
for t = 1:1:G
    x3(2*t - 1)  = g(t) - h;
    x3(2*t)      = g(t) + h;
end

x1 = ones(2 * G, 1);
x2 = mu_x(1) * ones(2 * G, 1);



xz = mu_x(2) * ones(2 * G, 8);

xx = [x1 x2 x3 xz];

ey      = cell(1, D);
mfx1    = zeros(2 * G - 1, 8, D);
mfx     = zeros(D, 8, G);

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

p = zeros(G, 1);

for t = 1:1:G;
    p(t) = 2*t - 1; 
end

for d = 1:1:D
    mfx1(:, 1, d) = squeeze(diff(ey{d}(:, 1)) ./ (2 * h));
    mfx1(:, 2, d) = squeeze(diff(ey{d}(:, 2)) ./ (2 * h));
    mfx1(:, 3, d) = squeeze(diff(ey{d}(:, 3)) ./ (2 * h));
    mfx1(:, 4, d) = squeeze(diff(ey{d}(:, 4)) ./ (2 * h));
    mfx1(:, 5, d) = squeeze(diff(ey{d}(:, 5)) ./ (2 * h));
    mfx1(:, 6, d) = squeeze(diff(ey{d}(:, 6)) ./ (2 * h));
    mfx1(:, 7, d) = squeeze(diff(ey{d}(:, 7)) ./ (2 * h));
    mfx1(:, 8, d) = squeeze(diff(ey{d}(:, 8)) ./ (2 * h));
    
    mfx(d, 1, :) = squeeze(mfx1(p, 1, d));
    mfx(d, 2, :) = squeeze(mfx1(p, 2, d));
    mfx(d, 3, :) = squeeze(mfx1(p, 3, d));
    mfx(d, 4, :) = squeeze(mfx1(p, 4, d));
    mfx(d, 5, :) = squeeze(mfx1(p, 5, d));
    mfx(d, 6, :) = squeeze(mfx1(p, 6, d));
    mfx(d, 7, :) = squeeze(mfx1(p, 7, d));
    mfx(d, 8, :) = squeeze(mfx1(p, 8, d));
end

table_mfx = cell(1, G);

true_model = 'True';
label_models = {true_model, 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};

label_drops = cell(D, 1);
for d = 1:1:D
        label_drops{d} = [num2str(drops(d)), ' Vars Dropped'];
end



for t = 1:1:G
    table_mfx{t} = array2table(mfx(:, :, t), 'Rownames', label_drops, 'VariableNames', label_models);
end






