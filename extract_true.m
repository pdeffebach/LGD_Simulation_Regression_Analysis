function [beta, gamma, r, alpha, epsilon, link] = extract_true(parameters_true, xx)

% Gives you all the relevant parameters for the true model model. Supports
% CG, TTG, and IB.


%       Explanation
%-------------------------------------------------------------------------%
% Given the model type and the true parameters, this function gives you
% the true parameter values and the linking function. Given that there is a
% different linking function for each model, the outputs are named
% ambiguously. For the censored gamma model, there is only one linking
% function, which takes the form of theta. 


%-------------------------------------------------------------------------%
kk = size(xx, 2);
model = parameters_true{1};
parameters = parameters_true{2};
beta    = [];
gamma   = [];
r       = [];
alpha   = 0;
epsilon = 0;

%       If true model is Censored Gamma.
%-------------------------------------------------------------------------%
if strcmp(model, 'CG')
    beta            = parameters(1:kk);
    alpha           = parameters(kk + 1);
    epsilon         = parameters(kk + 2);
    link            = exp(xx*beta);
end
%-------------------------------------------------------------------------%

if strcmp(model, 'TTG')
    gamma       = parameters(1:kk);
    beta        = parameters(kk+1:2*kk);
    alpha       = parameters(2*kk+1);
    epsilon     = parameters(2*kk+2);
    thetatil    = exp(xx*gamma);
    theta       = exp(xx*beta);
    link        = [thetatil theta];
end

    

if strcmp(model, 'IB')
    beta    = parameters(1:kk);
    gamma   = parameters(kk+1:2*kk);
    r       = parameters(2*kk+1:3*kk);
    
    P0_ib          = exp(xx*beta)./(1+exp(xx*beta)+ exp(xx*gamma) );
    P1_ib          = exp(xx*gamma)./(1+exp(xx*beta)+ exp(xx*gamma) );
    mutrue      = 1./(1+exp(-xx*r));
    phitrue     = 1;
    
    a_ib           = mutrue*phitrue;
    b_ib           = (1-mutrue)*phitrue;

    link = [P0_ib P1_ib a_ib b_ib];
end

