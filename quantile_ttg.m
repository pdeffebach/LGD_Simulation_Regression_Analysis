function [ P, YQ ] = quantile_ttg( res, epsilon, alpha, theta, thetatil )

% Generates an inverted CDF for one observation for the IGD model. 

% all inputs are scalars because we are working with one observation. 


%quantileTTG Finds the quantiles from TTG using inverse transform sampling
%method
%   This is the same method used to generate the TTG data (inverse
%   transform sampling) but instead of using a uniform rand from [0,1],
%   that is replaced with p, the desired quantile
%   Estimated parameters needed:
%       Epsilon (Shift)
%       alpha (shape)
%       theta (link to beta), thetatil (link to gamma)
%       res = granularity of P vector
%  This function fixes a particular X value, (1 theta, 1 thetatil) and
%  produces the conditional percentiles for all values of P from 0, 1
    P = linspace(0, 1, res)';
    
    g1 = gamcdf(epsilon, alpha, theta);
    g2 = gamcdf(epsilon, alpha, thetatil);
    F_1star = g2 + ((1-g2)/(1-g1))*(gamcdf(epsilon +1, alpha, theta) - g1);
    
    YQ = gaminv((P-g2)*(1-g1)/(1-g2) + g1, alpha, theta) - epsilon;
    YQ(P<=g2) = 0;
    YQ(P>=F_1star) = 1;
    YQ(P==1) = 1;

