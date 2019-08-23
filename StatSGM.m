function [AveMin,StdMin,MinOut,t_Algo,t_cvxin,t_cvxout] = StatSGM(Info,NIter,NTest)

for i = 1:NTest
    t1 = clock;
    for j = 1:NIter
        x = StocGrad(Info);
        [~,Out(j)] = SflCal(Info,Info.retm,x);
    end    
    MinOut(i) = min(Out);
    t_cvxin(i) = 0;
    t_cvxout(i) = 0;
    t2=  clock;
    t_Algo(i) = etime(t2,t1);
end
AveMin = mean(MinOut);
StdMin = std(MinOut);