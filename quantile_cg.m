function [ P, YQ ] = quantile_cg(res, epsilon, alpha, theta)    

% Generates an inverted CDF for one observation for the CG model. 

% all inputs are scalars because we are working with one observation. 


P = linspace(0, 1, res)';
YQ = zeros(size(P));
G1 = gamcdf(epsilon, alpha, theta);
G2 = gamcdf(epsilon+1, alpha, theta);
YQ(P>=0 & P<=G1) = 0;
YQ(P>G1 & P<G2) = gaminv(P(P>G1 & P<G2), alpha, theta) - epsilon;
YQ(P>=G2 & P<=1) = 1;
%YQ(P>=G2 & P<1) = NaN; % Not sure why this was here. Maybe Phillip knows. The code seems to work fine with it commented out. 
YQ(P==1) = 1;



end