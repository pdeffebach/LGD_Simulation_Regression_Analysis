function [total_dist_br] = predicted_br(phat_br, xx, N_1)

% Generates simulated distribution for BR model. 


% ahat_br and bhat_br are N X 1 vectors that are the value of linking
% functions with the estimated parameters. So for each observation there
% are two unique values used in generating the beta distribution. This
% process then takes N_1 draws for each observation using the estimated
% parameters and returns an N x N_1 matrix with N_1 random draws for each
% observation. 


N = size(xx, 1);

%       Extracting parameters for beta regression
%-------------------------------------------------------------------------%
[~, ~, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br, xx);
%-------------------------------------------------------------------------%






total_dist_br = zeros(N, N_1);
%-------------------------------------------------------------------------%
for q = 1:1:N
    Ybr = zeros(N_1,1);
    Si_hat = betarnd(ahat_br(q), bhat_br(q), N_1, 1);
    Zhat = Si_hat .* (1 + clhat_br + cuhat_br) - clhat_br;
    Ybr(Zhat<=0) = 0;
    Ybr(Zhat>0 & Zhat<1) = Zhat(Zhat>0 & Zhat<1);
    Ybr(Zhat>=1) = 1;
    total_dist_br(q,:) = Ybr';
end
%-------------------------------------------------------------------------%




