function [gdp] = GDP(T)


% Simulates the behavior of the US economy from the years 2000 to 2015
% divided into T time periods.

    T2 = T / 2;
    recession = T / 4;
    g = zeros(T, 1);
    for t = 1:1:T
       if t < T2
           g(t) = 2*t/T;
           q = g(t);
       elseif (t >= T2 && t < (T2 + recession));
           g(t) = q - (2 * (t-T2) / (2 * T));
           p = g(t);
       else
           g(t) = p + (2 * (t - (T2 + recession)) / T);
       end
    end

    m = mean(g);
    g = g- m;   % Demeaning so that the gdp is centered around zero. 
    r = normrnd(0, .03, T, 1);  % Random noise to simulate RBC models. 
    
    gdp = r + g;
    
end
