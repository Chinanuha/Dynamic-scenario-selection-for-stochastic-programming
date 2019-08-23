function x = StocGrad(Info)
% This function get a optimal decision opt_x using stochastic gradient method
  % Inputs
  % - Info: Basic information
  %    o retm: All scenarios
  %    o B: Budget 
  %    o L: Liability 
  % Outputs
  % - opt_x£º Optimal decision
  
N = size(Info.retm,1); % Number of scenarios
NAssets = size(Info.retm,2); % Number of assests
x = 1/NAssets*ones(NAssets,1); % Trial decision
for i = 1:N
      r = Info.retm(i,:);
      [~,dc] = RecCost(Info,x,r);
      gamma = 10/i; % update step
      % gamma = 100/i;
      x = x - gamma*dc;
      % project the new point onto the constraint x(1) + x(2) = 1
      x = ProjUnitSimplex(x); 
      %xx = [xx x];
end