function [total_dist_true] = predicted_true(parameters_true, xx, N_1)

% Generates simulated distribution for true model. Supports CG, TTG, and
% IB.

N = size(xx, 1);
model = parameters_true{1};

%       If using the Censored Gamma Model.
%-------------------------------------------------------------------------%
if strcmp(model, 'CG')
    [~, ~, ~, alpha, epsilon, theta_cg] = extract_true(parameters_true, xx);
    
    theta = repmat(theta_cg, 1, N_1);
    total_dist_true = gamrnd(alpha, theta) - epsilon;
    total_dist_true(total_dist_true <= 0) = 0;
    total_dist_true(total_dist_true >= 1) = 1;
    %-------------------------------------------------------------------------%
    
    
    
elseif strcmp(model, 'TTG')
    [~, ~, ~, alpha, epsilon, thetas] = extract_true(parameters_true, xx);
    
    thetatil_ttg    = thetas(:, 1);    % attached to gamma.
    theta_ttg       = thetas(:, 2);       % attached to beta.
    
    thetatil = repmat(thetatil_ttg, 1, N_1);
    dist_thetatil = gamrnd(alpha, thetatil);
    dist_thetatil = dist_thetatil - epsilon;
    
    epsilon2 = repmat(epsilon, N, 1);
    u = rand(size(thetatil));
    g1 = gamcdf(epsilon2, alpha, theta_ttg);
    g = repmat(g1, 1, N_1);
    r = u .* (1 - g) + g;
    
    epsilon3 = repmat(epsilon2, 1, N_1);
    theta = repmat(theta_ttg, 1, N_1);
    total_dist_true = gaminv(r, alpha, theta) - epsilon3;
    
    total_dist_true(dist_thetatil <= 0) = 0;
    total_dist_true(dist_thetatil > 0 & total_dist_true >= 1) = 1;
    
    %  The above code is hard to follow. The below code is slower, but more
    %  clear. Use this as a guide. 
    %     for n = 1:1:N;
    %         Z1 = gamrnd(alpha, thetatil_ttg(n), N_1, 1);
    %         Y1star = Z1 - epsilon;
    %         u = rand(N_1,1);
    %         g1 = gamcdf(epsilon, alpha, theta_ttg(n));
    %         Y2star = gaminv(u*(1-g1) + g1, alpha, theta_ttg(n)) - epsilon;
    %         Yttg = zeros(N_1, 1);
    %         Yttg(Y1star<=0)=0;
    %         Yttg(Y1star>0 & Y2star<1) = Y2star(Y1star>0 & Y2star<1);
    %         Yttg(Y1star>0 & Y2star >=1) = 1;
    %         total_dist(n,:) = Yttg;
    %     end
    
    
    
elseif strcmp(model, 'IB')
    [~, ~, ~, ~, ~, probspq] = extract_true(parameters_true, xx);
    
    P0_ib   = probspq(:, 1);
    P1_ib   = probspq(:, 2);
    a_ib    = probspq(:, 3);
    b_ib    = probspq(:, 4);
    P01     = 1 - P0_ib - P1_ib;
    P       = [P0_ib P01 P1_ib];
    
    index   = mnrnd(N_1, P);
    n_0     = index(:, 1);
    n_1     = index(:, 3);
    
    a = repmat(a_ib, 1, N_1);
    b = repmat(b_ib, 1, N_1);
    total_dist_true = betarnd(a, b);
    
    
    for q = 1:1:N
        if (n_0(q) ~= 0 || n_1(q) ~= 0)
            t = randperm(N_1, n_0(q) + n_1(q));
            total_dist_true(q, t) = [zeros(1,n_0(q)) ones(1,n_1(q))];
        end
    end
    
else
    error('Your model string is incorrect.');
end





