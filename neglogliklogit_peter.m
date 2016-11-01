function negll = neglogliklogit_peter(parameters, X, Y)

% FRR regression negative log likelihood. 


% Simulates a logliklogit and Generates the Bernoulli log-likelihood
% function to maximize likelihood of observing the Ys that you observe
 
b = parameters;
EY = exp(X*b)./(1+(exp(X*b)));

ll = Y.*log(EY) + (1-Y).*log(1 - EY);

negll = -sum(ll);