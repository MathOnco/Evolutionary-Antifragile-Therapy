clc;clear; close all;
green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];
gray=[219,219,219]/255;

% compare the analytical second derivative to the numerical finite
% differencing method:

ms1=40;
ms2=20;

x=0:0.1:25;

% parameters:
n=10;
p = [100,20,10,n];


%% log investigations:
figure(1); clf;
subplot(211);
H=H1(p,x);
plot(x,H,'-k','LineWidth',3);clean();
ylim([0 105]);
xlim([min(x),max(x)]);

subplot(212);
dh = ddH1(p,x);
plot(x,dh,':k','LineWidth',3);clean();
xlabel('dose, x');



figure(2);

% dosing vals
vals = 4:2:16;
c1 = ColorRange(red,gray,4);
c2 = ColorRange(gray,blue,4);
colors = [c1;c2(2:end,:)];






i=1;
for xS = vals
    color=colors(i,:);
    TRUE_DERIV = ddH1(p,xS);
    
    
    %% plot this dose on H, dh:
    figure(1);
    subplot(211);
    Hs=H1(p,xS);
    plot(xS,Hs,'.','MarkerSize',ms1,'Color',color);

    subplot(212);
    plot(xS,TRUE_DERIV,'.','MarkerSize',ms1,'Color',color);
    
    figure(2); hold on;
    h= 0.01:0.01:0.5;
    line=h.*0 + TRUE_DERIV;

    ddH_numerical = dd_numerical(h,p,xS,@H1);

    plot(h,ddH_numerical-line,'.','MarkerSize',ms2,'Color',color,'LineWidth',2);
    i=i+1;
end


clean();
xlabel('h');

printPNG(figure(1),'plots/S1A.png');
printPNG(figure(2),'plots/S1B.png');



function [ddH] = ddH1(c,x) 
    n=c(4);
    A=c(2)-c(1);
    B=c(3);
    
    %% from W-A:
    % https://www.wolframalpha.com/input/?i=d%5E2%2Fdx%5E2+of+%28A+x%5En%29+%2F+%28x%5En+%2B+B%5En%29++%2B+C
    
    % alternate form 1:
    %ddH=A.*n.*x.^(n-2) * ( B*(n-1) + 2.*(2*n-1).*(x.^n) );
    frac1=A.*n.*B.^n.*x.^(n-2).*( (n-1).*B^n - (n+1).*x.^n );
    frac2=((B.^n + x.^n).^3);
    ddH=frac1./frac2;
end

function [dd] = dd_numerical(h,p,y,model)
    dd = (1./(h.^2)) .* ( model(p,y+h) + model(p,y-h) - 2.*model(p,y) );
end