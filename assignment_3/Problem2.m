clear all;close all;
load('dataset2.mat');
[elabels, emeans, MSE] = WK_kmeans(data, 3, 1e-8, 20);
figure;
subplot(131);
hold on;
plot(data(labels == 0,1),data(labels == 0,2),'rx');
plot(data(labels == 1,1),data(labels == 1,2),'bx');
plot(data(labels == 2,1),data(labels == 2,2),'gx');
legend('class 0','class 1','class 2');
title('true clustering');
hold off;
elabels = elabels -1;

subplot(132);
hold on;
plot(data(elabels == 0,1),data(elabels == 0,2),'rx');
plot(emeans(1,1),emeans(1,2),'go');
plot(data(elabels == 1,1),data(elabels == 1,2),'bx');
plot(emeans(2,1),emeans(2,2),'ro');
plot(data(elabels == 2,1),data(elabels == 2,2),'gx');
plot(emeans(3,1),emeans(3,2),'bo');
legend('class 0','estimated mean of class 0','class 1','estimated mean of class 1','class 2','estimated mean of class 2');
title('estimated clustering');
hold off;

subplot(133);
plot(MSE);
title('MSE');