function [ey_cg] = expected_cg(phat_cg, xx)

% Generates a vector of expected LGD for CG given a set of
% parameters and an X vector.

[~, alphahat_cg, epsilonhat_cg, thetahat_cg] = extract_cg(phat_cg, xx);


%       CG (equation 10 in Sigrist) 
%-------------------------------------------------------------------------%
G1 = gamcdf(1+epsilonhat_cg, alphahat_cg+1, thetahat_cg);
G2 = gamcdf(epsilonhat_cg, alphahat_cg+1, thetahat_cg);
G3 = gamcdf(1+epsilonhat_cg, alphahat_cg, thetahat_cg);
G4 = gamcdf(epsilonhat_cg, alphahat_cg, thetahat_cg); 
p1 = alphahat_cg*thetahat_cg.*(G1-G2);
p2 = (1+epsilonhat_cg)*(1-G3);  
p3 = epsilonhat_cg*(1-G4);
ey_cg = p1+p2-p3;
%-------------------------------------------------------------------------%