function [cost,dcost] = RecCost(Info,x,r)
% This function calculate gradient of given decision
  % Inputs
  % - Info: Basic information
  %    o Info.retm: All scenarios
  %    o Info.B: Budget 
  %    o Info.L: Liability 
  % - x: Given decision 
  % - r: Selected scenarios
  % Outputs
  % - dcost: The gradient

% calculate the value of shortfall and gradient wrt x(1)...x(8)
sfl = Info.L - Info.B*r*x;
dcost = -r';
% make changes if the '0'-branch of the max is active.
if (sfl<0)
   dcost = 0;
end 
cost = sfl;

