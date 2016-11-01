function [t_diff_ey] = table_diff_ey(ey, drops)

% Makes a Table of the distance between E(LGD) using an estimated model and
% E(LGD) using the true model and true parameters. Sum of absolute
% distances.

global FIGURES_PATH
folder_name = [FIGURES_PATH, 'tables'];

D = length(drops);

ey_true = ey{1};
ey_ols  = ey{2};
ey_igd  = ey{3};
ey_frr  = ey{4};
ey_cg   = ey{5};
ey_ttg  = ey{6};
ey_br   = ey{7};
ey_ib   = ey{8};

N = size(ey_true, 1);


diff_ey_ols     = zeros(D, 1);
diff_ey_igd     = zeros(D, 1);
diff_ey_frr     = zeros(D, 1);
diff_ey_cg      = zeros(D, 1);
diff_ey_ttg     = zeros(D, 1);
diff_ey_br      = zeros(D, 1);
diff_ey_ib      = zeros(D, 1);


for d = 1:1:D
    diff_ey_ols(d) = sum(abs(ey_ols{d} - ey_true)) / N;
    diff_ey_igd(d) = sum(abs(ey_igd{d} - ey_true)) / N;
    diff_ey_frr(d) = sum(abs(ey_frr{d} - ey_true)) / N;
    diff_ey_cg(d)  = sum(abs(ey_cg{d}  - ey_true)) / N;
    diff_ey_ttg(d) = sum(abs(ey_ttg{d} - ey_true)) / N;
    diff_ey_br(d)  = sum(abs(ey_br{d}  - ey_true)) / N;
    diff_ey_ib(d)  = sum(abs(ey_ib{d}  - ey_true)) / N;
end

label_drops = cell(D, 1);
for d = 1:1:D
        label_drops{d} = [num2str(drops(d)), ' Vars Dropped'];
end


t_diff_ey = table(diff_ey_ols, diff_ey_igd, diff_ey_frr, diff_ey_cg, diff_ey_ttg, diff_ey_br, diff_ey_ib, 'RowNames', label_drops); 

t1 = [folder_name '\t_diff_ey.csv'];
writetable(t_diff_ey, t1, 'WriteRowNames', true, 'Delimiter', 'comma');