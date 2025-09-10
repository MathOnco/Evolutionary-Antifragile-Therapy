function [alpha_hill_fit_parameters]=plotAlphaErrorBars(alpha,mkg)
    xfit = 0:0.1:50;

    % set y-scale
    myMax=max(max(alpha));
    myMin=min(min(alpha));
    diff = myMax - myMin;

    alpha_bar = nanmean(alpha);
    alpha_std = nanstd(alpha);
    alpha_hill_fit_parameters = DIP_fit(mkg,alpha_bar);

    
    % use fit:
    alpha_fit = DIP(alpha_hill_fit_parameters(3),alpha_hill_fit_parameters(1),alpha_hill_fit_parameters(2),xfit);
    plot(xfit,alpha_fit,'--k','LineWidth',4); hold on;
    
    % plot data on top:
    errorbar(mkg,alpha_bar,alpha_std,'.k','MarkerSize',60,'LineWidth',3);
    clean();    
    xlim([-5,55]);

end