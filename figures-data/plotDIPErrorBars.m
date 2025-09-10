function []=plotDIPErrorBars(myDIP)
    xfit = 0:0.1:50;
    mkg = [0,12.5,25,50];

    % set y-scale
    myMax=max(max(myDIP));
    myMin=min(min(myDIP));
    diff = myMax - myMin;


    DIP_bar = nanmean(myDIP);
    DIP_std = nanstd(myDIP);
    doseFit = DIP_fit(mkg,DIP_bar);

    save('save/doseFit.mat','doseFit');
    
    % use fit:
    myFit = DIP(doseFit(3),doseFit(1),doseFit(2),xfit);
    plot(xfit,myFit,'--k','LineWidth',4);
    
    % plot data on top:
    errorbar(mkg,DIP_bar,DIP_std,'.k','MarkerSize',60,'LineWidth',3);
    clean();

    ylim([myMin-diff*.1, myMax+diff*.1]);
    xlim([-5,55]);

end