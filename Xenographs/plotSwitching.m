function [xFitSwitch,tDSwitch,rOutSwitch] = plotSwitching(chi,cycle_to_switch)
    green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
    colors = [purple;green;purple;green];
    ms=30;
    lw=3;

    [tData,xData,stdData] = getData();

    
    [xFit,tD,rOut]=getLVs(chi,[]);
    [xFitSwitch,tDSwitch,rOutSwitch,tF,yF,rF]=getLVsSwitch(chi,[],cycle_to_switch);
    
    
    %% plot switching model
    figure(3); 
    
    subplot(211);
    i=1; % purple
    plot(tF,yF(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;

    i=2; % green
    plot(tF,yF(:,i),'-','LineWidth',lw,'Color',colors(i,:));hold on;

    
    % plot continuous data:
    i=4;
    errorbar(tData,xData(:,i),stdData(:,i),'.','MarkerSize',ms,'LineWidth',lw,'Color',colors(i,:)); hold on;


    clean();ylabel('v(t)'); ylim([0 2]);
    
    
    subplot(212);
    i = 4; % green
    plot(tF,yF(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;

    i = 3; % purple
    plot(tF,yF(:,i),'-','LineWidth',lw,'Color',colors(i,:));hold on;

    % plot([8,8],[0,1.5],'-.k','LineWidth',lw);hold on;

    % plot continuous data:
    i=3;
    errorbar(tData,xData(:,i),stdData(:,i),'.','MarkerSize',ms,'LineWidth',lw,'Color',colors(i,:)); hold on;



    clean();ylabel('v(t)'); ylim([0 2]);
    xlabel('time, t');



end