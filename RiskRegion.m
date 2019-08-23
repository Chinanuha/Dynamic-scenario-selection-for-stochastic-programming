function [R,DR,NR,WR,FuncTime] = RiskRegion(Info,NIter)
% This function get a optimal decision opt_x using importance sampling
  % Inputs
  % - Info: Basic information
  %    o Info.retm: All scenarios
  %    o Info.B: Budget 
  %    o Info.Info.L: Liability
  % - NIter: Number of iterations
  % Outputs
  % - R£º Risk Region
  
  
t1 = clock;  
% ============ Step 1: Find Risk Region R ===========
NAssets = size(Info.retm,2); % Number of assests
N = size(Info.retm,1); % Number of scenarios
eps = 10^-12;
R = []; tempp = [];% Initialize R as empty set
Retm_Index = (1:N)'; %  RR is index set for all scenarios
NSF = zeros(N,1);
for i = 1:NIter
    A1 = rand(1,NAssets);
    A2 = sum(A1); 
    x = (A1/A2)';
    C = Info.L-Info.B*Info.retm*x ; % Calculate shortfall for every scenarios under portfolio x
    logi =  C > 0; % Judege whether shortfall is higher than quantile
    temp = logi.*Retm_Index;
    temp(temp==0)=[]; % Index of scenarios which is higher that quantile
    NSF(temp)=NSF(temp)+1;
    R = union(R,temp); % Combine Risk Region R every literation
end
DR = find(NSF==NIter);
NR = find(NSF==0);
WR = find(NSF<NIter&NSF>0);


% ===============================================================


t2 = clock;
FuncTime = etime(t2,t1);