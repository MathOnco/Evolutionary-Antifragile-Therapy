function []=plotDIPViolin(myDIP)
    xfit = 0:0.1:50;
    xTransform = (xfit./50)*4 + 1;
    mkg = [0,12.5,25,37.5,50];


    myMax=max(max(myDIP));
    myMin=min(min(myDIP));
    diff = myMax - myMin;


    [n,~]=size(myDIP);
    slice = zeros(n,1)*NaN;
    slice(1) = 1000;

    myDIP=myDIP + rand(16,4)*0.0001; % sample points must be unique
    myDIP = [myDIP(:,1:3),slice,myDIP(:,4)];
    

    alpha_bar = non_nan_mean(myDIP);
    pFit = DIP_fit(mkg([1,2,3,5]),alpha_bar(:,[1,2,3,5]));
    
    % use fit:
    DIP0_hill_fit_parameters = DIP(pFit(3),pFit(1),pFit(2),xfit);
    plot(xTransform,DIP0_hill_fit_parameters,'--k','LineWidth',4);

%     save('save/DIP0_hill_fit_parameters.mat','DIP0_hill_fit_parameters');
    
    violinplot(myDIP,mkg);
    clean();

    ylim([myMin-diff*.1, myMax+diff*.1]);

end