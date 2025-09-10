function [] = plotData()

green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
colors = [purple;green;purple;green];
ms=30;
lw=3;

[tData,xData,stdData] = getData();


%% plot n(t)
figure(1); 
subplot(211);
for i = 1:2
%     plot(tData,xData(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
    errorbar(tData,xData(:,i),stdData(:,i),'.','MarkerSize',ms,'LineWidth',lw,'Color',colors(i,:)); hold on;
end
clean();
% h=ylabel('$\bar{v}(t)$');set(h,'Interpreter','Latex');
ylim([0 1.5]);
xlim([0 12]);
% resizeHeight(1.8);

subplot(212); 
for i = 3:4
%     plot(tData,xData(:,i),'-','LineWidth',lw,'Color',colors(i,:));hold on;
    errorbar(tData,xData(:,i),stdData(:,i),'.','MarkerSize',ms,'LineWidth',lw,'Color',colors(i,:)); hold on;
end

clean();
% h=ylabel('$\bar{v}(t)$');set(h,'Interpreter','Latex');
ylim([0 1.5]);
xlabel('time, t');
% resizeHeight(1.8);



end