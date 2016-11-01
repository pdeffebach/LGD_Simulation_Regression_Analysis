function [betahat_frr, ahat_frr, bhat_frr, thetahat_frr] = extract_frr(phat_frr, xx)

% Gives you all the relevant parameters for the BR model. 


kk = size(xx, 2);


betahat_frr     = phat_frr(1:kk);
ahat_frr        = phat_frr(kk+1);


thetahat_frr = 1 ./ (1 + exp(-xx * betahat_frr));    % G in paper, also EY
bhat_frr = ahat_frr .* ((1 - thetahat_frr)./ thetahat_frr);



