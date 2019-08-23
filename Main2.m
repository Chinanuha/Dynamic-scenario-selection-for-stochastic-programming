clc,clear;
S = 10; % Number of selected scenarios
load retm;
Info.retm = retm; Info.B = 10000; Info.L = 10100; % Budget B and liability L
IS.NIter = 1; IS.NTest = 1;
AS.NIter = 2; AS.NTest = 2;
KM.NIter = 2; KM.NTest = 2;
IRM.NIter = 1;IRM.NTest =1;
SGM.NIter = 1;SGM.NTest =100;
alpha = 0.90; b = 1.1; delta_b = 0.5;

% [SGM.AveMin,SGM.StdMin,SGM.MinOut,SGM.t_Algo,SGM.t_cvxin,SGM.t_cvxout] = StatIRM(Info,SGM.NIter,SGM.NTest);

 % [IS.AveMin,IS.StdMin,IS.MinOut,IS.t_Algo,IS.t_cvxin,IS.t_cvxout] = StatIS(Info,S,IS.NIter,IS.NTest);
% [AS.AveMin,AS.StdMin,AS.MinOut,AS.t_Algo,AS.t_cvxin,AS.t_cvxout,t_RRF] = StatAS(Info,S,AS.NIter,AS.NTest);
% [KM.AveMin,KM.StdMin,KM.MinOut,KM.t_Algo,KM.t_cvxin,KM.t_cvxout] = StatKM(Info,S,KM.NIter,KM.NTest);
[IRM.AveMin,IRM.StdMin,IRM.MinOut,IRM.t_Algo,IRM.t_cvxin,IRM.t_cvxout] = StatIRM(Info,alpha,b,delta_b,IRM.NIter,IRM.NTest);
%[opt_x,Func_Time,cvx_Time] = IterRec(Info,alpha,b,delta_b);