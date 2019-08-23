clc,clear;
S = 10; NTest = 3; % Number of selected scenarios
%% 
load retm;
data = retm(:,1:2);
r = 0;
%%
u = 100000; 
a = [ rand(u,1),rand(u,1)];
data = a;
r = 1;
%%
subplot(2,2,1); 
scatter(data(:,1),data(:,2),1,'blue','filled');
if r == 0
    xlabel('Return of Dow-Jones');
    ylabel('Return of FTSE');
    title('100000 Scenarios of Dow-Jones & FTSE');
else
    xlabel('Return of Asset 1');
    ylabel('Return of Asset 2');
    title('100000 Uniform Random Scenarios');
    axis([-0.1 1.1 -0.1 1.1]);
end


col = linspace(-10,10,S);
for j = 1:NTest
    [J, mu,cluster,size,rnd_idx] = Kmeans(data,S,1);
    subplot(2,2,1+j); 
    sigma = data(rnd_idx,:);
    scatter(data(:,1),data(:,2),1,'blue','filled');
    hold on;
    for i = 1:S
        scatter(cluster(i).in(:,1),cluster(i).in(:,2),1,ones(size(i),1)*col(i),'filled');
    end
    if r == 0
        xlabel('Return of Dow-Jones');
        ylabel('Return of FTSE');
    else
        xlabel('Return of Asset 1');
        ylabel('Return of Asset 2');
        axis([-0.1 1.1 -0.1 1.1]);
    end
    title(['Cluster Test ',num2str(j)]);
    plot(mu(:,1)',mu(:,2)','+black','MarkerSize',3); 
    plot(sigma(:,1)',sigma(:,2)','oblack','MarkerSize',3); 
    hold off;
end