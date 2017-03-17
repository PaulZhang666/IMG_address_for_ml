% Problem1

clear all;
close all;
load('datasetP2Train2.mat');
load('datasetP2Test.mat');
nTest = size(dataTest, 1);

nSamples = size(data, 1);
K = length(unique(classIndex)) ;
prior = ones(1,K)/K;
alphaV = linspace(0,1,100);

sampleMean = mean(data, 1);
sampleCov = cov(data);

for idxC = 1:K
	muEstimate{idxC} = mean(data(classIndex==idxC,:));
    sigmaEstimate{idxC} = cov(data(classIndex==idxC,:));
end

for idxA = 1:length(alphaV)
    a = alphaV(idxA);
    for idxC = 1:3
        
        ni = nnz(classIndex==idxC);
        n = nSamples;
        sigmaEstimateInd = cov(data(classIndex==idxC,:));
        sigmaEstimate{idxC} = ((1-a)*ni*sigmaEstimateInd + a*n*sampleCov)/((1-a)*ni + a*n);
    end
    
    [score] = gaussianDiscriminantAnalysis(data, muEstimate, sigmaEstimate, prior);
    [~,estimatedLabel] = max(score,[],2);
    trainingError(idxA) = nnz(estimatedLabel~=classIndex)*100/nSamples;
    
    [score] = gaussianDiscriminantAnalysis(dataTest, muEstimate, sigmaEstimate, prior);
    [~,estimatedLabel] = max(score,[],2);
    testError(idxA) = nnz(estimatedLabel~=classIndexTest)*100/nTest;
end

figure(1)
hold on
plot(alphaV, trainingError, 'b');
plot(alphaV, testError, 'r');
hold off
xlabel('\alpha');
ylabel('Training error %');
legend('training', 'testing')
[~,idxBest] = min(testError);
bestAlpha = alphaV(idxBest);

grid on
title(['Training and testing error for 3.1.d-f. Best alpha = ' num2str(bestAlpha)]);