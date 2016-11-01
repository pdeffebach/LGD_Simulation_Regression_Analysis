function [ey_igd] = expected_igd(phat_igd, xx, errors)


% Generates a vector of expected LGD for IGD given a set of
% parameters and an X vector.

[betahat_igd, ~, ~] = extract_igd(phat_igd, xx);


% If you want to use MC, all you would have to do would be to change this
% code. 
ey_igd = duan_smearing(xx, betahat_igd, errors);

