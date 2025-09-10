clc;clear;close all;
green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];

%% original toy example:
chiS=[100,0,15,5];
chiR=[100,0,25,5];
y = -2:0.01:log10(40);
x = 10.^(y);

figure(1);
yFitS  = H1(chiS,x);
yFitR  = H1(chiR,x);
plot(x,yFitS,':','LineWidth',3,'Color',black); hold on;
plot(x,yFitR,'--','LineWidth',3,'Color',red); hold on;

addX1(chiS,black);
addX1(chiR,red);
% addC1(chiS,black);
ylim([0 100]);
clean();



%% 1st order effects
colors = ColorRange(purple,green,3);

alternateDoses = [20,18,20];
alternateVars = [0,10,20];

figure(2);
subplot(211);
FirstOrderEffects(chiS,':',alternateDoses,alternateVars,colors);
clean();

subplot(212);
FirstOrderEffects(chiR,'--',alternateDoses,alternateVars,colors);
clean();

% resize figure 2:
resize(1,1.8);
% moveup();


% printPNG(figure(1),'theoretical/limits_1.png');
% printPNG(figure(2),'theoretical/limits_2.png');

for i = 1:1:length(alternateDoses)
    figure(i+2);
    plotCycle(alternateDoses(i),alternateVars(i),colors(i,:),50);
    ylabel('dose');
    box off;
    resize(1,1/1.8);
    % printPNG(figure(i+2),strcat('theoretical/limits_',num2str(i+2),'.png'));
end


function [] = FirstOrderEffects(chi,ls,alternateDoses,alternateVars,colors)
    green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];

    xBar = 0:0.01:30;

    y1=getKill(xBar,0,chi,@H1);
    yBound=getUpperLimitKill(xBar,chi,@H1);


    %% add infl:
    % [~,i]=find(xBar>=getX1(chi),1);
    % mplot(xBar(i),y1(i),'Color',purple,'MarkerSize',30);

    %% intersection of the two
    d=10;
    [~,i]=find(y1(d:end)>=yBound(d:end),1);
    index=i+d-1;
    

    x1=xBar(1:index);
    x2=xBar(index:end);
    y11=y1(1:index);
    y12=y1(index:end);
    yB1=yBound(1:index);
    yB2=yBound(index:end);

    %% fill bottom half:
    fill([x1, fliplr(x1)], [y11, fliplr(yB1)], green,'FaceAlpha',0.2,'LineStyle','none');hold on;
    
    %% fill top half:
    fill([x2, fliplr(x2)], [y12, fliplr(yB2)], purple,'FaceAlpha',0.2,'LineStyle','none');hold on;

    jplot(xBar,y1,'LineStyle',ls,'Color',purple,'LineWidth',3);hold on;
    jplot(xBar,yBound,'LineStyle',ls,'Color',green,'LineWidth',3);
    
    SOC = alternateDoses(1);
    jplot([SOC,SOC],[0,100],'LineStyle',':','LineWidth',3,'Color',black);
    
    % add standard of care doses:
%     [~,i]=find(xBar>=SOC,1);
%     mplot(xBar(i),y1(i),'Color',black,'MarkerSize',30);
    
    
    
    for i = 1:1:length(alternateDoses)
        m=alternateDoses(i);
        v=alternateVars(i);
        
        y1=getKill(m,v,chi,@H1);
        mplot(m,y1,'Color',colors(i,:),'MarkerSize',30);
    end
    

    clean();

end





% mplot(xBar(index),y1(index),'Color',purple,'MarkerSize',30);


% curve1 = xx.*0 + delta(2);
% curve2 = xdot2./myNorm + delta(2);
% inBetween = [curve1, fliplr(curve2)];
% x2 = [xx, fliplr(xx)];
% fill(x2, inBetween, color/2,'FaceAlpha',0.2,'LineStyle','none');

function [y]=getUpperLimitKill(m,p,model)
    y=zeros(1,length(m));
    for i = 1:1:length(m)
        v=m(i);
        y1=model(p,m(i)+v);
        y2=model(p,m(i)-v);
        y(1,i)=100-((y1+y2)/2);

    end
%     y = y-y(1);% "percent" increase:
end

function [y]=getKill(m,v,p,model)
    y=zeros(1,length(m));
    for i = 1:1:length(m)
        y1=model(p,m(i)+v);
        y2=model(p,m(i)-v);
        y(1,i)=100-((y1+y2)/2);
    end
%     y = y-y(1);% "percent" increase:
end



% modelS
% model = @(c,x) c(2) - ((c(2) - c(1))./(1 + (10.^(x)/10.^(c(3))).^(-c(4))));





% figure(2);
% DAYS_HIGH = 3; 
% DAYS_TOTAL = 6;
% L = DAYS_HIGH/DAYS_TOTAL;
% ORDER = 1;
% 
% FS = calcFLOG(cS,chiS,modelS,DAYS_HIGH/DAYS_TOTAL,ORDER);
% FR = calcFLOG(cR,chiR,modelR,DAYS_HIGH/DAYS_TOTAL,ORDER);
% 
% [xx,ii]=min(FR);
% min_dose = cR(ii);
% 
% 
% plot(cS,FS,'-k','LineWidth',3); hold on;
% 
% set(gca,'XScale','log');
% clean();
% xlabel('dose');ylabel('F');
% xlim([1e-2,1e5]);


function [F] = calcF(c,chi,model,l)

    H = chi(1);
    F = zeros(1,length(c));
    for i = 1:length(c)
       
        x1 =c(i)*2;
        x2=0;
        
        c_prime = l*x1+(1-l)*x2;
        
        F(i) =  l*model(chi,log10(x1))+  (1-l)*H - model(chi,log10(c_prime));
    end
end
function [F] = calcFLOG(c,chi,model,l,ORDER)

    H = chi(1);
    F = zeros(1,length(c));
    for i = 1:length(c)
        
        cL = log10(c(i));
        x1 =cL+ORDER;
        x2=cL-ORDER;
        
        c_prime = l*x1+(1-l)*x2;
        
        F(i) =  l*model(chi,x1)+  (1-l)*model(chi,x2) - model(chi,c_prime);
    end
end


