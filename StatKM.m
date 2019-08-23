function [AveMin,StdMin,MinOut,t_Algo,t_cvxin,t_cvxout] = StatKM(Info,S,NIter,NTest)

for i = 1:NTest
    t1 = clock;
    for j = 1:NIter
        [~, mu, c] = Kmeans(Info.retm,S);
        p = c'/sum(c);
        r = mu;
        [x,cvx_TimeOut(j)] = SP(Info,r,p);
        [~,Out(j)] = SflCal(Info,Info.retm,x);   
    end
    t_cvxin(i) = 0;
    t_cvxout(i) = sum(cvx_TimeOut);
    MinOut(i) = min(Out);
    t2 = clock;
    t_Algo(i) = etime(t2,t1);
end
AveMin = mean(MinOut);
StdMin = std(MinOut);
