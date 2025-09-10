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

% untreated: every other in cols 2 and 4:

[n,m]=size(xData);

growth_rates1 = [];
growth_rates2 = [];
x_values1 = [];
x_values2 = [];

t = [0,1];

for i = 2:2:(n-2)
%     g1 = xData(i+1,2) - xData(i,2); % (divided by 1)
%     g2 = xData(i+1,4) - xData(i,4); % (divided by 1)

    [~,g1] = getExpFit(t,[xData(i,2),xData(i+1,2)]);
    [~,g2] = getExpFit(t,[xData(i,4),xData(i+1,4)]);
    x1 = xData(i,2);
    x2 = xData(i,4);

    growth_rates1 = [growth_rates1,g1];
    growth_rates2 = [growth_rates2,g2];
    x_values1 = [x_values1,x1];
    x_values2 = [x_values2,x2];

end

plot(x_values1,growth_rates1,'.k','MarkerSize',30); hold on;
plot(x_values2,growth_rates2,'.r','MarkerSize',30);
clean();








