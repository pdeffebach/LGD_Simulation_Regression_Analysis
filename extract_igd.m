function [betahat_igd, sigma2hat_igd, thetahat_igd] = extract_igd(phat_igd, xx)

% Gives you all the relevant parameters for the IGD model. 


kk = size(xx, 2);

betahat_igd         = phat_igd(1:kk);
sigma2hat_igd       = phat_igd(kk+1);


thetahat_igd = xx * betahat_igd;
