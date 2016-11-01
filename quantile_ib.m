function [P, YQ] = quantile_ib(res, P0, P1, a_ib, b_ib)  

% Generates an inverted CDF for one observation for the IB model.

% all inputs are scalar because we are working with one observation. 


P = linspace(0, 1, res)';
YQ = zeros(size(P));
P01 = 1 - P0 - P1;

for r = 1:1:res
    if P(r) <= P0
        YQ(r) = 0;
    elseif P(r) >= (1 - P1)
        YQ(r) = 1;
    else
        YQ(r) = betainv(((P(r) - P0)) / P01, a_ib, b_ib);
    end
end
