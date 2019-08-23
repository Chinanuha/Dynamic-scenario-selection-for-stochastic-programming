function [R2,r,w,Func_Time,cvx_Time] = ImpSampling(Info,S)
% This function get a optimal decision opt_x using importance sampling
  % Inputs
  % - Info: Basic information
  %    o Info.retm: All scenarios
  %    o Info.B: Budget 
  %    o Info.L: Liability 
  % Outputs
  % - R2: Index of sample scenarios
  % - r: Selected scenarios
  % - w: Weights of selected scenarios
t1 = clock;
NAssets = size(Info.retm,2); % Number of assests
N = size(Info.retm,1); % Number of scenarios
% =========== Step 1: First Sample =>> R1 ==============
R1 = randperm(N,S); % R1 is random index set of assets
r = Info.retm(R1,:);
% =======================================================

% ============== Step 2: Solve SP(R1) =>> x ====================
cvx_Time = 0;
t3 = clock;
cvx_begin
 variable x(NAssets); % initial investment decision
 variable sfl(S); % sfl(s) measures the shortfall in scenario s
 minimize (sum(sfl)/S);
 subject to
for s=1:S
  Info.B*r*x + sfl(s) >= Info.L;
end
 sum(x) == 1;
  x >= 0;
  sfl >= 0;
cvx_end
t4 = clock;
cvx_Time = cvx_Time + etime(t4,t3);
% ==========================================================

% ============== Step 3: Generate "Impotaance wights" =>> w  ====================
C = max(Info.L-Info.B*Info.retm*x,0);
C_bar = mean(max(Info.L-Info.B*Info.retm*x,0));
w = C/(N*C_bar);
% ================================================================================

% =========== Step 4: Resample =>> R2 ===========
R2 = randsample(N,S,true,w); % R2 is random index set of assets, w is "importance weights"
% ==================================================

% =========== Step 3: Calculate Shortfall ===========
w = (w(R2,:))'; %Inverse of C(w)
S = size(R2,1);
r = Info.retm(R2,:);
t2 = clock;
Func_Time = etime(t2,t1);