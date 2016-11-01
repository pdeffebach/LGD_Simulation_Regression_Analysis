function [] = boxplot_ks_dropping_vars(p_stats, k_stats, drops)

% Makes boxplots of the KS statistics and P-values in the format specified
% by ks_draws_dropping_vars

v = 'boxplots';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);

%       Making the Labels
%-------------------------------------------------------------------------%
label_models = {'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};
M = length(label_models);

D = length(drops);
label_drops = cell(1, D);
for d = 1:1:D
    if (drops(d) == 0)
        label_drops{d} = 'Full Model';
    else 
        label_drops{d} = [num2str(drops(d)), ' Vars Dropped'];
    end
end

%       Plotting Keeping Drops Constant (on a single graph)
%-------------------------------------------------------------------------%

figure()
for d = 1:1:D;
    subplot(2, 2, d)
    boxplot(k_stats(:, :, d), 'Labels', label_models, 'OutlierSize', .5)
    title(['Distribution of KS-Statistics: ' label_drops{d}])
    set(gca,'FontSize',10,'XTickLabelRotation',45)
    ylim([0 1])
end
t1 = 'boxplot_ks_drops';
full_path = [folder_name, '\', t1];
set(gcf, 'Name', t1,'NumberTitle','off')
screen2pic(full_path);



figure()
for m = 1:1:M;
    subplot(3, 3, m)
    boxplot(squeeze(k_stats(:, m, :)), 'Labels', label_drops, 'OutlierSize', .5)
    title(['Distribution of KS-Statistics: ' label_models{m}])
    set(gca,'FontSize',10,'XTickLabelRotation',45)
    ylim([0 1])
end
t1 = 'boxplots_ks_models';
full_path = [folder_name, '\', t1];
set(gcf, 'Name', t1,'NumberTitle','off')
screen2pic(full_path);


%       Plotting Keeping Models Constant (on a single graph)
%-------------------------------------------------------------------------%
figure()
for d = 1:1:D;
    subplot(2, 2, d)
    boxplot(p_stats(:, :, d), 'Labels', label_models, 'OutlierSize', .5)
    title(['Distribution of P-Values: ' label_drops{d}])
    set(gca,'FontSize',10,'XTickLabelRotation',45)
    ylim([0 1])
end
t1 = 'boxplots_p_drops';
full_path = [folder_name, '\', t1];
set(gcf, 'Name', t1,'NumberTitle','off')
screen2pic(full_path);



figure()
for m = 1:1:M;
    subplot(3, 3, m)
    boxplot(squeeze(p_stats(:, m, :)), 'Labels', label_drops, 'OutlierSize', .5)
    title(['Distribution of P-Values: ' label_models{m}])
    set(gca,'FontSize',10,'XTickLabelRotation',45)
    ylim([0 1])
end
t1 = 'boxplots_p_models';
full_path = [folder_name, '\', t1];
set(gcf, 'Name', t1,'NumberTitle','off')
screen2pic(full_path);