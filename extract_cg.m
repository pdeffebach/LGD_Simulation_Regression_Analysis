function [betahat_cg, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg, xx)


% Gives you all the relevant parameters for the CG model. 

kk = length(phat_cg) - 2;

betahat_cg          = phat_cg(1:kk);
alphahat_cg         = phat_cg(kk+1);
epsilonhat_cg       = phat_cg(kk+2);

thetahat_cg = exp(xx * betahat_cg);