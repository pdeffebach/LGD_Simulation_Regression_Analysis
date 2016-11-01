function [EY] = duan_smearing(xx, betahat, errors)

% Performs the Duan Smearing Operation. Does not use the full errors vector
% due to computing limitations. 

H = size(errors, 1);

L = 5000;
if (L > H)
    L = H;
end
r = randperm(H, L)';

N = size(xx, 1);


e = errors(r)';

xx_beta = xx * betahat;
h = @(z) normcdf(z, 0, 1);

EY = zeros(N, 1);
for n = 1:1:N
    
xt = repmat(xx_beta(n), 1, L);
hMatDuan = h(xt + e);

EY(n) = mean(hMatDuan, 2);
clear et;
clear xt;
clear hMatDuan;

end

