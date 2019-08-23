function [R_new,pi_new,NIter,functime,cvxtime,SumCri1,SumCri2] = AdaModAlgo2(Info,S,NIter_RRF,N_interval,R_old,pi_old)

t1 = clock;
% Initialize
cvxt1 = clock;
N = size(Info.retm,1);
J = size(Info.retm,2);
R_index = (1:N)'; 
NIter = 0;
cvxtime = 0;
err = zeros(S,J);

cvxt1 = clock;
[x,~,~] = SP(Info,R_old,pi_old);
cvxt2 = clock;
cvxtime = cvxtime + etime(cvxt2,cvxt1);
sf = max(Info.L-Info.B*Info.retm*x,0) ; % Calculate shortfall for every scenarios under portfolio x
MIN = mean(sf);

% Find RR & NR
    
[RR,DR,NR,WR,~] = RiskRegion(Info,NIter_RRF);

while 1
    % Find CR & CNR
    logi =  sf > 0; % Judege whether shortfall is higher than quantile
    CR = logi.*R_index;
    CR(CR==0)=[]; % Index of scenarios which is higher that quantile
    CNR = setdiff(R_index,CR);
    
    

    % Scenario Detecting & Resampling
    for i = 1:S
        [lia,locb] = ismember(R_old(i,:),Info.retm, 'rows');
        if lia == 1
            pos(i) = locb;
        else
            distance = zeros(N,1);
            for j = 1:N
                distance(j) = norm(Info.retm(j,:) - R_old(i,:)); 
            end
            [~,pos(i)]=min(distance);        
        end
        if ismember(pos(i),CR)
           R_old(i,:) = Info.retm(pos(i),:);
        end
        if ismember(pos(i),NR) 
           R_old(i,:) = Info.retm(CR(randi([1,size(CR,1)],1,1)),:);
        end
        if ismember(pos(i),intersect(WR,CNR))
           WR_CR = intersect(WR,CR);
           R_old(i,:) = Info.retm(WR_CR(randi([1,size(WR_CR,1)],1,1)),:);
        end
    end

    % Assigning Probabilities
    sf_old = Info.L-Info.B*R_old*x ;
    Interval = linspace(0,max(sf),N_interval+1);
    n_interval = zeros(N_interval,1);
    for k = 1:N_interval
        D(k) = size(find(  sf > Interval(k) &  sf <= Interval(k+1) ),1);
        n_interval(k) = size(find(  sf_old > Interval(k) &  sf_old <= Interval(k+1) ),1);
    end
    
    W = max(sf)/N_interval;
    for i = 1:S
        for k = 1:N_interval
            if sf_old(i) > (k-1)*W && sf_old(i) <= k*W
               pi_old(i) = (D(k)/N)/n_interval(k);
            end  
        end
    end
    
%     if err == R_old
%         R_new = zeros(S,J);
%         pi_new = zeros(1,S);
%         NIter = 0;
%         functime = 0;
%         cvxtime = 0;
%         SumCri1 = 0;
%         SumCri2 = 0;
%         break
%     end
%     
%     err = R_old;
    
    NIter = NIter + 1;
    % Convergency Issue
    cvxt3 = clock;
    [x,~,~] = SP(Info,R_old,pi_old);
    cvxt4 = clock;
    cvxtime = cvxtime + etime(cvxt4,cvxt3);
    sf = max(Info.L-Info.B*Info.retm*x,0);
    CL(NIter) = nnz(sf)/N;
    if mean(sf) <= MIN +10^(-9)
        Cri1(NIter) = 1;
    else
        Cri1(NIter) = 0;
    end
    if CL(NIter) > size(DR,1)/N + (size(WR,1)/N)/4 && CL(NIter) < size(DR,1)/N + 3*(size(WR,1)/N)/4
        Cri2(NIter) = 1;
    else
        Cri2(NIter) = 0;
    end
    if   Cri1(NIter) ==  1 && Cri2(NIter) ==  1
        break
    end
    
end



SumCri1 = sum(Cri1);
SumCri2 = sum(Cri2);
R_new = R_old;
pi_new = pi_old;
t2 = clock;
functime = etime(t2,t1);






