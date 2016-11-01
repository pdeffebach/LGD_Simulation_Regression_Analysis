function [phat, EY, stats, std_errors] =  regression_br(X, Y)

% Performs the BR regression

                % Given a matrix X for independent variables and a vector Y
                % for the observed outcome variable, this function runs a
                % beta regression and returns a set of parameters. See
                % Yashkir (2013) for more information on this regression.
K = size(X, 2);
                
options = optimset('MaxFunEvals', 1000000);
p0 = .01 * rand(2*K+2,1);

l = [-Inf*ones(2*K,1); 0; 0];

u = Inf*ones(2*K+2,1);

f = @(p)negloglikbr_peter(p, X, Y);
[phat,~,~,~,~,~,hessian] = fmincon(f, p0,[],[],[],[],l, u,[], options);

%       Getting the Standard Errors using the delta method. No need to use
%       the whol g_prime thing since we are minimizing with respect to the
%       parameters themselves, not some function of the parameters, but its
%       useful to keep things consistent.
%-------------------------------------------------------------------------%
deriv_theta = ones(K, 1);
deriv_psi   = ones(K, 1);
deriv_cl    = 1;
deriv_cu    = 1;

t = [deriv_theta;  deriv_psi; deriv_cl; deriv_cu];
g_prime = diag(t);    

covariance = (g_prime / hessian) * g_prime';
std_errors=sqrt(diag(covariance));
%-------------------------------------------------------------------------%



%       Getting the estimated Y
EY = expected_br(phat, X);

    
% Statistics
SSE = sum((EY-Y).^2);
SST = sum((EY - mean(Y)).^2);
R2  = 1 - SSE/SST;

Pearson  = corr(EY, Y, 'type', 'Pearson');
Kendall  = corr(EY, Y, 'type', 'Kendall');
Spearman = corr(EY, Y, 'type', 'Spearman');

stats = [SSE; SST; R2; Pearson; Kendall; Spearman];