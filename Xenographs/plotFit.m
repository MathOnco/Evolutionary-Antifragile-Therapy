function [tF,yF,rF,chi] = plotFit()

    tolerances = 1e-8;
    opts = odeset('RelTol',tolerances,'AbsTol',tolerances);
    green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
    colors = [purple;green;purple;green];
    ms=30;
    lw=3;


    %% parameters
    D1 = 0.1; % even, high
    D2 = 0.2; % uneven, high
    D3 = 0.05; % even, low
    D4 = 0.1; % uneven, low
    r = 0.1;
    aOn = 0.1;
    aOff = 0.1;
    guess = [D1,D2,D3,D4,r,aOn,aOff];
    
    [tData,xData] = getData();
    
    %% determine upper / lower bounds
    %[D,D2,r,alpha];
    lb = [0,  0, 0, 0,      0,     0,0];
    ub = [10, 10,10, 10,    5,     1,1];
    
    [chi, resnorm, RESIDUAL] = lsqcurvefit(@getLVs,guess,tData,xData,lb,ub,opts);
    % % resnorm is: squared 2-norm of the residual at X: sum {(FUN(X,XDATA)-YDATA).^2}.
    % chi=[chi,1-resnorm]
    
    % plot best:
    [xFit,tD,rOut,tF,yF,rF]=getLVs(chi,[]);
    
    %% plot n(t)
    figure(1); 
    subplot(211);
    for i = 1:2
        plot(tF,yF(:,i),':','LineWidth',lw,'Color',colors(i,:));hold on;
        plot(tData,xData(:,i),'.','MarkerSize',ms,'Color',colors(i,:));
    end
    clean();
    ylim([0 1.5]);
    
    subplot(212);
    for i = 3:4
        plot(tF,yF(:,i),'-','LineWidth',lw,'Color',colors(i,:));hold on;
        plot(tData,xData(:,i),'.','MarkerSize',ms,'Color',colors(i,:));
    end
    
    clean();
    ylim([0 1.5]);
    xlabel('time, t');

end