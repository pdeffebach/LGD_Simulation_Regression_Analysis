function [thetahat_br, psihat_br, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br, xx)

% Gives you all the relevant parameters for the BR model. 

kk = size(xx, 2);

thetahat_br         = phat_br(1:kk);
psihat_br           = phat_br(kk+1:2*kk);
clhat_br            = phat_br(2*kk+1);
cuhat_br            = phat_br(2*kk+2);

ahat_br             = log(1+exp(xx*thetahat_br));
bhat_br             = log(1+exp(xx*psihat_br)); 
