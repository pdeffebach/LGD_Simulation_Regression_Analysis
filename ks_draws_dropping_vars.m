function [p_stats, k_stats] = ks_draws_dropping_vars(dist_true, dist_ols, dist_igd, dist_frr, dist_cg, dist_ttg, dist_br, dist_ib)

% For doing ks-tests on your simulated distributions. For use with dropping
% vars. 

    
    N = size(dist_ols, 1);
    
    p_stats = zeros(N, 7);
    k_stats = size(N, 7);
    
    for n = 1:1:N
       [~, p_stats(n, 1), k_stats(n, 1)] = kstest2(dist_ols(n, :),  dist_true(n, :));
       [~, p_stats(n, 2), k_stats(n, 2)] = kstest2(dist_igd(n, :),  dist_true(n, :)); 
       [~, p_stats(n, 3), k_stats(n, 3)] = kstest2(dist_frr(n, :),  dist_true(n, :)); 
       [~, p_stats(n, 4), k_stats(n, 4)] = kstest2(dist_cg(n, :),   dist_true(n, :)); 
       [~, p_stats(n, 5), k_stats(n, 5)] = kstest2(dist_ttg(n, :),  dist_true(n, :)); 
       [~, p_stats(n, 6), k_stats(n, 6)] = kstest2(dist_br(n, :),   dist_true(n, :)); 
       [~, p_stats(n, 7), k_stats(n, 7)] = kstest2(dist_ib(n, :),   dist_true(n, :)); 
    end
    
    