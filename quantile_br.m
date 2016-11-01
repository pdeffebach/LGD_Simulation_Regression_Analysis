function [ P, YQ ] = quantile_br( res, cl, cu, a, b )

% Generates an inverted CDF for one observation for the BR model. 


% quantileBR2 Quantile function for beta regression as seen in Duan and
% Hwang (2014)

% all inputs are scalar because we are working with one observation. 

P0 = betacdf( (cl) / (1 + cl + cu), a, b);
P1 = betacdf( (1+cl)/(1+cl+cu), a, b);
P = linspace(0, 1, res)';
YQ = zeros(size(P));
YQ(P<=P0) = 0;
YQ(P>P0 & P<P1) = (1 + cl + cu) * betaincinv(P(P>P0 & P<P1), a, b) - cl;
YQ(P>=P1) = 1;
end

