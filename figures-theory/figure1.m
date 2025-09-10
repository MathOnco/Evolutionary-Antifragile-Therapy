clc;clear;close all;
opts = optimset('Display','off');
colors = categoricalColors();
blue = colors(1,:);red = colors(2,:);gray=[230, 230, 230]/255;
green = [0,133,66]/255; purple = [112,48,160]/255; bb = 0.3; black = [bb,bb,bb];

LINEAR = 1; LOGULAR = 2;
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontName','Arial');

chi=[100,0,15,5];
x = 0:0.01:30;
maxVar = 3;


figure(1);
yFit1  = H1(chi,x);
% yFit2  = H2(chi,y);
plot(x,yFit1,'-','LineWidth',5,'Color',black); hold on;

C=getC1(chi);
xS=getX1(chi);
plot([C,C],[0,100],'-','LineWidth',3,'Color',black); hold on;
plot([xS,xS],[0,100],'--','LineWidth',3,'Color',black); hold on;


addX1(chi,black);
addC1(chi,black);
ylim([0 100]);
clean();

%% linear-scale:
figure(2); hold on;
s = 0:(maxVar/5):maxVar; % 6 strategies
treatment_colors = ColorRange(purple,green,length(s));

j=1;
for sigma = s
    F1S=F1(x,sigma,chi);
    plot(x,F1S,'-','LineWidth',3,'Color',treatment_colors(j,:)); hold on;
    j=j+1;
end

%% add a nice colorbar for sigma:
   

%% add some labels to that nice colorbar:
NUM_LINES = 10;
T = round(max(s));
B = round(min(s));
step = round(10*((T-B)/(NUM_LINES+1)));
labels = B:(step/10):T;
L=strtrim(cellstr(num2str(labels'))');
colormap(treatment_colors); 
caxis([min(s),max(s)]);
cbh=colorbar();
cbh.Ticks=labels;
cbh.YTickLabel=L;

xS=getX1(chi);
plot([xS,xS],[-7,5],'k--','LineWidth',3);
ylim([-7,5])

clean();

%%%%%%%%%%%%%%%%%%%%%%%%
%% linear scale:
h=figure(3);
linVariancePlot(chi,maxVar)
h=area([0,0],[0,0]);

xStar = getX1(chi);
clean();
% box off;



v=2.7;

printPNG(figure(1),'plots/1dr.png');
printPNG(figure(2),'plots/2F.png');
printPNG(figure(3),'plots/3F.png');

function [] = variancePlot(LOGLIN,chi)
    LINEAR = 1; LOGULAR = 2;
    EC50= log10(chi(3));
    

    max_delta = max(EC50-(-2), 6-EC50);
    delta = 0:(max_delta/10):max_delta;
    means=[EC50-fliplr(delta),EC50+delta(2:end)];
        
    if (LOGLIN == LINEAR)
        EC50=chi(3);
        means=10.^(means);
    end
    
    % spacing of labels:
    
    
    
    colors = GetColors(means);

    i=1;
    var = 0:0.01:2;
    for m = means
        y=zeros(length(var),length(m));

        k=1;
        for v=var
            if (LOGLIN == LINEAR)
                y(k) = -F1(m,v,chi); % negative because we want benefit of uneven
            else
                y(k) = -F2(m,v,chi); % negative because we want benefit of uneven
            end
            
            k=k+1;
        end

        if (m==EC50)
            jplot(var,y','Color',colors(i,:),'LineStyle',':','LineWidth',3);
        else
            jplot(var,y','Color',colors(i,:),'LineWidth',3);
        end

        i=i+1;
    end
    
    colorbar;
    colormap(colors);
    
    if (LOGLIN == LINEAR)
        means=log10(means);
    end
    
    caxis([min(means),max(means)]);

end

function [] = linVariancePlot(chi,maxVar)

    xStar = getX1(chi);    
    NUM_LINES = 10;
    
    max_delta = max((xStar - maxVar),5);
    max_delta = (xStar - maxVar);
    delta = 0:(max_delta/(NUM_LINES/2)):max_delta;
    means=[xStar-fliplr(delta),xStar+delta(2:end)];
    
    colors = GetColors(means);

    i=1;
    
    var = 0:(maxVar/100):maxVar;
    for m = means
        y=zeros(length(var),length(m));

        k=1;
        for v=var
            y(k) = F1(m,v,chi); % negative because we want benefit of uneven            
            k=k+1;
        end
        
        if (m==xStar)
%             jplot(var,y','Color',colors(i,:),'LineStyle',':','LineWidth',3);
        else
            jplot(var,y','Color',colors(i,:),'LineWidth',5);
        end

        i=i+1;
    end
    
    colorbar;
    colormap(colors);    
    caxis([min(means),max(means)]);
    
    %% redo color bar labels to add x*    
    T = round(max(means)-1);
    B = round(min(means)+1);
    step = round(((T-B)/(NUM_LINES+1)));
    labels = B:step:T;
    
    % find xStar:
    [~,i]=find(labels>=xStar,1);
    labels(i) = xStar;
    
    L=strtrim(cellstr(num2str(labels'))');
    L{i}='x*';
    cbh=colorbar();
    cbh.Ticks=labels;
    cbh.YTickLabel=L;

end

function [colors] = GetColors(means)
    colors = categoricalColors();
    blue = colors(1,:);red = colors(2,:);gray=[230, 230, 230]/255;
    colors1=ColorRange(red,gray,(length(means)-1)/2+1);
    colors2=ColorRange(gray,blue,(length(means)-1)/2+1);
    colors=[colors1(1:end-1,:);gray;colors2(2:end,:)];
end


function [chi] = plot_data_best_fit(cell_line,drug,color,ECbool)

    f = gcf; hold on;

    % parameters
    exponents = -2:0.01:5;

    % get data:
    [c,y,error]=getData(drug,cell_line);
    [~,~,chi,model,resnorm, RESIDUAL] = getHillFit(c,y);

    yfit = model(chi,exponents);
    plot(exponents,yfit,'-','LineWidth',3,'Color',color);
    errorbar(log10(c),y,error,'.','MarkerSize',30,'Color',color);

    if ECbool
        [~,i]=find(exponents>=log10(chi(3)),1);
        plot(exponents(i),yfit(i),'s','LineWidth',2,'MarkerSize',15,'Color',color);
    end
end






