% Information
clc,clear;
S = 10; % Number of selected scenarios
load retm;
Info.retm = retm; Info.B = 10000; Info.L = 10100; % Budget B and liability L
IS.NIter = 20; IS.Gap = 5; 
RIS.NIter = 100; RIS.Gap = 5; 
% AS.NIter = 100; AS.Gap = 5;
% KM.NIter = 100; KM.Gap = 5;
% IRM.NIter = 1; IRM.Gap = 1;


% Importance Sampling
for NTest = 1:1
    IS.xx = [];
for i = 1:IS.NIter
    IS.t1 = clock;
    [IS.s,IS.r,IS.p] = ImpSampling(Info,S);
    [IS.x,~,~] = SP(Info,IS.r,IS.p);
    [IS.In(i),IS.Out(i)] = SflCal(Info,IS.r,IS.x);
    IS.t2 = clock;
    IS.t(i) = etime(IS.t2,IS.t1);
    IS.xx = [IS.xx IS.x];
end
area(IS.xx');


RRFt1= clock;
[Rr,~,~] = RiskRegionFinder(Info,200);
RR = Info.retm(Rr,:);
RRFt2 = clock;
RRFt = etime(RRFt2,RRFt1);
for i = 1:RIS.NIter
    RIS.t1 = clock;
    [~,RIS.r,RIS.p,~,~] = RiskImpSampling(Info,RR,S);
    [RIS.x,~,~] = SP(Info,RIS.r,RIS.p);
    [RIS.In(i),RIS.Out(i)] = SflCal(Info,RIS.r,RIS.x);
    RIS.t2 = clock;
    RIS.t(i) = etime(RIS.t2,RIS.t1);
end






% % Aggregation Sampling
%     NIter_RRF = 200;
%     R = RiskRegionFinder(Info,NIter_RRF);
% for i = 1:AS.NIter
%     AS.t1 = clock;
%     [AS.s,AS.r,AS.p] = AggrSampling(Info,S,R);
%     AS.x = SP(Info,AS.r,AS.p);
%     [AS.In(i),AS.Out(i)] = SflCal(Info,AS.r,AS.x);
%     AS.t2 = clock;
%     AS.t(i) = etime(AS.t2,AS.t1);
% end






% Kmeans
% for i = 1:KM.NIter
%     KM.t1 = clock;
%     [J, mu, c] = Kmeans(retm,S);
%     KM.p = c'/sum(c);
%     KM.r = mu;
%     KM.x = SP(Info,KM.r,KM.p);
%     [KM.In(i),KM.Out(i)] = SflCal(Info,retm,KM.x);
%     KM.t2 = clock;
%     KM.t(i) = etime(KM.t2,KM.t1);
% end

% % Iterative reduction method
% alpha = 0.95; b = 2; delta_b = 0.5;
% for i = 1:IRM.NIter
%     IRM.t1 = clock;
%     [IRM.x,Func_Time,cvx_Time] = IterRec(Info,alpha,b,delta_b);
%     [IRM.In(i),IRM.Out(i)] = SflCal(Info,retm,IRM.x);
%     IRM.t2 = clock;
%     IRM.t(i) = etime(IRM.t2,IRM.t1);
% end






% SGM
% SGM.x = StocGrad(Info);
% [SGM.In,SGM.Out] = SflCal(Info,retm,SGM.x);

% =================Plot============================
subplot(1,2,NTest);
title(['Test ',num2str(NTest)]);
yyaxis left
axis([0,IS.NIter/IS.Gap,140,160]);
SGM.Out = 143.8894;
line([0,IS.NIter/IS.Gap],[SGM.Out,SGM.Out],'linestyle','--','Color','r');
hold on
IS.SflPlot(NTest) = PlotSfl(IS.Out,IS.Gap,'-','none','m');
RIS.SflPlot(NTest) = PlotSfl(RIS.Out,RIS.Gap,'-','none','g');
% AS.SflPlot(NTest) = PlotSfl(AS.Out,AS.Gap,'-','none','g');
% IRM.SflPlot(NTest) = PlotSfl(IRM.Out,IRM.Gap,'-','none','b');
% KM.SflPlot(NTest) = PlotSfl(KM.Out,KM.Gap,'-','none','c');
ylabel('Expected Shortfall (¡ê)')
yyaxis right
axis([0,IS.NIter/IS.Gap,0,60]);
IS.TimePlot(NTest) = PlotTime(IS.t,IS.Gap,'--','none','m',0);
hold on
RIS.TimePlot(NTest) = PlotTime(RIS.t,RIS.Gap,'--','none','g',RRFt);
% AS.TimePlot(NTest) = PlotTime(AS.t,AS.Gap,'--','none','g');
% IRM.TimePlot(NTest) = PlotTime(IRM.t,IRM.Gap,'--','none','b');
% KM.TimePlot(NTest) = PlotTime(KM.t,KM.Gap,'--','none','c');
ylabel('Computational Time (s)');
xlabel(['Number of ',num2str(IS.Gap),' Iterations']);
hold off

end


