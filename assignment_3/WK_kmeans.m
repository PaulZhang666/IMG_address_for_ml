function [estimatedLabels, estimatedMeans, MSE] = WK_kmeans(inputData, numberOfClusters, stopTolerance, numberOfRuns)
% Runs k-means
% Inputs:
%       inputData (Nxd)             - matrix with data
%       params 
%           .numberOfClusters       - number of clusters
%           .stopTolerance          - abs difference between means for
%                                     stopping criteria
%           .nRuns                  - number of random initializations
% 
% Outputs
%       estimatedLabels (Nx1)       - label based on closest mean
%       estimatedMeans (kxd)        - mean estimates
%       vectorMSE (1xnIter)         - MSE as a function of iteration number
[nSample, dim] = size(inputData);
estimatedLabels = -1*ones(nSample,1);
for i = 1:numberOfRuns
    MSE = 0;
    %initialization
        for k = 1:numberOfClusters
            tempData = inputData;
            ran = randi(nSample-k+1);
            estimatedMeans(k, :) = tempData(ran, :);
            n = 1:nSample;
            tempData = tempData(n~=ran,:);
        end
    
% %     kmeans++ initialization
%     estimatedMeans(1,:) = inputData(randi(nSample),:);
%     for k = 2:numberOfClusters
%         for n = 1:nSample
%             for l = 1:size(estimatedMeans,1)
%                 tempDistIni(l) = sum((estimatedMeans(l,:) - inputData(n,:)).^2);
%             end
%             distIni(n) = max(tempDistIni);
%         end
%         distIni = distIni / sum(distIni);
%         ran = mnrnd(1,distIni);
%         estimatedMeans(k,:) = inputData(ran == 1,:);
%     end
    
    %kmeans loop starts here
    lastMeans = estimatedMeans;
    tol = sum(sum(lastMeans.^2));
    numIter = 0;
    while(tol > stopTolerance)
        numIter = numIter + 1;
        for n = 1:nSample
            for k = 1:numberOfClusters
                tempDist(k) = sum((inputData(n,:) - estimatedMeans(k,:)).^2);
            end
            estimatedLabels(n) = find(tempDist == min(tempDist));
        end
        for k = 1:numberOfClusters
            estimatedMeans(k, :) = mean(inputData(estimatedLabels == k,:),1);
        end
        tol = 0;
        for k = 1:numberOfClusters
            tol = tol + sqrt(sum((lastMeans(k,:) - estimatedMeans(k,:)).^2));
        end
        lastMeans = estimatedMeans;
        errorSum = 0;
        for n = 1:nSample
            errorSum = errorSum + sum((inputData(n,:) - estimatedMeans(estimatedLabels(n),:)).^2);
        end
        MSE(numIter) = errorSum;
    end
    MSEs{i} = MSE';
end
%select the minimum MSE as the output MSE
MSE = MSEs{1};
for i = 2:length(MSEs)
    if MSEs{i}(end) < MSE(end)
        MSE = MSEs{i};
    end
end