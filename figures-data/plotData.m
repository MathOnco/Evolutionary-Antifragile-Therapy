%% plot data points w/ error bars
function [] = plotData(index)

    colors = [purple();red();blue();green()];

%     EE = (1/100)*data(:,1:10)';
%     EU = (1/100)*data(:,13:20)'; % ignore 2 broken ones
%     UE = (1/100)*data(:,21:30)';
%     UU = (1/100)*data(:,31:40)';

    [tData,xData,stdData] = getData(index);

    errorbar(tData,xData*100,stdData*100,'d','MarkerSize',7,'MarkerFaceColor',colors(index,:),'Color',colors(index,:),'LineWidth',2); hold on;
    plot(tData,xData*100,'-','Color',colors(index,:),'LineWidth',4); hold on;


    clean();
end