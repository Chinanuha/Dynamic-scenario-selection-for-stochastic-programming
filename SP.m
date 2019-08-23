function [x,cvx_Time,ff] = SP(Info,r,p)
% This function is to solve stochastic program using CVX
  % Inputs
  % - Info: Basic information
  %    o Info.retm: All scenarios
  %    o Info.B: Budget 
  %    o Info.L: Liability 
  % - S: Number of scenarios 
  % - r: Selected scenarios
  % - w: A 1*S matrix or 0
  % Outputs
  % - x: Optimal decision

S = size(r,1);
t1 = clock;
NAssets = size(Info.retm,2); % Number of assests
if p == 0
    cvx_begin
        variable x(NAssets); % initial investment decision
        variable sfl(S); % sfl(s) measures the shortfall in scenario s
        minimize sum(sfl)/S;
        subject to
        Info.B*r*x + sfl >= Info.L;
        sum(x) == 1;
        x >= 0;
        sfl >= 0;
    cvx_end
else       
    cvx_begin
        variable x(NAssets); % initial investment decision
        variable sfl(S); % sfl(s) measures the shortfall in scenario s
        minimize p*sfl;
        subject to
        for s=1:S
            Info.B*r*x + sfl(s) >= Info.L;
        end
        sum(x) == 1;
        x >= 0;
        sfl >= 0;
    cvx_end
end
t2 = clock;
cvx_Time = etime(t2,t1);
ff = cvx_optval;

