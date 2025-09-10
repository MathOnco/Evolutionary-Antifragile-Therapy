function [EC50_final] = plotEC50fit(p)

    load("save/cycles.mat");
    load("save/x.mat");

   
    % plot line for best fit:
    color = getColor();
    color = boundAll(1.4*color,[0,1]);



    yB = 0; yT = 3;   
    lw = 3.5;
    [tD,xD,tF,xF,yS,k_off] = getDiscreteModelData(p,x,cycles); 

    %% plot the sensitivity
    load("save/doseFit.mat");
    koff_kon = doseFit(3);
    kon = 5/koff_kon; % set koff \approx 0.5
    EC50 = k_off ./ kon;
    x=[tF',fliplr(tF')];
    y=[EC50'.*0,fliplr(EC50')];
    fill(x,y,color,'FaceAlpha',0.3,'EdgeColor',color); hold on;
    plot(tF,EC50,'-','Color',color,'LineWidth',3.5); hold on;


    if (tF(end) > (cycles*2-1))
        EC50_final = EC50(end);
    else
        EC50_final = NaN; % this experiment never finished.
    end

    xlim([0,cycles*2]);
    ylim([0 600]);

end