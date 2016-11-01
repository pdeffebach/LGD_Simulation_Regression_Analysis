function [] = hist_ey_dropping_vars(ey, drops)

% Makes histograms of the expected LGD for the true model and various other
% models. Also plots kernel density graphs. 

v = 'expected_y';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);

label_models = {'OLS', 'IGD', 'FRR', 'CG', 'TTG', 'BR', 'IB', 'true'};
M = length(label_models) - 1;

N = size(ey{1}, 1);

ey_true     = ey{1};


D = length(drops);
label_drops = cell(1, D + 1);
for d = 1:1:D
        label_drops{d} = [num2str(drops(d)), ' Vars Dropped'];
end
label_drops{D+1} = 'true params';


 y = zeros(N, D, M);
 
for d = 1:1:D
    for m = 1:1:7
    y(:, d, m)  = ey{m+1}{d};
    end
end


edges = 0:.05:1;

% histograms hist_ey_MODEL
for m = 1:1:M
    figure()
    subplot(2, 2, 1)
    histogram(ey_true, edges, 'Normalization', 'probability');
    ylim([0 .3])
    title('True Parameters')
    for d = 1:1:D
        subplot(2, 2, d + 1)
        histogram(y(:, d, m), edges, 'Normalization', 'probability');
        ylim([0 .3])
        title(label_drops{d});
    end
    
    t1 = ['hist_ey_', label_models{m}];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end


% histograms hist_ey_*_vars*dropped 
for d = 1:1:D
    figure()
    subplot(4, 2, 1);
    histogram(ey_true, edges, 'Normalization', 'probability');
    ylim([0 .3])
    title('True Parameters')
    for m = 1:1:M
        subplot(4, 2, m + 1)
        histogram(y(:, d, m), edges, 'Normalization', 'probability');
        ylim([0 .3])
        title(label_models{m});
    end
    t1 = ['hist_ey_', num2str(drops(d)), '_vars_dropped'];
    set(gcf, 'Name', t1,'NumberTitle','off')
    full_path = [folder_name, '\', t1];
    screen2pic(full_path);
end


%       Making the Kernal densities: kernel_density_ey
figure()
for m = 1:1:M;
    subplot(3, 3, m);
    hold on;
    for d = 1:1:D
       pd = fitdist(squeeze(y(:, d, m)), 'Kernel');
       x_values = linspace(0, 1, 1000);
       yy = pdf(pd, x_values);
       plot(x_values, yy);
       title(label_models{m})
       
       if m == 3
          legend(label_drops{1:D}) 
       end
    end
    hold off
end

t1 = 'kernel_density_ey';
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path);



