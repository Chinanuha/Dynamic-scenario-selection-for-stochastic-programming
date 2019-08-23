function [s,r,p,Func_Time] = AggrSampling(Info,S,R)
% This function get a optimal decision opt_x using importance sampling
  % Return (S - 1) risk scenarios and 1 'non-risk' scenarios.
  % Inputs
  % - Info: Basic information
  %    o Info.Info.retm: All scenarios
  %    o Info.B: Budget 
  %    o Info.Info.L: Liability
  % - S: Number of selected scenarios
  % - R: Risk scenarios
  % Outputs
  % - s: Index of sample scenarios
  % - r: Selected scenarios
  % - w: Weights of selected scenarios
    t1 = clock;
    N = size(Info.retm,1); % Number of scenarios
    N_R = S - 1;
    % =========== Step 3: Aggregation sampling ===========
    n_R = 0;n_Rc = 0; y_Rc = 0;s = zeros(S,1);
    while n_R < N_R
        y_new = randi([1,N],1,1);
        if ismember(y_new,R) == 1
            n_R = n_R + 1;
            y(n_R,:) = Info.retm(y_new,:);
            s(n_R) = y_new;
        else
            n_Rc = n_Rc + 1;
            y_Rc = y_Rc + Info.retm(y_new,:); 
        end
    end
    for i = 1:N_R
        p(i) = 1/(n_Rc + N_R);
    end
    if n_Rc > 0 + eps
       y(N_R+1,:) = y_Rc/n_Rc; 
       s(N_R+1) = 0;
    else
        y_new = randi([1,N],1,1);
        n_Rc = 1;
        y(N_R+1,:) = Info.retm(y_new,:);
        s(N_R+1) = y_new;
    end
    p(N_R+1) = n_Rc/(n_Rc+N_R);
    r = y;
    t2 = clock;
    Func_Time = etime(t2,t1);
