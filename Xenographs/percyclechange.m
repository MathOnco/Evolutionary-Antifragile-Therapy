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

[tData,xData,stdData] = getData();




%% plot n(t)
figure(1); 
for i = 1:2
    plot(tData,xData(:,i),'-.','LineWidth',lw,'Color',colors(i,:));hold on;
    errorbar(tData,xData(:,i),stdData(:,i),'.','MarkerSize',ms,'LineWidth',lw,'Color',colors(i,:)); hold on;
end
clean();ylabel('n(t)'); ylim([0 1.5]);xlabel('time, t');xlim([0 12]);
resizeHeight(1.8);

figure(2); 
for i = 3:4
    plot(tData,xData(:,i),'-','LineWidth',lw,'Color',colors(i,:));hold on;
    errorbar(tData,xData(:,i),stdData(:,i),'.','MarkerSize',ms,'Color',colors(i,:)); hold on;
end

clean();ylabel('n(t)'); ylim([0 1.5]);xlabel('time, t');
resizeHeight(1.8);



yH=[0];
yL=[0];
FL=[0];
FH=[0];
% xData = [EVEN_HIGH,UNEVEN_HIGH,EVEN_LOW,UNEVEN_LOW];
cycles = 3:2:length(tData);
% find differences:
i=2;
for j = cycles

    yL(i)= xData(j,4) - xData(j,3);
    yH(i)= xData(j,2) - xData(j,1);
    FL(i) = (xData(j,4) - xData(j-2,4))./xData(j,4) - (xData(j,3) - xData(j-2,3))./xData(j,3); 
    FH(i) = (xData(j,2) - xData(j-2,2))./xData(j,2) - (xData(j,1) - xData(j-2,1))./xData(j,1); 
    i=i+1;
end

cycles = 0:1:length(cycles);

% cycles = tData(cycles)';

figure(3);
plot([0 6],[0,0],':r','LineWidth',2);hold on;
plot(cycles(2:end),FH(2:end),'-k','LineWidth',lw);hold on;
plot(cycles(2:end),FH(2:end),'.k','MarkerSize',ms,'LineWidth',lw); hold on;

clean();ylabel('F'); 
xlim([0,6]);
xlabel('cycle');
resizeHeight(1.8);
ylim([-0.5, 3]);


figure(4); 
subplot(211);
subplot(212);
plot([0 6],[0,0],':r','LineWidth',2);hold on;
plot(cycles(2:end),FL(2:end),'-.k','LineWidth',lw);hold on;
plot(cycles(2:end),FL(2:end),'.k','MarkerSize',ms); hold on;

clean();ylabel('F'); 
xlim([0,6]);
xlabel('cycle');
% resizeHeight(1.8);
ylim([-0.5, 3]);


% printPNG(figure(1),'high_dose.png');
% printPNG(figure(2),'high_dose_gain.png');

