function [ey_br] = expected_br(phat_br, xx)

% Generates a vector of expected LGD for the beta regression given a set of
% parameters and an X vector.


[~, ~, clhat_br, cuhat_br, ahat_br, bhat_br] = extract_br(phat_br, xx);

% clhat_br and cuhat_br are both constants. ahat_br and bhat_br are vectors
% of length N. 

% For more information, see the appendix of the paper. 


%       Placeholders used in equation 2
t = (1 + clhat_br) / (1 + clhat_br + cuhat_br);
s = (clhat_br) / (1 + clhat_br + cuhat_br);
      

%       Probability of Z being between between 0 and 1 (equation 2)
% P_Z_01 = betacdf(t, ahat_br, bhat_br) - betacdf(s, ahat_br, bhat_br);


q = (1 + clhat_br + cuhat_br) *  (ahat_br ./ (ahat_br + bhat_br));

A = q .* (betacdf(t, ahat_br + 1, bhat_br) - betacdf(s, ahat_br + 1, bhat_br));

B = clhat_br * (betacdf(t, ahat_br, bhat_br) - betacdf(s, ahat_br, bhat_br));

% I skip dividing by P_Z_01 here because you get NaNs and you are going to
% multiply it by P_Z_01 in the next step anyways. 
E_Z_01 = (A - B); 

%       Probability of Z being between 1 and Cu, probability of observing 1
P_Z_1 = 1 - betacdf(t, ahat_br, bhat_br);

%       No need to calculate probability of observing zero

ey_br = E_Z_01 + P_Z_1;
