clc;clear;close all;
green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
colors = [purple;green;purple;green];
ms=30;
lw=3;

plotData();
[tF,yF,rF,chi]=plotFit();

[tS,yS,rS]=plotSwitching(chi,4);

% plot resistance

figure(2);
plotResistance(tF,yF,rF);
