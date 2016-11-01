function [t_SSE] = table_SSE(stats, drops)

% Makes a table of SSEs by models and drops. 

global FIGURES_PATH
folder_name = [FIGURES_PATH, 'tables'];

D = length(drops);

stats_ols  = stats{1};
stats_igd  = stats{2};
stats_frr  = stats{3};
stats_cg   = stats{4};
stats_ttg  = stats{5};
stats_br   = stats{6};
stats_ib   = stats{7};

SSE_ols = zeros(D, 1);
SSE_igd = zeros(D, 1);
SSE_frr = zeros(D, 1);
SSE_cg  = zeros(D, 1);
SSE_ttg = zeros(D, 1);
SSE_br  = zeros(D, 1);
SSE_ib  = zeros(D, 1);

for d = 1:1:D;
    SSE_ols(d) = stats_ols{d}(1);
    SSE_igd(d) = stats_igd{d}(1);
    SSE_frr(d) = stats_frr{d}(1);
    SSE_cg(d) = stats_cg{d}(1);
    SSE_ttg(d) = stats_ttg{d}(1);
    SSE_br(d) = stats_br{d}(1);
    SSE_ib(d) = stats_ib{d}(1);
end

label_drops = cell(D, 1);
for d = 1:1:D
        label_drops{d} = [num2str(drops(d)), ' Vars Dropped'];
end

t_SSE = table(SSE_ols, SSE_igd, SSE_frr, SSE_cg, SSE_ttg, SSE_br, SSE_ib, 'RowNames', label_drops);

t1 = [folder_name '\t_SSE.csv'];
writetable(t_SSE, t1, 'WriteRowNames', true, 'Delimiter', 'comma');