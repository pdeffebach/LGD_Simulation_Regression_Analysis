function [t_mean_Y] = table_diff_mean_Y(ey, Y, drops)

% Table showing the distance between E(LGD) and the mean of the observed
% LGD distribution. Like SST, but with absolute value, not squared
% distance. 


global FIGURES_PATH
folder_name = [FIGURES_PATH, 'tables'];

mean_Y = mean(Y);

D = length(drops);

ey_true = ey{1};
ey_ols  = ey{2};
ey_igd  = ey{3};
ey_frr  = ey{4};
ey_cg   = ey{5};
ey_ttg  = ey{6};
ey_br   = ey{7};
ey_ib   = ey{8};

N = size(ey_ols{1}, 1);

res_true    = zeros(D, 1);
res_ols     = zeros(D, 1);
res_igd     = zeros(D, 1);
res_frr     = zeros(D, 1);
res_cg      = zeros(D, 1);
res_ttg     = zeros(D, 1);
res_br      = zeros(D, 1);
res_ib      = zeros(D, 1);



for d = 1:1:D
    res_true(d) = sum(abs(ey_true - mean_Y)) / N;
    res_ols(d) = sum(abs(ey_ols{d} - mean_Y)) / N;
    res_igd(d) = sum(abs(ey_igd{d} - mean_Y)) / N;
    res_frr(d) = sum(abs(ey_frr{d} - mean_Y)) / N;
    res_cg(d)  = sum(abs(ey_cg{d}  - mean_Y)) / N;
    res_ttg(d) = sum(abs(ey_ttg{d} - mean_Y)) / N;
    res_br(d)  = sum(abs(ey_br{d}  - mean_Y)) / N;
    res_ib(d)  = sum(abs(ey_ib{d}  - mean_Y)) / N;
    
end


label_drops = cell(D, 1);
for d = 1:1:D
        label_drops{d} = [num2str(drops(d)), ' Vars Dropped'];
end

t_mean_Y = table(res_true, res_ols, res_igd, res_frr, res_cg, res_ttg, res_br, res_ib, 'RowNames', label_drops); 

t1 = [folder_name '\t_mean_Y.csv'];
writetable(t_mean_Y, t1, 'WriteRowNames', true, 'Delimiter', 'comma');