function [] = boxplots_ks(p_stats, k_stats, precision, type)


% Generates Boxplots for the main() code. i.e. without dropping variables. 


%       Generating Labels
%-------------------------------------------------------------------------%
P = length(precision);
draws = cell(1, P);
size(k_stats)
for p = 1:1:P
    temp = [num2str(precision(p)), ' ', type];
    draws{p} = temp;
end
models = {'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};
M = length(models);
%-------------------------------------------------------------------------%



%       Box Plots for K Statistics, Changing Draws
%-------------------------------------------------------------------------%
figure('Name', 'KS statistics with degrees of precision')
for m = 1:1:M
    fname = ['boxplot of ks statistics: ', models{m}];
    h(m) = subplot(3, 3, m);
    boxplot(k_stats(:, :, m), 'Labels', draws)
    title(fname)
end
linkaxes(h)
ylim([0 .5])
%-------------------------------------------------------------------------%




%       Box Plots for K Statistics, Changing Draws
%-------------------------------------------------------------------------%
figure('Name', 'KS statistics with degrees of precision')
for m = 1:1:M
    fname = ['boxplot of ks statistics: ', models{m}];
    k(m) = subplot(3, 3, m);
    boxplot(k_stats(:, :, m), 'Labels', draws)
    title(fname)
end
linkaxes(k)
ylim([0 .1])
%-------------------------------------------------------------------------%




%       Boxplots for P Statistics, Changing Draws
%-------------------------------------------------------------------------%
figure('Name', 'p-values with degrees of precision')
for m = 1:1:M
    fname = ['boxplot of p statistics: ', models{m}];
    h(m) = subplot(3, 3, m);
    boxplot(p_stats(:, :, m), 'Labels', draws)
    title(fname)
end
linkaxes(h)
ylim([0 1])
%-------------------------------------------------------------------------%




%       Box Plots for K Statistics, Changing Models
% %-------------------------------------------------------------------------%
figure('Name', 'KS statistics by model')
for p = 1:1:P
    fname = ['boxplot of ks statistics: ', draws{p}];
    g(p) = subplot(2, 3, p);
    boxplot(squeeze(k_stats(:, p, :)), 'Labels', models)
    title(fname)
end
linkaxes(g)
ylim([0 .5])
%-------------------------------------------------------------------------%

