function [] = plotDoseResponse(koff_vec,color,ls,lw)
% plot the dose response function (DIP vs x)
% requires that "save/doseFit.mat" has been saved

    DF = load("save/doseFit.mat");
    doseFit = DF.doseFit;
    xfit = 0:(50/1000):50;


    koff_kon0 = doseFit(3);

    %% now we set kon, fit koff(t)
    kon = 5/koff_kon0; % set koff \approx 0.5


    for i = 1:1:length(koff_vec)
        koff=koff_vec(i);
        
        % this comes from fitting dose response in time point 0:
        b1 = doseFit(1);
        b2 = doseFit(2);
        % koff = 5; % set koff
        
        koff_kon = koff / kon;

        
        dip_fit = DIP(koff_kon,b1,b2,xfit);    
        plot(xfit,dip_fit,'-','Color',color,'LineWidth',lw,'LineStyle',ls); hold on;
    end

    xlim([xfit(1)-2,xfit(end)+2]);
    ylim([-3,1.5]);
end