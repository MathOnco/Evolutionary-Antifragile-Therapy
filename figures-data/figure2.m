clc;clear;close all;

%% fit just the initial dose response:
% must load this first, to save "doseFit.mat" 
[doseFit,mkg,DIP_x,DIP_std,DIP_all] = DIP0();
figure(5); hold on; plotDIPErrorBars(DIP_all);

%% get dose response:
h=1;
H = @(p,x) (1/log(2)) .* (p(3)*p(1) + (x.^h).*p(2)) ./ (p(3)+(x.^h));
p = doseFit(1:3);

%% loop over SIGMA:
xbar = 0:5:25;
sigma = 0:0.1:25;
F = zeros(length(xbar),length(sigma));
colors = ColorRange(white()*0.85,blue(),length(xbar));

figure(1); hold on;
    plot(sigma,sigma.*0,'--','Color',black(),'LineWidth',3); hold on;

j = 1;
for x = xbar
    i=1;
    for s = sigma

        if (s>x)
            Fi = NaN;
        else
            Fi = (H(p,x+s) + H(p,x-s) ) / 2 - H(p,x);
        end
            
        F(j,i) = Fi;
        i = i + 1;
    end
    % plot this row
    plot(sigma,F(j,:),'-','Color',colors(j,:),'LineWidth',3); hold on;


    j = j+1;
end


xlim([0 25]);
ylim([-0.1,0.3]); 

clean();
c=colorbar();
colormap(colors)

% Sets the correct location and number of ticks
set(c, 'ytick', xbar / max(xbar));

% Set the tick labels as desired
set(c, 'yticklabel', xbar);




%% loop over XBAR
sigma = 0:1:5;
xbar = 0:0.1:50;
F = zeros(length(sigma),length(xbar));
colors = ColorRange(purple(),green(),length(sigma));

figure(2); hold on;
    plot(xbar,xbar.*0,'--','Color',black(),'LineWidth',3); hold on;

j = 1;
for s = sigma
    i=1;
    for x = xbar

        if (s>x)
            Fi = NaN;
        else
            Fi = (H(p,x+s) + H(p,x-s) ) / 2 - H(p,x);
        end

        F(j,i) = Fi;
        i = i + 1;
    end
    % plot this row
    plot(xbar,F(j,:),'-','Color',colors(j,:),'LineWidth',3); hold on;


    j = j+1;
end


xlim([0 50]);
ylim([-0.1,1.1*max(max(abs(F)))]); 

clean();
c=colorbar();
colormap(colors)

% Sets the correct location and number of ticks
set(c, 'ytick', sigma / max(sigma));

% Set the tick labels as desired
set(c, 'yticklabel', sigma);


printPNG(figure(1),'plot/figure2B.png');
printPNG(figure(2),'plot/figure2C.png');


