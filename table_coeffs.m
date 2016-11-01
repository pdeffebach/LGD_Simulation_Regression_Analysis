function [t_coeffs_full_model, t_coeffs_first_drops] = table_coeffs(phat, std_errors)

% Shows the coefficients and standard errors for the estimated parameters
% of the true model, and shows how that compares with the true parametrs.


global FIGURES_PATH
folder_name = [FIGURES_PATH, 'tables'];


parameters_true = phat{1};
model = parameters_true{1};
parameters = parameters_true{2};

% To understand this code you need to understand how the packets of
% information phat and std_errors are organized. The key difference is that
% the cell array phat also has the true parameters in it, so the numbering
% for the models is different for the two arrays. phat{*}{5} is CG while
% std_errors{*}{4} is CG.

if strcmp(model, 'CG')
    
    %       Table for the Full Model
    
    K = size(parameters, 1) - 2;
    label_variables = cell(1, K+2);
    for k = 1:1:K
        label_variables{k} = ['X' num2str(k)];
    end
    label_variables{K+1} = 'alpha';
    label_variables{K+2} = 'epsilon';
    
    label_coeffs = {'True_Beta', 'Estimated_Beta', 'Standard_Errors_Beta'};
    
    estimated_params_cg = phat{5}{1};
    std_errors_cg = std_errors{4}{1};
    
    t = [parameters estimated_params_cg std_errors_cg];
    t_coeffs_full_model = array2table(t, 'RowNames', label_variables, 'VariableNames', label_coeffs);
    
    %   Table for First Set of Drops
    
    estimated_params_cg = phat{5}{2};
    std_errors_cg = std_errors{4}{2};
    
    kk  = (size(estimated_params_cg, 1) - 2);
    z   = NaN(K-kk, 1);
    
    estimated_params_cg = [estimated_params_cg(1:kk); z; estimated_params_cg(kk+1:kk+2)];
    std_errors_cg       = [std_errors_cg(1:kk); z; std_errors_cg(kk+1:kk+2)];
    
    t = [parameters estimated_params_cg std_errors_cg];
    t_coeffs_first_drops = array2table(t, 'RowNames', label_variables, 'VariableNames', label_coeffs);
    
    
end


if strcmp(model, 'TTG')
    %       Table for the Full Model
    
    K = (size(parameters, 1) - 2) / 2;
    label_variables = cell(1, K+2);
    for k = 1:1:K
        label_variables{k} = ['X' num2str(k)];
    end
    label_variables{K+1} = 'alpha';
    label_variables{K+2} = 'epsilon';
    
    label_coeffs = {'True_Beta', 'Estimated_Beta', 'Standard_Errors_Beta', 'True_Gamma', 'Estimated_Gamma', 'Standard_Errors_Gamma'};
    
    betatrue = [parameters(1:K); NaN; NaN];
    gammatrue = parameters(K+1: 2*K + 2);
    
    estimated_params_ttg    = phat{6}{1};
    std_errors_ttg     = std_errors{5}{1};
    
    betahat_ttg     = [estimated_params_ttg(1:K); NaN; NaN];
    gammahat_ttg    = estimated_params_ttg(K+1:2*K);
    alphahat_ttg    = estimated_params_ttg(2*K+1);
    epsilonhat_ttg  = estimated_params_ttg(2*K+2);
    
    gammahat_alphahat_epsilonhat = [gammahat_ttg; alphahat_ttg; epsilonhat_ttg];
    
    std_errors_beta     = [std_errors_ttg(1:K); NaN; NaN];
    std_errors_gamma    = std_errors_ttg(K+1:2*K);
    std_errors_alpha    = std_errors_ttg(2*K+1);
    std_errors_epsilon  = std_errors_ttg(2*K+2);
    
    std_errors_gamma_alpha_epsilon = [std_errors_gamma; std_errors_alpha; std_errors_epsilon];
    
    t = [betatrue betahat_ttg std_errors_beta gammatrue gammahat_alphahat_epsilonhat  std_errors_gamma_alpha_epsilon];
    
    t_coeffs_full_model = array2table(t, 'RowNames', label_variables, 'VariableNames', label_coeffs);
    
    
    %       Table for First Set of Drops
    
    estimated_params_ttg    = phat{6}{2};
    std_errors_ttg     = std_errors{5}{2};
    
    kk  = (size(estimated_params_ttg, 1) - 2) / 2;
    z   = NaN(K-kk, 1);
    
    betahat_ttg     = [estimated_params_ttg(1:kk); z; NaN; NaN];
    gammahat_ttg    = estimated_params_ttg(kk+1:2*kk);
    alphahat_ttg    = estimated_params_ttg(2*kk+1);
    epsilonhat_ttg  = estimated_params_ttg(2*kk+2);
    
    gammahat_alphahat_epsilonhat = [gammahat_ttg; z; alphahat_ttg; epsilonhat_ttg];
    
    std_errors_beta     = [std_errors_ttg(1:kk); z; NaN; NaN];
    std_errors_gamma    = std_errors_ttg(kk+1:2*kk);
    std_errors_alpha    = std_errors_ttg(2*kk+1);
    std_errors_epsilon  = std_errors_ttg(2*kk+2);
    
    std_errors_gamma_alpha_epsilon = [std_errors_gamma; z; std_errors_alpha; std_errors_epsilon];
    
    t = [betatrue betahat_ttg std_errors_beta gammatrue gammahat_alphahat_epsilonhat  std_errors_gamma_alpha_epsilon];
    
    t_coeffs_first_drops = array2table(t, 'RowNames', label_variables, 'VariableNames', label_coeffs);
    
    
    
end



if strcmp(model, 'IB')
    
    %       Table for Full Model
    
    K = (size(parameters, 1) - 1) / 3;
    
    for k = 1:1:K
        label_variables{k} = ['X' num2str(k)];
    end
    label_variables{K+1} = 'phi';
    
    label_coeffs = {'True_Beta', 'Estimated_Beta', 'Standard_Errors_Beta',...
        'True_Gamma', 'Estimated_Gamma', 'Standard_Errors_Gamma',...
        'True_r', 'Estimated_r', 'Standard_Errors_r'};
    
    betatrue = [parameters(1:K); 0];
    gammatrue = [parameters(K+1: 2*K); 0];
    rtrue = parameters(2*K+1: 3*K);
    phitrue = parameters(3*K+1);
    
    r_true_phi_true = [rtrue; phitrue];
    
    estimated_params_ib    = phat{8}{1};
    std_errors_ib     = std_errors{7}{1};
    
    betahat_ib     = [estimated_params_ib(1:K); NaN];
    gammahat_ib    = [estimated_params_ib(K+1:2*K); NaN];
    rhat_ib        = estimated_params_ib(2*K+1: 3*K);
    phihat_ib      = estimated_params_ib(3*K+1);
    
    rhat_phihat  = [rhat_ib; phihat_ib];
    
    
    std_errors_beta = [std_errors_ib(1:K); NaN];
    std_errors_gamma = [std_errors_ib(K+1:2*K); NaN];
    std_errors_r    = std_errors_ib(2*K+1:3*K);
    std_errors_phi = std_errors_ib(3*K+1);
    
    std_errors_r_phi = [std_errors_r; std_errors_phi];
    
    t = [betatrue betahat_ib std_errors_beta gammatrue gammahat_ib std_errors_gamma r_true_phi_true rhat_phihat std_errors_r_phi];
    t_coeffs_full_model = array2table(t, 'RowNames', label_variables, 'VariableNames', label_coeffs);
    
    
    %       Table for First Drops
    
    estimated_params_ib = phat{8}{2};
    std_errors_ib      = std_errors{7}{2};
    
    kk  = (size(estimated_params_ib, 1) - 1) / 3;
    z   = NaN(K-kk, 1);
    
    betahat_ib     = [estimated_params_ib(1:kk); z; NaN];
    gammahat_ib    = [estimated_params_ib(kk+1:2*kk); z; NaN];
    rhat_ib        = estimated_params_ib(2*kk+1: 3*kk);
    phihat_ib      = estimated_params_ib(3*kk+1);
    
    rhat_phihat  = [rhat_ib; z; phihat_ib];
    
    
    std_errors_beta = [std_errors_ib(1:kk); z; NaN];
    std_errors_gamma = [std_errors_ib(kk+1:2*kk); z; NaN];
    std_errors_r    = std_errors_ib(2*kk+1:3*kk);
    std_errors_phi = std_errors_ib(3*kk+1);
    
    std_errors_r_phi = [std_errors_r; z; std_errors_phi];
    
    
    t = [betatrue betahat_ib std_errors_beta gammatrue gammahat_ib std_errors_gamma r_true_phi_true rhat_phihat std_errors_r_phi];
    t_coeffs_first_drops = array2table(t, 'RowNames', label_variables, 'VariableNames', label_coeffs);
end

t1 = [folder_name '\t_coeffs_full_model.csv'];
writetable(t_coeffs_full_model, t1, 'WriteRowNames', true, 'Delimiter', 'comma');

t1 = [folder_name '\t_coeffs_first_drops.csv'];
writetable(t_coeffs_first_drops, t1, 'WriteRowNames', true, 'Delimiter', 'comma');




