function [total_dist_cg] = predicted_cg(phat_cg, xx, N_1)

% Generates simulated distribution for CG model. 



% thetahat_cg is an N X 1 vector that are the value of linking
% functions with the estimated parameters. So for each observation there
% is a unique value used in generating the gamma distribution. This
% process then takes N_1 draws for each observation using the estimated
% parameters and returns an N x N_1 matrix with N_1 random draws for each
% observation. ahat_cg is NOT like ahat_br. the ahat_br used in the beta
% regression is the output value of the linking function for each
% observation. ahat_cg is the alpha value used in the construction of the
% distribution. It is a scalar. 


N = size(xx, 1);

%       Extracting the parameters for the Censored Gamma
%-------------------------------------------------------------------------%
[~, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg, xx);
%-------------------------------------------------------------------------%



theta = repmat(thetahat_cg, 1, N_1);
total_dist_cg = gamrnd(alphahat_cg, theta) - epsilonhat_cg;
total_dist_cg(total_dist_cg <= 0) = 0;
total_dist_cg(total_dist_cg >= 1) = 1;

% for q = 1:1:N
% %-------------------------------------------------------------------------%
%     Z_hat = gamrnd(alphahat_cg, thetahat_cg(q), N_1, 1);
%     Yshat = Z_hat - epsilonhat_cg;
%     Ycg = zeros(N_1,1);
%     Ycg(Yshat<=0)=0;
%     Ycg(Yshat>0 & Yshat < 1) = Yshat(Yshat>0 & Yshat<1);
%     Ycg(Yshat>=1) = 1;
%     total_dist_cg(q, :) = Ycg; 
%     % Each row is a different predicted distribution
% %-------------------------------------------------------------------------%
% end