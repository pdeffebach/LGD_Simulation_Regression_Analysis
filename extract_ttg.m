function [betahat_ttg, gammahat_ttg, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg, xx)

% Gives you all the relevant parameters for the TTG model. 


kk = size(xx, 2);

betahat_ttg         = phat_ttg(1:kk);
gammahat_ttg        = phat_ttg(kk+1:2*kk);
alphahat_ttg        = phat_ttg(2*kk+1);
epsilonhat_ttg      = phat_ttg(2*kk+2);

thetatilhat_ttg     = exp(xx*betahat_ttg);
thetahat_ttg        = exp(xx*gammahat_ttg);