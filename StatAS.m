function [AveMin,StdMin,MinOut,t_Algo,t_cvxin,t_cvxout,t_RRF] = StatAS(Info,S,NIter,NTest)

for i = 1:NTest
    t1 = clock;
    for j = 1:NIter
        NIter_RRF = 10;
        [R, RRF_Time(j)] = RiskRegionFinder(Info,NIter_RRF);
        [~,r,p,~] = AggrSampling(Info,S,R);
        [x,cvx_TimeOut(j)] = SP(Info,r,p);
        [~,Out(j)] = SflCal(Info,r,x);
    end 
    t_cvxin(i) = 0;
    t_cvxout(i) = sum(cvx_TimeOut);
    t_RRF(i) = sum(RRF_Time);
    MinOut(i) = min(Out);
    t2= clock;
    t_Algo(i) = etime(t2,t1);
end
AveMin = mean(MinOut);
StdMin = std(MinOut);
