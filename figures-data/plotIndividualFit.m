function [R2] = plotIndividualFit(p,xData)

    load("save/cycles.mat");
    load("save/x.mat");

   
    % plot line for best fit:
    color = getColor();
    color = boundAll(1.6*color,[0,1]);

    yB = 0; yT = 3;   
    lw = 3.5;
    [tD,xD,tF,xF,yS,k_off] = getDiscreteModelData(p,x,cycles); 
    plot(tF,yS,':','LineWidth',lw,'Color',color); hold on;
    ylim([yB,yT]);


    % return R^2 value for plotting:
    R2 = getRsquared(xData', xD);

    y=xData'
    yFit=xD
end













