function []=plotAlphaViolin(alpha)
    xfit = 0:0.1:50;
    xTransform = (xfit./50)*4 + 1;
    mkg = [0,12.5,25,37.5,50];


    myMax=max(max(alpha));
    myMin=min(min(alpha));
    diff = myMax - myMin;


    [n,~]=size(alpha);
    slice = zeros(n,1)*NaN;
    slice(1) = 1000;

    alpha = [alpha(:,1:3),slice,alpha(:,4)];

    alpha_bar = non_nan_mean(alpha);
    alpha_hill_fit_parameters = DIP_fit(mkg([1,2,3,5]),alpha_bar(:,[1,2,3,5]));

%     save('save/alpha_hill_fit_parameters.mat','alpha_hill_fit_parameters');
    
    % use fit:
    alpha_fit = DIP(alpha_hill_fit_parameters(3),alpha_hill_fit_parameters(1),alpha_hill_fit_parameters(2),xfit);
    plot(xTransform,alpha_fit,'--k','LineWidth',4);
    
    violinplot(alpha,mkg);
    clean();

    ylim([myMin-diff*.1, myMax+diff*.1]);

end