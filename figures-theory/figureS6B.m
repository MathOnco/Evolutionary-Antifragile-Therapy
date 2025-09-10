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
addC1(chiS,black);
addC1(chiR,red);
ylim([0 100]);
clean();


%% 1st order effects
colors = ColorRange(purple,green,3);

alternateDoses = [20,18,20];
alternateVars = [0,10,20];

figure(2); hold on;
FirstOrderGradient(chiS,alternateDoses,alternateVars,colors);
printPNG(figure(2),'plots/S6Bsensitive.png');

% close all;
figure(3); hold on;
FirstOrderGradient(chiR,alternateDoses,alternateVars,colors);
printPNG(figure(3),'plots/S6Bsensitive.png');


function [] = FirstOrderGradient(chi,alternateDoses,alternateVars,colors)
    green = [0,133,66]/255; white = [1,1,1]; red = [176,36,24]/255; blue = [48,110,186]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];

    xMax=30;
    sMax=30;
    xBar = 0:(xMax/100):xMax;
    sigmas = 0:(sMax/100):sMax;
    
    vals =zeros(length(sigmas),length(xBar));
    
    i=1;
    for s = sigmas
        y1=getKill(xBar,s,chi,@H1);
%         jplot(xBar,y1,'LineStyle',ls,'Color',purple*(i/length(sigmas)),'LineWidth',3);hold on;
        vals(i,:)=y1;
        i=i+1;
    end
    
    
    

    %% setup matlab meshgrid:
    x_grid = xBar;
    y_grid = sigmas;
    [X,Y] = meshgrid(x_grid,y_grid); % Generate domain.
    BINS=40;

    rainbow=ColorRange(blue,red,BINS);
    [~,h]=contourf(X,Y,vals,BINS);
    set(h,'LineColor',[0,0,0]);
    set(h,'LineWidth',1.5);
    colormap(gca,rainbow);
    colorbar('FontSize',16);hold on;
    caxis([0 90]);
    
%     Z = 2.*(X+Y).^n()......
%     contour(X,Y,Z,[0,0]); % plots the countour line where Z=0

    
    %% get vertical component of the gradient:
    [U,V] = gradient(vals); 
    contour(X,Y,V,[0,0],'--','LineWidth',3,'Color',[1,1,1]); 

    %% add gradient arrows
%     [U,V] = gradient(vals); 
%     PlotQuiver(X,Y,U,V,[1,1,1],xMax,sMax);

    %% add x1
%     plot([getX1(chi),getX1(chi)],[0,max(sigmas)],'w--','LineWidth',3);
    
    %% add examples
    for i = 1:1:length(alternateDoses)
        m=alternateDoses(i);
        v=alternateVars(i);        
        mplot(m,v,'Color',colors(i,:),'MarkerSize',40);
    end
    
    clean();
%     
%     h=xlabel('$\bar{x}$');set(h,'Interpreter','Latex');
%     h=ylabel('$\sigma$');set(h,'Interpreter','Latex');
    
    colorbar off;
%     printPNG(figure(2),'theoretical/gradient.png');
    
end

function [y]=getKill(m,v,p,model)
    y=zeros(1,length(m));
    for i = 1:1:length(m)
        if ((m(i)-v)<0)
            y(1,i)=NaN;
        else
            y1=model(p,m(i)+v);
            y2=model(p,m(i)-v);
            y(1,i)=100-((y1+y2)/2);
        end
    end
%     y = y-y(1);% "percent" increase:
end


function [] = PlotQuiver(S,R,Xdot,Ydot,color,xMax,sMax)

    h = gcf;
    figure_number=h.Number;
    figure(figure_number); hold on;

    %% arrow length:

    K=2;
    
    len = 0.001;
    HL = 10/1.1;
    HW = 8/1.1;
    

    step = 5;
    
    for i = 1:step:length(S)
        for j = 1:step:length(R) 
            
            [i,j]
            
            if (isnan(S(i,j)) || isnan(R(i,j)))
                
            else            
                %% calculate direction & magnitude
                V = Ydot(i,j)/xMax;
                U = Xdot(i,j)/xMax; 
                mag = sqrt(V^2 + U^2);
                
                if ((S(i,j) + R(i,j) < 0.21))
                    V = -1;
                    U = -1;
                    mag = sqrt(2);
                end
                
                
                if (mag > 0)
                %% set direction & magnitude
                    ah = annotation('arrow','headStyle','cback1','HeadLength',HL,'HeadWidth',HW);

                    set(ah,'parent',gca);
                    set(ah,'position',[S(i,j), R(i,j), len*U/mag, len*V/mag]);
                    set(ah,'Color',color);
                end
            
            end
        end
    end
    clean_plot(figure_number,'','',true);
end

