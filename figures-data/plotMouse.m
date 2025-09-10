%% plot single mouse data points:
function [] = plotMouse(t,v,x,bar_boolean)
    color = getColor();

    % also plot the dosing schedule
    load("save/tData.mat");
    D = getDosingSchedule();
    D=D/50*2.5;
    if (bar_boolean)
        bar(tData(1:end-1)+0.5,D,0.9,'FaceColor',color,'FaceAlpha',0.2, 'EdgeColor','none');
    end

    % plot data:
    
    load("save/cycles.mat");
    plot(t,v,'.','MarkerSize',30,'MarkerFaceColor',color,'Color',color); hold on;
    xlim([0,cycles*2])
end