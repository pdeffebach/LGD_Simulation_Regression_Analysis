function [betahat_ib, gammahat_ib, rhat_ib, phihat_ib, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib, xx)


% Gives you all the relevant parameters for the IB model. 

kk = size(xx, 2);

    betahat_ib      = phat_ib(1:kk);
    gammahat_ib     = phat_ib(kk+1:2*kk);
    rhat_ib         = phat_ib(2*kk+1:3*kk);
    phihat_ib       = phat_ib(3*kk+1);
    
    P0hat_ib       = exp(xx*betahat_ib)./(1+exp(xx*betahat_ib)+ exp(xx*gammahat_ib) );
    P1hat_ib       = exp(xx*gammahat_ib)./(1+exp(xx*betahat_ib)+ exp(xx*gammahat_ib) );
    muhat_ib      = 1./(1+exp(-xx*rhat_ib));
    
    ahat_ib        = muhat_ib*phihat_ib;
    bhat_ib        = (1-muhat_ib)*phihat_ib;