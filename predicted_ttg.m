function [total_dist_ttg] = predicted_ttg(phat_ttg, xx, N_1)

% Generates simulated distribution for TTG model. 


% thetahat_ttg and thetatilhat_ttg are N X 1 vectors that are the value of
% linking functions with the estimated parameters. So for each observation
% there are two unique values used in generating the gamma distribution.
% This process then takes N_1 draws for each observation using the
% estimated parameters and returns an N x N_1 matrix with N_1 random draws
% for each observation. ahat_ttg is NOT like ahat_br. the ahat_br used in
% the beta regression is the output value of the linking function for each
% observation. ahat_ttg is the alpha value used in the construction of the
% distribution. It is a scalar.


N = size(xx, 1);

%       Extracting parameters for the Two Tiered Gamma
%-------------------------------------------------------------------------%
[~, ~, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg, xx);
%-------------------------------------------------------------------------%

thetatil = repmat(thetatilhat_ttg, 1, N_1);
dist_thetatil = gamrnd(alphahat_ttg, thetatil);
dist_thetatil = dist_thetatil - epsilonhat_ttg;

epsilon2 = repmat(epsilonhat_ttg, N, 1);
u = rand(size(thetatil));
g1 = gamcdf(epsilon2, alphahat_ttg, thetahat_ttg);
g = repmat(g1, 1, N_1);
r = u .* (1 - g) + g;

epsilon3 = repmat(epsilon2, 1, N_1);
theta = repmat(thetahat_ttg, 1, N_1);
total_dist_ttg = gaminv(r, alphahat_ttg, theta) - epsilon3;

total_dist_ttg(dist_thetatil <= 0) = 0;
total_dist_ttg(dist_thetatil > 0 & total_dist_ttg >= 1) = 1;


% This is what the code was earlier. Its slower, but it is easier to
% understand what is going on. 

% total_dist_ttg = zeros(N, N_1);
% for q = 1:1:N
% %-------------------------------------------------------------------------%
%     Z1        = gamrnd(alphahat_ttg, thetatilhat_ttg(q), N_1, 1);
%     Y1star    = Z1 - epsilonhat_ttg;
%     u         = rand(N_1,1);
%     g1        = gamcdf(epsilonhat_ttg, alphahat_ttg, thetahat_ttg(q));
%     Y2star    = gaminv(u*(1-g1) + g1, alphahat_ttg, thetahat_ttg(q)) - epsilonhat_ttg;
%     Yttg      = zeros(N_1,1);
%     Yttg(Y1star<=0)=0;
%     Yttg(Y1star>0 & Y2star<1) = Y2star(Y1star>0 & Y2star<1);
%     Yttg(Y1star>0 & Y2star >=1) = 1;
%     total_dist_ttg(q,:) = Yttg;  
% %-------------------------------------------------------------------------%
% end
% hist(total_dist_ttg(:));









