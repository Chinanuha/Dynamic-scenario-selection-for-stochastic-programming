
clc,clear;
S = 10; % Number of selected scenarios
load retm;
Info.retm = retm; Info.B = 10000; Info.L = 10100; % Budget B and liability L
%%
NIter_RRF = 300;
N_interval = 50;
NTest = 10;


for i = 1:NTest
[RR,~,~] = RiskRegionFinder(Info,NIter_RRF);
[~,R_old,pi_old,~] = AggrSampling(Info,S,RR);
[R_new,pi_new,AS.NIter(i),AS.functime(i),AS.cvxtime(i),AS.SumCri1(i),AS.SumCri2(i)] = AdaModAlgo(Info,S,NIter_RRF,N_interval,R_old,pi_old);
[ExpIn_new,AS.ExpOut_new(i)] = SflCalProb(Info,R_new,pi_new);
[ExpIn_old,AS.ExpOut_old(i)] = SflCalProb(Info,R_old,pi_old);
AS.Improve(i) = AS.ExpOut_old(i) - AS.ExpOut_new(i);
end

for i = 1:NTest
[~,R_old,pi_old,~,~] = ImpSampling(Info,S);
[R_new,pi_new,IS.NIter(i),IS.functime(i),IS.cvxtime(i),IS.SumCri1(i),IS.SumCri2(i)] = AdaModAlgo(Info,S,NIter_RRF,N_interval,R_old,pi_old);
[ExpIn_new,IS.ExpOut_new(i)] = SflCalProb(Info,R_new,pi_new);
[ExpIn_old,IS.ExpOut_old(i)] = SflCalProb(Info,R_old,pi_old);
IS.Improve(i) = IS.ExpOut_old(i) - IS.ExpOut_new(i);
end

for i = 1:NTest
[~,R_old,pi_old,~,~] = ImpSampling(Info,S);
[R_new,pi_new,DS.NIter(i),DS.functime(i),DS.cvxtime(i),DS.SumCri1(i),DS.SumCri2(i)] = AdaModAlgo(Info,S,NIter_RRF,N_interval,R_old,pi_old);
[ExpIn_new,DS.ExpOut_new(i)] = SflCalProb(Info,R_new,pi_new);
[ExpIn_old,DS.ExpOut_old(i)] = SflCalProb(Info,R_old,pi_old);
DS.Improve(i) = DS.ExpOut_old(i) - DS.ExpOut_new(i);
end

for i = 1:NTest
[~, R_old, ~,c,~] = Kmeans(Info.retm,S,1);
pi_old = (c/size(Info.retm,1))';
[R_new,pi_new,KM.NIter(i),KM.functime(i),KM.cvxtime(i),KM.SumCri1(i),KM.SumCri2(i)] = AdaModAlgo(Info,S,NIter_RRF,N_interval,R_old,pi_old);
[ExpIn_new,KM.ExpOut_new(i)] = SflCalProb(Info,R_new,pi_new);
[ExpIn_old,KM.ExpOut_old(i)] = SflCalProb(Info,R_old,pi_old);
KM.Improve(i) = KM.ExpOut_old(i) - KM.ExpOut_new(i);
end   

for i = 1:NTest
R1 = randperm(size(Info.retm,1),S); % R1 is random index set of assets
R_old = Info.retm(R1,:);
pi_old = 0;
[R_new,pi_new,RS.NIter(i),RS.functime(i),RS.cvxtime(i),RS.SumCri1(i),RS.SumCri2(i)] = AdaModAlgo(Info,S,NIter_RRF,N_interval,R_old,pi_old);
[ExpIn_new,RS.ExpOut_new(i)] = SflCalProb(Info,R_new,pi_new);
[ExpIn_old,RS.ExpOut_old(i)] = SflCalProb(Info,R_old,pi_old);
RS.Improve(i) = RS.ExpOut_old(i) - RS.ExpOut_new(i);
end

%%
% st = zeros(7,8);
% for j = 1:4
%     if j==1
%         NIter = KM.NIter;
%         functime = KM.functime;
%         cvxtime = KM.cvxtime;
%         Improve = KM.Improve;
%         Improveper = KM.Improve./KM.ExpOut_old;
%         SumCri1 = KM.SumCri1;
%         SumCri2 = KM.SumCri2;
%     end
%     st(1,j)
%     
% end
% 
% statistics = d;
mean(IS.NIter)
std(IS.NIter)
mean(IS.functime)
std(IS.functime)
mean(IS.cvxtime)
std(IS.cvxtime)
mean(IS.Improve)
std(IS.Improve)
mean(IS.Improve./IS.ExpOut_old)
std(IS.Improve./IS.ExpOut_old)
mean(IS.SumCri1)
std(IS.SumCri1)
mean(IS.SumCri2)
std(IS.SumCri2)

IS.NIter(c)=[];
IS.functime(c)=[];
IS.cvxtime(c)=[];
IS.Improve(c)=[];
IS.SumCri1(c)=[];
IS.SumCri2(c)=[];

IS.NIter(47:50) = DS.NIter(1:4); 
IS.functime(47:50)=DS.functime(1:4);
IS.cvxtime(47:50)=DS.cvxtime(1:4);
IS.Improve(47:50)=DS.Improve(1:4);
IS.SumCri1(47:50)=DS.SumCri1(1:4);
IS.ExpOut_new(47:50)=DS.ExpOut_new(1:4);
IS.ExpOut_old(47:50)=DS.ExpOut_old(1:4);
%%
% [f, x] = ksdensity(KM.NIter);
% g = zeros(1,size(f,2));
% g(1) = f(1);
% for j = 2:size(f,2)
%     g(j) = g(j-1) + f(j);
% end
% plot(x, g)
subplot(2,2,1)
yyaxis left
[f, x] = ksdensity(AS.NIter);
plot(x,f)
legend('PDF')
yyaxis right
histogram(AS.NIter,50)
legend('Histogram')
xlabel('Number of iteration')
subplot(2,2,2)
yyaxis left
[f, x] = ksdensity(KM.NIter);
plot(x,f)
legend('PDF')
yyaxis right
histogram(KM.NIter,50)
legend('Histogram')
xlabel('Number of iteration')
subplot(2,2,3)
yyaxis left
[f, x] = ksdensity(IS.NIter);
plot(x,f)
legend('PDF')
yyaxis right
histogram(IS.NIter,50)
legend('Histogram')
xlabel('Number of iteration')
subplot(2,2,4)
yyaxis left
[f, x] = ksdensity(RS.NIter);
plot(x,f)
legend('PDF')
yyaxis right
histogram(RS.NIter,50)
legend('Histogram')
xlabel('Number of iteration')
hold on
axis([0 100 0 0.02]);

data=KM.NIter;

[y,x]=hist(data,100);         %分为100个区间统计，(你可以改你需要的区间数)

y=y/length(data)/mean(diff(x));   %计算概率密度 ，频数除以数据种数，除以组距

bar(x,y,1);                      %用bar画图，最后的1是画bar图每条bar的宽度，默认是0.8所以不连续，


subplot(2,2,1)
histogram(AS.NIter,50)
ylabel("Frequency")
xlabel('Number of iteration')
legend('Input from AS')
subplot(2,2,2)
histogram(KM.NIter,50)
ylabel("Frequency")
xlabel('Number of iteration')
legend('Input from KM')
subplot(2,2,3)
histogram(IS.NIter,50)
ylabel("Frequency")
xlabel('Number of iteration')
legend('Input from IS')
subplot(2,2,4)
histogram(RS.NIter,50)
ylabel("Frequency")
xlabel('Number of iteration')
legend('Input from RS')
%%

nu = 0;
As = Info.retm(:,1:2);
As = sortrows(As,1);
As1 = As(:,1);
As2=As(:,2);
for i = 1:100:100000
   nu = nu+1;
   corm = corrcoef(As1(i:(i+99)),As2(i:(i+99))); 
   cor(nu) = corm(2);
end
plot(1:100:100000,cor)
