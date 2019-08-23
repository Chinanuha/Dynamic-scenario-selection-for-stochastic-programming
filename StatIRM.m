function [AveMin,StdMin,MinOut,t_Algo,t_cvxin,t_cvxout] = StatIRM(Info,alpha,b,delta_b,NIter,NTest)

for i = 1:NTest
    t1 = clock;
    for j = 1:NIter
        [x,~,cvx_TimeIn(j)] = IterRec(Info,alpha,b,delta_b);
        [~,Out(j)] = SflCal(Info,Info.retm,x);
    end
    t_cvxin(i) = sum(cvx_TimeIn);
    t_cvxout(i) = 0;
    MinOut(i) = min(Out);
    t2 = clock;
    t_Algo(i) = etime(t2,t1);
end
AveMin = mean(MinOut);
StdMin = std(MinOut);
