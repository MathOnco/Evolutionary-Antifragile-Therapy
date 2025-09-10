function [] = plotResistance(tF,yF,rF)
    green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
    colors = [purple;green;purple;green];
    ms=30;
    lw=3;
    
    subplot(211);
    for i = 1:2
        plot(tF,rF(:,i),':','LineWidth',lw,'Color',colors(i,:));hold on;
    end
    clean();ylabel('k(t)');
    ylim([0 1.1]);
    
    subplot(212);
    for i = 3:4
        plot(tF,rF(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
    end
    
    clean();ylabel('k(t)');ylim([0 1.1]);
    xlabel('time, t');
end