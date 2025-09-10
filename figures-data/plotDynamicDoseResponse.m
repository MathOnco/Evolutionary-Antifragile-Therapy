function [] = plotDynamicDoseResponse(t,kon_vec,koff)

    c = 0:1:7;

    colors = ColorRange(blue(),red(),length(c));

    % plot initial dose response (blue)
    xfit = 0:0.1:200;
    load("doseFit.mat");

    % this comes from fitting dose response in time point 0:
    b1 = doseFit(1);
    b2 = doseFit(2);

    % update this:
    for cycle = c
        T = cycle*2;
        [index,~]=find(t>=T,1);
        kon = kon_vec(index);
        koff_kon = koff/kon;
    
        dip_fit = DIP(koff_kon,b1,b2,xfit);

        ind=round(length(dip_fit)/1000);
        dip_fit = dip_fit(1:ind:end);
        xfit = xfit(1:ind:end);

        plot(xfit,dip_fit,'-','Color',colors(cycle+1,:),'LineWidth',4); hold on;
    end

    
end