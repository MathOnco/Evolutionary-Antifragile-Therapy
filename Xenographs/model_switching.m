clc;clear;close all;
tolerances = 1e-8;
colors = get(groot,'DefaultAxesColorOrder');
options = odeset('RelTol',tolerances,'AbsTol',tolerances);
green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
color = black;
rng('default'); opts = optimset('Display','off');
dose = [25,25;50,0;12.5,12.5;25,0];
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
cycle_to_switch = 4;
[xFit,tD,rOut]=getLVs(chi,[]);
[xFitSwitch,tDSwitch,rOutSwitch]=getLVsSwitch(chi,[],cycle_to_switch);
chi



%% plot n(t)
figure(1); 
subplot(211);
for i = 1:2
    plot(tD,xFit(:,i),':','LineWidth',lw,'Color',colors(i,:));hold on;
    plot(tData,xData(:,i),'.','MarkerSize',ms,'Color',colors(i,:));
end
clean();ylabel('v(t)'); ylim([0 1.5]);

subplot(212);
for i = 3:4
    plot(tD,xFit(:,i),'-','LineWidth',lw,'Color',colors(i,:));hold on;
    plot(tData,xData(:,i),'.','MarkerSize',ms,'Color',colors(i,:));
end

clean();ylabel('v(t)'); ylim([0 1.5]);
xlabel('time, t');


%% plot resistance
figure(2);
subplot(211);
for i = 1:2
    plot(tD,rOut(:,i),':','LineWidth',lw,'Color',colors(i,:));hold on;
end
clean();ylabel('k(t)');ylim([0 1.1]);

subplot(212);
for i = 3:4
    plot(tD,rOut(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
end

clean();ylabel('k(t)');ylim([0 1.1]);
xlabel('time, t');






%% plot switching model
figure(3); 

subplot(211);
for i = 3:4
    plot(tD,xFit(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
    plot(tData,xData(:,i),'.','MarkerSize',ms,'Color',colors(i,:));
end
clean();ylabel('v(t)'); ylim([0 1.5]);


subplot(212);
for i = 3:4
    plot(tDSwitch,xFitSwitch(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
%     plot(tData,xData(:,i),'.','MarkerSize',ms,'Color',colors(i,:));
end
plot([8,8],[0,1.5],'-.k','LineWidth',lw);hold on;


clean();ylabel('v(t)'); ylim([0 1.5]);
xlabel('time, t');


%% plot resistance
figure(4);
subplot(211);
for i = 3:4
    plot(tD,rOut(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
end
clean();ylabel('k(t)');ylim([0 1.1]);

subplot(212);
for i = 3:4
    plot(tD,rOutSwitch(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
end
plot([8,8],[0,1.5],'-.k','LineWidth',lw);hold on;

clean();ylabel('k(t)');ylim([0 1.1]);
xlabel('time, t');



printPNG(figure(3),'high_dose_model_fit.png');
printPNG(figure(4),'sensitivity_model_fit.png');







