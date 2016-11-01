function [] = hist_one_obs_dropping_vars(dist, drops)

dist_true   = dist{1};
dist_ols    = dist{2};
dist_igd    = dist{3};
dist_frr    = dist{4};
dist_cg     = dist{5};
dist_ttg    = dist{6};
dist_br     = dist{7};
dist_ib     = dist{8};

n = 4;

v = 'historgram_one_obs';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);


label_models = {'true params' 'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB'};
M = length(label_models);

N_1 = size(dist_true, 2);
y_true = (dist_true(n, :))';



D = length(drops);
label_drops = cell(1, D+1);
for d = 2:1:D+1
        label_drops{d} = [num2str(drops(d-1)), ' Vars Dropped'];
end
label_drops{1} = 'true params';


 y = zeros(N_1, D, M - 1);
 
for d = 1:1:D
    y(:, d, 1)  = dist_ols{d}(n, :)';
    y(:, d, 2)  = dist_igd{d}(n, :)';
    y(:, d, 3)  = dist_frr{d}(n, :)';
    y(:, d, 4)   = dist_cg{d}(n, :)';
    y(:, d, 5)  = dist_ttg{d}(n, :)';
    y(:, d, 6)   = dist_br{d}(n, :)';
    y(:, d, 7)   = dist_ib{d}(n, :)';
end






for m = 1:1:M-1
    figure()
    hist([y_true squeeze(y(:, :, m))], 15)
    legend(label_drops, 'Location', 'Northwestoutside')
    q = ['Distribution of Obs ', num2str(n), ': ', label_models{m+1}];
    title(q);
    
    t1 = ['hist_one_obs_', label_models{m}];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end


for d = 1:1:D
    figure()
    hist([y_true squeeze(y(:, d, :))])
    legend(label_models)
    q = ['Distribution of obs ', num2str(n), ': ', label_drops{d + 1}];
    title(q);
    
    t1 = ['hist_one_obs_', num2str(drops(d)), '_vars_dropped'];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end



g = [4 5 6 7];
for d = 1:1:D
    figure()
    hist([y_true squeeze(y(:, d, g))])
    legend([label_models(1) label_models(g)])
    q = ['Distribution of obs ', num2str(n), ': ', label_drops{d + 1}];
    title(q);
    
    
    
    t1 = ['hist_one_obs_good_', num2str(drops(d)), '_vars_dropped'];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end
 

close all











