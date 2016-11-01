function [t_stats_full_model, t_stats_first_drops] = table_stats(stats)

% Makes tables of regression statistics for the full model and the first
% set of drops. 


% All statistics are stored in the following way:
%
% stats = [SSE; SST; R2; Pearson; Kendall; Spearman];
% 
% stats_ols, for example, then, is a cell array of size D. With the first
% one always being the fullmode. Then they are stored in the following
% code:
%
% stats = {stats_ols, stats_igd, stats_frr, stats_cg, stats_ttg, stats_br,
% stats_ib};
%
% Xinlei has stated that we are just interested in tables for the
% regressions with the full model and with 4 variables dropped (or whatever
% the first set of drops is I guess).

global FIGURES_PATH
folder_name = [FIGURES_PATH, 'tables'];



%% Full Model Table

label_models = {'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};

SSE         = zeros(7, 1);
SST         = zeros(7, 1);
R2          = zeros(7, 1);
Pearson     = zeros(7, 1);
Kendall     = zeros(7, 1);
Spearman    = zeros(7, 1);

for m = 1:1:7
SSE(m)      = stats{m}{1}(1);    
SST(m)      = stats{m}{1}(2);    
R2(m)       = stats{m}{1}(3);    
Pearson(m)  = stats{m}{1}(4);    
Kendall(m)  = stats{m}{1}(5);    
Spearman(m) = stats{m}{1}(6);
end

t_stats_full_model = table(SSE, SST, R2, Pearson, Kendall, Spearman, 'RowNames', label_models);


%% First Set of Drops Table


SSE         = zeros(7, 1);
SST         = zeros(7, 1);
R2          = zeros(7, 1);
Pearson     = zeros(7, 1);
Kendall     = zeros(7, 1);
Spearman    = zeros(7, 1);

for m = 1:1:7
SSE(m)      = stats{m}{2}(1);    
SST(m)      = stats{m}{2}(2);    
R2(m)       = stats{m}{2}(3);    
Pearson(m)  = stats{m}{2}(4);    
Kendall(m)  = stats{m}{2}(5);    
Spearman(m) = stats{m}{2}(6);
end

t_stats_first_drops = table(SSE, SST, R2, Pearson, Kendall, Spearman, 'RowNames', label_models);


t1 = [folder_name '\t_stats_full_model.csv'];
writetable(t_stats_full_model, t1, 'WriteRowNames', true, 'Delimiter', 'comma');

t1 = [folder_name '\t_stats_first_drops.csv'];
writetable(t_stats_first_drops, t1, 'WriteRowNames', true, 'Delimiter', 'comma');



