% 2013 Peter Richtarik
% 2017 - modified by Andreas Grothey

function [J, mu, cluster,c] = Kmeans1(data,sample,k,NIter)

% Hand coded k-means clustering algorithm

% INPUT: 
% data = m-by-n data matrix containing m data points in R^n
% k = number of clusters

% OUTPUT:
% J = m-by-1 vector containing numbers {1,2,...,k} with the following
%     meaning: data point data(i,:) belongs to cluster J(i)
% mu = k-by-n matrix containing k cluster centres in the rows
% c = k-by-1 vector containing the sizes of the clusters; i.e., c(1) is the
% number of points in cluster 1 and so on

m = size(data,1);

if k > m 
    disp('You requested more clusters than there are data points');
    J = []; mu = []; c = [];
    return;   % This is the statement that exits the function
end    

% if # points = # clusters, put each point into its own cluster
if k == m
    J = 1:k; J = J'; mu = J; c = ones(k,1);
    return;    
end   

% ------------------------- main Algorithm --------------------------
% -------------   continue only if # points > # clusters ---------------

% randomly pick k numbers out of {1,..., m}
%rnd_idx = randsample(m,k); 

% NOTE: if Matlab doesn't have randsample, use RandomSubset.m instead
%rnd_idx = RandomSubset(m,k); 

% and use those entries in the data matrix as the initial cluster centers
mu = sample; 

c = ones(k,1);

for l = 1:NIter % iterate k means NIter times
    
    % STEP 3.1: assign each point to closest mean
    for i=1:m % cycle through points
        J(i) = 1; % initially assign point i into cluster 1
        min = norm(data(i,:) - mu(1,:)); % distance of point i from centre of cluster 1
        for j=2:k % cycle through means / cluster centres
            r = norm(data(i,:) - mu(j,:)); % compute distance of point i from j-th centre
            if r < min % if i-th point is closer j-th centre to than all previous centres...
                J(i) = j; % ...assign it to the cluster defined by centre j                
                min = r; % new closest distance is r
            end    
        end        
    end    
    
    % STEP 3.2: generate new means as centers of the new clusters
    for j=1:k
        I = find(J==j); % find indices of all points belonging to cluster j
        c(j) = length(I);
        if c(j)==0
            % do nothing, i.e., keep mu(j,:)
            disp('Empty cluster!')
        else
            % average all points belonging to cluster j
            X = data(I',:); 
            cluster(j).in = X;
            if size(X,1) > 1
                mu(j,:) = sum(X)/c(j); % average of all points belonging to cluster j
            else % X contains a single row only
                mu(j,:) = X;
            end
        end    
    end    
    
end
