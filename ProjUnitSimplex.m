function xp = ProjUnitSimplex(x)
% This function finds the projection of a given vector x onto the unit simplex:
% {x: sum_i x_i = 1, x_i>=0 }
%
% It uses the method as described here
% https://eng.ucmerced.edu/people/wwang5/papers/SimplexProj.pdf
%
    
u = x;
n = length(x);

% sort entries of x in decreasing order
us = sort(u,'descend');

% calculate a vector of partial sums psu(j) = sum_{i=1..j} us(i)
J = tril(ones(n));
psu = J*us;

% set rho = max {1<=j<=n: us(j) + 1/j*(1-psu(j))>0}
rho = max(find(us + (1./(1:n)').*(1-psu)>0));
%set lam = 1/rho*(1-psu(rho));
lam = 1/rho*(1-psu(rho));

% set xp = max{x+lam, 0} (componentwise)
xp = max(x+lam, 0);
