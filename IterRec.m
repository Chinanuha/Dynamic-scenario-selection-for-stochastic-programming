    function [opt_x,Func_Time,cvx_Time] = IterRec(Info,alpha,b,delta_b)
% This function get a optimal decision opt_x using iterative reduction method
  % Inputs
  % - Info: Basic information
  %    o retm: All scenarios
  %    o B: Budget 
  %    o L: Liability 
  % Outputs
  % - opt_x£º Optimal decision
 
t1 = clock;
CL = inf;
NAssets = size(Info.retm,2); % Number of assests
N = size(Info.retm,1); % Number of scenarios 
p = 1/N; % Probabilities of each scenarios
NIter = 0; % Number of Iterations

while 1
    % =========== Sequential procedure ===========
    NIter = NIter +1;
    N_AS = ceil(b*(1-alpha)/p); % Minimum cardinality
    if NIter == 1
        r = Info.retm(randperm(N, N_AS),:);
    else
        r = Info.retm(allindex((N - N_AS + 1):N,:),:); % Update the subset of active scenarios
    end

    cvx_Time = 0;
    t3 = clock;
    cvx_begin;
      variables x(NAssets);
      variables sfl(N_AS);
      
      minimize sum(sfl)/N_AS;
      subject to
       Info.B*r*x + sfl >= Info.L;
       sum(x) == 1;
       x>= 0;
       sfl>= 0;
    cvx_end
    
    t4 = clock;
    cvx_Time = cvx_Time + etime(t4,t3);
    
    
    z =sort(Info.L - Info.B*r*x); % Ordered losses from subset
    [~,index]=sort(abs(z));
    i_alpha = index(1);
    i_beta = N_AS - i_alpha + 1;
    [z_apo,allindex] = sort(Info.L - Info.B*Info.retm*x); % Ordered losses from set N
    [~,index]=sort(abs(z_apo)); 
    i_alpha_apo = index(1); % Index position of z^(v)_i_alpha^(v)
    i_beta_apo = N - i_alpha_apo + 1;
    if i_beta == i_beta_apo
        opt_x = x;
        break
    else
        if p*i_beta_apo < CL
            CL = p*i_beta_apo;
        else
            b = b + delta_b;
        end
    end
end
t2 = clock;
Func_Time = etime(t2,t1);