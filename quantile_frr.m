function [ P, YQ ] = quantile_frr( res, a, b )

% Generates an inverted CDF for one observation for the FRR model. 

% all inputs are scalars because we are working with one observation.
% (b varies across observations). 

P = linspace(0, 1, res)';
YQ = betainv(P, a, b); 


