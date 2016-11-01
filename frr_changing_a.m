function [] = frr_changing_a(xx, Y, phat)

% Shows way the unconditional predicted LGD for the frr model changes with
% the parameter 'a', which we set. 

% The histograms from this function are stored in histogram_frr_changing_a.


v = 'histogram_frr_changing_a';
global FIGURES_PATH
folder_name = [FIGURES_PATH, v];
mkdir(folder_name);



phat_frr = phat{4}{1};

N = size(xx, 1);
kk = size(xx, 2);

[params, ~] = betafit(Y); 
a_fit = params(1);

a_model = phat_frr(end);
a_params = [a_model .5 1 2 5 a_fit];
B = size(a_params, 2);
Y_frr = zeros(N, B);


for b = 1:1:B;
    phat_frr(kk+1)  = a_params(b);
    Y_frr(:, b)     = predicted_frr(phat_frr, xx, 1);
end


edges = 0:.1:1;

figure()
for b = 1:1:B;
    subplot(3, 2, b);
    histogram(Y_frr(:, b), edges, 'Normalization', 'probability');
    title(['a = ' num2str(a_params(b))])
    
    if b == 1
       title(['a = ' num2str(a_params(b))  ' (used in all other distributions)']) 
    end
    
    if b == B
        title(['a = ' num2str(a_params(b)) ' (from betafit(Y))'])
    end
end

t1 = 'histogram_frr_changing_a';
set(gcf, 'Name', t1,'NumberTitle','off')
full_path = [folder_name, '\', t1];
screen2pic(full_path);
