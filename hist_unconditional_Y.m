function [] = hist_unconditional_Y(phat, dist, drops)

% Plots the unconditional Y distribution (across all observations). 


v = 'histogram_unconditonal_Y';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);

D = size(drops, 2);
label_drops = cell(1, D+1);
label_drops{1} = 'true params';
for d = 2:1:D+1
        label_drops{d} = [num2str(drops(d-1)), ' Vars Dropped'];
end



parameters_true = phat{1};
true_model = ['Original ', '(', parameters_true{1}, ')'];
label_models = {true_model, 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};
M = length(label_models);

edges_ols = linspace(-2, 2, 15);
edges = 0:.1:1;


% hist_uncon_Y_*_vars_dropped
for d = 1:1:D
    figure()
    for m = 1:1:M
        subplot(2, 4, m)
        if m == 1
            histogram(dist{m}(:, 1), edges, 'Normalization', 'Probability')
            title(label_models{m});
        elseif m == 2   % OLS needs a different range in X axis
            histogram(dist{m}{d}(:, 1), edges_ols, 'Normalization', 'Probability')
            title(label_models{m})
        else
            histogram(dist{m}{d}(:, 1), edges, 'Normalization', 'Probability')
            title(label_models{m});
        end
    end
    
    t1 = ['hist_uncon_Y_', num2str(drops(d)), '_vars_dropped'];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end