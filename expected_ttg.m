function [ey_ttg] = expected_ttg(phat_ttg, xx)

% Generates a vector of expected LGD for TTG given a set of
% parameters and an X vector.

H = size(xx, 1);

[~, ~, alphahat_ttg, epsilonhat_ttg, thetatilhat_ttg, thetahat_ttg] = extract_ttg(phat_ttg, xx);


%       TTG
%-------------------------------------------------------------------------%
p1 = gamcdf(epsilonhat_ttg,   alphahat_ttg, thetatilhat_ttg);   % this is essentially P(Y=0) in eqn 24
p2 = gamcdf(epsilonhat_ttg,   alphahat_ttg, thetahat_ttg);      % similar to denominator of 2nd and 3rd formulas in eqn 24
% p3 = gampdf(Y+epsilonhat_ttg, alphahat_ttg, thetahat_ttg);    % first term of 2nd formula in eqn 24
p4 = gamcdf(1+epsilonhat_ttg, alphahat_ttg, thetahat_ttg);
count = 0;
for h = 1:1:H; 
    if(p2(h) && p4(h) == 1);
        p2(h) = 1 - 0.1;       % Fixes denominator in equation for EY01
        disp('p2(h) && p4(h) == 1')
        count = count+1;
    elseif p2(h) == 1;
        p2(h) = 1 - 0.1;       % Fixes denominator in equation for PY1
    end
end

disp(['Percentage of edge cases while using expected_ttg: ' num2str(count / H)]);

PY1 = (1-p4).*(1-p1)./(1-p2);   % pr(Y=1)
PY0 = p1;                       % pr(Y=0)
PY01 = 1 - PY0 - PY1;           % prob that Y is between 0 and 1
p5 = gamcdf(epsilonhat_ttg, alphahat_ttg+1, thetahat_ttg);
p6 = gamcdf(1+epsilonhat_ttg, alphahat_ttg+1, thetahat_ttg);
EY01 = (alphahat_ttg*thetahat_ttg.*(p6-p5) - epsilonhat_ttg*(p4-p2))./(p4-p2);
                                %The above code is from the May 19th 2016
                                %paper in th appendix. 
ey_ttg = PY1+EY01.*PY01;
%-------------------------------------------------------------------------%