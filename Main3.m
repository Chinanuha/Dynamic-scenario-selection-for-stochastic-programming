clc,clear;
S = 10; % Number of selected scenarios
load retm;
Info.retm = retm; Info.B = 10000; Info.L = 10100; % Budget B and liability L
% Info.retm = retm(:,1:2) ;

%% Direct CVX
p = 0;
[x,cvx_Time,ff] = SP(Info,Info.retm,p);
C = Info.L-Info.B*Info.retm*x ; % Calculate shortfall for every scenarios under portfolio x
index=find(C>=(10^-12));
%% New Algo test
%ylabel('Probability of each scenario');
%eee = sum(ismember(tab(:,1),index));
NIter_RRF = 300;
NAsset = size(Info.retm,2);
tic;
[R,FuncTime,tempp] = RiskRegionFinder(Info,NIter_RRF);
toc
a = Info.retm(R,:);
%scatter3(a(:,1),a(:,2),a(:,3),1,'red')
plot(a(:,1),a(:,2),'.red', 'MarkerSize',1);
hold on;
b = Info.retm;
b(R,:) = [];
%scatter3(b(:,1),b(:,2),b(:,3),1,'yellow')
plot(b(:,1),b(:,2),'.yellow', 'MarkerSize',1);
d = Info.retm(index,:);
%scatter3(d(:,1),d(:,2),d(:,3),1,'cyan')
plot(d(:,1),d(:,2),'.cyan', 'MarkerSize',1);
eps =10^-12;
tempp(1) = tempp(1) + eps;
tab = sortrows(tabulate(tempp),2,'descend');
tab(:,3) = [];
%plot(1:size(tab,1),tab(:,2));
% axis([1 100000 0 1.2*NIter_RRF]);
NP1 = find(tab(:,2) < NIter_RRF,1, 'first'); % Number of scenarios with Prob 1
tab(NP1:end,:) = [];
c = Info.retm(floor(tab(:,1)),:);
plot(c(:,1),c(:,2),1,'green')

tabb = tabulate(tempp);
tabb(1,:) = [];% 第一行是多余的
cdata = zeros(size(tabb,1),3);
cdata(:,1) = 1*tabb(:,2)/300;
cdata(:,2) = 1-1*tabb(:,2)/300; 
cdata(:,3) = 1-1*tabb(:,2)/300; 
col = linspace(-10,10,size(c,1));
scatter(a(:,1),a(:,2),1,cdata);



m=size(tabb,1); 
B1=300*0.2*ones(m,1);
B2=300*0.5*ones(m,1);
B3 = ones(m,1);
t = tabb(:,2);
C=find(B3==(t<B2&t>B1));
scatter(a(C,1),a(C,2),1,'g');



% [J, mu,cluster,cc] = Kmeans(c, NAsset,10);
% 
% for i =1:NAsset
%     temp = cluster(i).in;
%     [~,MAX(i)] = max(sum(temp.^2,2));
%     D(i,:) = temp(MAX(i),:);
% end
% % scatter3(cluster(1).in(:,1),cluster(1).in(:,2),cluster(1).in(:,3),1,'black')
% plot(cluster(1).in(:,1),cluster(1).in(:,2),'.magenta', 'MarkerSize',1);
% % scatter3(cluster(2).in(:,1),cluster(2).in(:,2),cluster(2).in(:,3),1,'blue')
% plot(cluster(2).in(:,1),cluster(2).in(:,2),'.black', 'MarkerSize',1);
% plot(D(:,1),D(:,2),'+red', 'MarkerSize',10);
% plot(D(:,1),D(:,2),'-red', 'MarkerSize',10);


% hold off;


% B = D(:,NAsset);
% A = D(:,1:(NAsset-1));
% A = [A,ones(NAsset,1)];
% soln = A\B;
% q = NAsset-1;
% % x(NAsset) = 1/(1-sum(xx(1:q)));
% % x(1:q) = -(xx(1:q))./(1-sum(xx(1:q)));
% Region(NAsset) = soln(NAsset);
% Region(1:q) = -soln(NAsset)./soln(1:q);






% r2 = [0,Region(2)];
% r1 = [(D(1,2) - Region(2))/Region(1),0];
% plot(r1,r2,'-red', 'MarkerSize',20);


%%  test AS



NAssets = size(Info.retm,2);
A1 = rand(1,NAssets);
A2 = sum(A1); 
x = (A1/A2)';
[x,~,~] = SP(Info,r,p);
[s,r,p,Func_Time] = AggrSampling(Info,S,R);




%% Risk scenario size
NAssets = size(Info.retm,2); % Number of assests
N = size(Info.retm,1); % Number of scenarios
eps = 10^-12;
R = []; % Initialize R as empty set
for i = 1:200
    RR = (1:N)'; %  RR is index set for all scenarios
    A1 = rand(1,NAssets);
    A2 = sum(A1); 
    x = (A1/A2)';
    C = Info.L-Info.B*Info.retm*x ; % Calculate shortfall for every scenarios under portfolio x
    logi =  C >= 0; % Judege whether shortfall is higher than quantile
    temp = logi.*RR;
    temp(temp==0)=[]; % Index of scenarios which is higher that quantile
    R = union(R,temp); % Combine Risk Region R every literation
    A(i) = size(R,1);
end



plot(1:i,A);
ylabel('Number of risk scenarios');
xlabel('Number of Iterations');


%% New Algo test
[x,cvx_Time,ff] = SP(Info,Info.retm(6:7,:),0);
for i = 1:3
    [IS.s,IS.r,IS.p] = ImpSampling(Info,S);
    r_new = InterChge(Info,S,IS.r,IS.p);
    r_old = IS.r;
    p_old =IS.p;
    p_new = 0;
    [Sf_Old(i), Sf_New(i)] = Perform(Info,r_old,p_old,r_new,p_new);
end

plot(1:i,Sf_Old,1:i,Sf_New);
legend('Old 10 scenarios (From IS)','New 10 scenarios','Location','northeast')
ylabel('Out-of-sample Expected Shortfall');
xlabel('Number of Tests');
%%  Shortfall Distribution

for i = 1:1000
    A1 = rand(1,8);
    A2 = sum(A1); 
    x = (A1/A2)';
    C = Info.L-Info.B*Info.retm*x;
    D = sort(C);
    plot(1:100000,D);
    hold on
end
yline(0,'linestyle','--','Color','r');
axis([1 100000 -1500 2000]);
xlabel('Serial Numbers of Scenarios');
ylabel('Shortfall');
hold off
%% RIS Test
RIS.RFFNIter = 200;
RIS.NIter = 60;
RIS.NTest = 1;
IS.NIter = 60;
IS.NTest = 1;
[RIS.AveMin,RIS.StdMin,RIS.MinOut,RIS.t_Algo,RIS.t_cvxin,RIS.t_cvxout] = StatRIS(Info,S,RIS.RFFNIter,RIS.NIter,RIS.NTest);
[IS.AveMin,IS.StdMin,IS.MinOut,IS.t_Algo,IS.t_cvxin,IS.t_cvxout] = StatIS(Info,S,IS.NIter,IS.NTest);





