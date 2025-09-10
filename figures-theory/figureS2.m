clc;clear; close all;
green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];


% compare the analytical second derivative to the numerical finite
% differencing method:

y=-1:0.01:2;
x=10.^(y);

% parameters:
p = [100,0,10,2];

n = 1:0.01:10;

x_over_c = ((n-1)./(n+1)).^(1./n);
jplot(n,x_over_c);
jplot(n,n.*0+1,'Color',black,'LineStyle',':');

xlabel('n');xlim([min(n),max(n)])
ylabel('x*/EC50');


% show various n:
nVec=[1.5,2,5,10];
colors = ColorRange(red,blue,length(nVec));


figure(2); clf; hold on;
i=1;
for n=nVec
    subplot(length(nVec),1,i);%set(gca,'XScale','log');
    %xlim([10^(min(y)),10^(max(y)),])
    xlim([10^(min(y)),25])
    ylim([0,105])
    
    p(4)=n;
    H = H1(p,x);
    jplot(x,H,'Color',black);
    
    
    % add the inflection point(p(3)):
    [~,j]=find(x>=p(3),1);
    plot(p(3),H(j),'.r','MarkerSize',40);
    
    
    % true inflection:
    INFL = p(3)*((n-1)./(n+1)).^(1./n);
    [~,j]=find(x>=INFL,1);
    plot(INFL,H(j),'.b','MarkerSize',40);

    ylabel('H_1(x)');
    
    if (i==length(nVec))
        xlabel('dose, x');
    end
    
    i=i+1;
end


printPNG(figure(1),'plots/S2a.png');
printPNG(figure(2),'plots/S2a.png');
