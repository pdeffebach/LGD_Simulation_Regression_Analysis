function [ X, Y] = datageneration_peter(parameters_true, C, vars, econ, mu_x, sigma_x)

%   datageneration - Produces distribution of simulated data X is generated
%   as multivariable normal, Y_1 generated according to either the Censored
%   Gamma, Two-Tiered Gamma, or Zero-One Beta

model = parameters_true{1};
parameters = parameters_true{2};




%%      Generating the X Variable
%-------------------------------------------------------------------------%

%       Putting the X matrix together
%-------------------------------------------------------------------------%
T = size(econ, 1);
N = C * T;
X1 = ones(N, 1);
X2 = repmat(econ, C, 1);
Xz = normrnd(mu_x(2), sigma_x(2), N, vars);
X  = [X1 X2 Xz];
K = size(X, 2);
%-------------------------------------------------------------------------%

%%      Generating the Y Variable
%       CG
%-------------------------------------------------------------------------%
if  strcmp(model, 'CG');
    % Same Code can be used in predicted_cg function. However code in
    % predicted_cg function is structured differently, to account for N_1
    % draws. 
    
    %       Unpacking the parameters
    beta            = parameters(1:K);
    alpha           = parameters(K + 1);
    epsilon         = parameters(K + 2);
    
    theta_cg = exp(X*beta);         % linking function
    
    Z=gamrnd(alpha, theta_cg);      % non-shifted gamma
    Ystar = Z - epsilon;            % shifting the gamma
    
    Y = zeros(N,1);                 % Allocating space for Y
    Y(Ystar<=0)=0;                  % Censoring it to between 0 and 1
    Y(Ystar>0 & Ystar<1)=Ystar(Ystar>0 & Ystar<1);
    Y(Ystar>=1) = 1;
    %-------------------------------------------------------------------------%
    
elseif strcmp(model, 'TTG');    % Two-Tiered Gamma
    %   The following is the same process used in the predicted_ttg
    %   function. However code in predicted_ttg is mode efficient, to avoid
    %   using for loops. 
    
    %   Unpack the parameters
    beta = parameters(1:K);          % for LGD in (0, 1)
    gamma = parameters(K+1:2*K);     % for LGD < 0
    alpha = parameters(2*K+1);
    epsilon = parameters(2*K+2);
    
    %       Linking Functions
    theta_ttg = exp(X*beta);
    thetatil_ttg = exp(X*gamma);
    
    %       First step
    Z1 = gamrnd(alpha, thetatil_ttg);   % non-shifted gamma
    Y1star = Z1 - epsilon;              % shifted gamma
    Y2star = zeros(N,1);
    
    %       Second step
    for n = 1:1:N
        u = rand;
        g1 = gamcdf(epsilon, alpha, theta_ttg(n));
        Y2istar = gaminv(u*(1-g1) + g1, alpha, theta_ttg(n));
        Y2star(n,1) = Y2istar - epsilon;
    end
    
    %       Necessary Censoring
    Y = zeros(N,1); 
    Y(Y1star<=0)=0;
    Y(Y1star>0 & Y2star < 1) = Y2star(Y1star>0 & Y2star < 1);
    Y(Y1star>0 & Y2star >=1) = 1;
    
    
    
elseif strcmp(model, 'IB')
    %       Unpacking Parameters
    beta    = parameters(1:K);
    gamma   = parameters(K+1:2*K);
    r       = parameters(2*K+1:3*K);
    phi     = parameters(3*K+1);
    
    %       Finding probability of being 0, 1 or between 0 and 1
    P0 = exp(X*beta)./(1+exp(X*beta)+ exp(X*gamma) );
    P1 = exp(X*gamma)./(1+exp(X*beta)+ exp(X*gamma) );
    P01 = 1./(1+exp(X*beta)+ exp(X*gamma) );
    
    %       Used for the middle distribution. 
    mu = 1./(1+exp(-X*r));
    
    % Solve for beta parameters that set the mean equal to mu and phi to what
    % we want.
    a_ib = mu*phi;
    b_ib = (1-mu)*phi;
    Y = zeros(N,1);
    
    %       This code that Hugh wrote is really confusing. he could have
    %       just written if index(1) == 
    
    
    for n = 1:1:N
        index = mnrnd(1, [P0(n,1) P01(n,1) P1(n,1)]); % Chooses 1 draw to inidicate whether a LGD is in 0, in between 0 and 1, or 1
        if index(1) == 1
            Y(n) = 0;
        elseif index(2) == 1
            Y(n) = betarnd(a_ib(n), b_ib(n));
        else
            Y(n) = 1;
        end
    end
end







