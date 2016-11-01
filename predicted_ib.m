function [total_dist_ib] = predicted_ib(phat_ib, xx, N_1)

% Generates simulated distribution for IB model. 


N = size(xx, 1);

[~, ~, ~, ~, P0hat_ib, P1hat_ib, ahat_ib, bhat_ib] = extract_ib(phat_ib, xx);
P01 = 1 - P0hat_ib - P1hat_ib;
P = [P0hat_ib P01 P1hat_ib];

index   = mnrnd(N_1, P);
n_0     = index(:, 1);
n_1     = index(:, 3);


a = repmat(ahat_ib, 1, N_1);
b = repmat(bhat_ib, 1, N_1);
total_dist_ib = betarnd(a, b);

for q = 1:1:N
    if (n_0(q) ~= 0 || n_1(q) ~= 0)
        t = randperm(N_1, n_0(q) + n_1(q));
        total_dist_ib(q, t) = [zeros(1,n_0(q)) ones(1,n_1(q))];
    end
end

% total_dist_ib = zeros(N, N_1);
% choices = 1:3;
% for n = 1:1:N;
%     for j = 1:1:N_1;
%         index = mnrnd(1, [P0hat_ib(n) P01(n) P1hat_ib(n)]);
%         index = (index == 1);
%         mixture = choices(index);
%         if mixture == 1;
%             total_dist_ib(n, j) = 0;
%         elseif mixture == 2;
%             total_dist_ib(n, j) = betarnd(ahat_ib(n), bhat_ib(n));
%         else
%             total_dist_ib(n, j) = 1;
%         end
%     end
% end






