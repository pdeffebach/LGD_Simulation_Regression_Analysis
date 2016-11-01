function [p_stats, k_stats] = ks_draws(total_dist_true, total_dist_ols, total_dist_igd, total_dist_frr, total_dist_cg, total_dist_ttg, total_dist_br, total_dist_ib, draws)


% makes p statistics and ks statistics for the main() code. No dropping
% variables. 


% original_dist and total_dist are each N x N_1 matrices with N_1 random
% draws from a seperate distribution for each observation. The
% original_dist uses the true values in constructing thie distribution,
% whereas total_dist_cg, total_dist_ttg, and total_dist_br all have
% distributions using the estimated parameters. 

M = length(draws);
N = size(total_dist_true, 1);
J = nargin - 2;

k_stats = zeros(N, M, J);
p_stats = zeros(N, M, J);
N_1 = max(draws);





% k_stats and p_stats both take on the following form: each column
% different statistics changing the number of draws, but keeping the type
% of model used constant, and the z dimension changes the type of
% distribution used. Each row represents a different observation.






for m = 1:1:M
    for n = 1:1:N
        t = randperm(N_1, draws(m));
        [~, p_stats(n, m, 1), k_stats(n, m, 1)] = kstest2(total_dist_ols(n, t), total_dist_true(n, t));
        [~, p_stats(n, m, 2), k_stats(n, m, 2)] = kstest2(total_dist_igd(n, t), total_dist_true(n, t));
        [~, p_stats(n, m, 3), k_stats(n, m, 3)] = kstest2(total_dist_frr(n, t), total_dist_true(n, t));
        [~, p_stats(n, m, 4), k_stats(n, m, 4)] = kstest2(total_dist_cg(n, t), total_dist_true(n, t));
        [~, p_stats(n, m, 5), k_stats(n, m, 5)] = kstest2(total_dist_ttg(n, t), total_dist_true(n, t));
        [~, p_stats(n, m, 6), k_stats(n, m, 6)] = kstest2(total_dist_br(n, t), total_dist_true(n, t));
        [~, p_stats(n, m, 7), k_stats(n, m, 7)] = kstest2(total_dist_ib(n, t), total_dist_true(n, t));
    end
end

