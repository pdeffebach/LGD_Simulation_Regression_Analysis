function [phat, EY, stats,  std_errors, errors] =  regression_igd(X, Y)


% Performs the IGD regression


%-------------------------------------------------------------------------%
K = size(X, 2);
N = size(X, 1);

eps = 0.000001;     % adjustment value



%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
Ynew = Y;
Ynew(Y<=0) = eps;
Ynew(Y>=1) = 1 - eps;
%-------------------------------------------------------------------------%



%       Calibrate to raw quantities
%-------------------------------------------------------------------------% 
% h = @(Z) (normcdf(Z, 0, 1));        %transformation function (used
% later.) g = h^-1 in the paper. 
g = @(Ynew) (norminv(Ynew, 0, 1));  %inverse transformation function
Z = g(Ynew);                        %inverse tranform function (cont)
%-------------------------------------------------------------------------%



%       OLS Estimators
%-------------------------------------------------------------------------%
betahat = (X'*X)\(X'*Z);            %OLS estimation regessing Z X
if sum(isnan(betahat)) > 0;
    betahat = regress(Z,X);
end
Zhat = X*betahat;
sigma2hat = (Z-Zhat)'*(Z-Zhat)/(N-K); 
phat = [betahat; sigma2hat];
%-------------------------------------------------------------------------%


%       Getting the Standard Errors
%-------------------------------------------------------------------------%
covariance = sigma2hat \ (X'*X);
std_errors  = sqrt(diag(covariance));
%-------------------------------------------------------------------------%


%       Smearing
% We use Duan Smearing in this model. However if we wanted instead to use
% Monte Carlo estimation for EY, we would just need to write a Monte Carlo
% function and put it in this section. However the errors from this
% regression are very much not normally distributed, so MC would probably
% not be appropriate.
%-------------------------------------------------------------------------%
errors = Z-Zhat; % We need to return the errors, because any time we use the expected_igd function it needs to know the errors for the Duan Smearing. 
EY = duan_smearing(X, betahat, errors); 
%-------------------------------------------------------------------------%


% Histograms (Naive, Duan, MC), Performance Metrics, and SSE
%-------------------------------------------------------------------------%
 SSE = sum((Ynew-EY).^2);
%-------------------------------------------------------------------------%


% SST
SST = sum((EY-mean(Ynew)).^2);

optimalR2Duan    = 1 - SSE/SST;


Pearson=corr(EY,Y,'type','Pearson');
Spearman=corr(EY,Y,'type','Spearman');
Kendall=corr(EY,Y,'type','Kendall');



stats = [SSE; SST; optimalR2Duan; Pearson; Kendall; Spearman];








