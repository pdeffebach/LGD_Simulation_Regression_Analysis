function [ negll ] = negloglikbr_peter( parameters, X, Y)

% beta regression negative log likelihood.  
%   Parameters theta, phi, cl, cu
K = size(X, 2);


theta = parameters(1:K);
phi   = parameters(K+1:2*K);
cl    = parameters(2*K+1);
cu    = parameters(2*K+2);
a  = log(1+exp(X*theta));
b  = log(1+exp(X*phi));
% Subscript 0 is when Ri = 0
% Subscript 1 is when Ri = 1
% Subscript 2 is when Ri = (0, 1)
a0 = a(Y==0);
b0 = b(Y==0);
z0 = (cl/(1+cl+cu));
P0 = betainc(z0, a0, b0) - betainc(0, a0, b0);      % kind of like a cdf
L0 = log(P0);
a1 = a(Y==1);
b1 = b(Y==1);
z1 = (1+cl)/(1+cl+cu);
P1 = betainc(1, a1, b1) - betainc(z1, a1, b1); 
L1 = log(P1);

a2 = a(Y>0 & Y<1);
b2 = b(Y>0 & Y<1);
Y2 = Y(Y>0 & Y<1);
z2 = (Y2 + cl)/(1 + cl + cu);         
P2 = ((z2.^(a2-1)) .* (1-z2).^(b2-1))./(beta(a2, b2) .* (1 + cl + cu)); 
L2 = log(P2);

negll = -(sum(L2) + sum(L1) + sum(L0));

end