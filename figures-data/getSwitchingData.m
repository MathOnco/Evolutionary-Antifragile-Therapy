% function [tData,xData,stdData] = getSwitchingData()
    % EVEN_HIGH,UNEVEN_HIGH,EVEN_LOW,UNEVEN_LOW
    
    %% 7 cycles only:
    tData = 0:1:11;
    tData = tData';
    data = xlsread('/Users/4467383/Documents/GitHub/DynamicDoseResponse/Xenographs/Switching/BD33_even_uneven.xlsx','Tumor measurement ','B88:AO99');

    E_E = (1/100)*data(:,1:8)';
    E_U = (1/100)*data(:,9:16)';
    U_E = (1/100)*data(:,17:24)';
    U_U = (1/100)*data(:,25:32)';

%     EE=1; EU=2; UE=3; UU=4;


    %% find average (for now:)
    E_E_mean = mean(E_E)';
    E_U_mean = mean(E_U)';
    U_E_mean = mean(U_E)';
    U_U_mean = mean(U_U)';

    % find std:
    E_E_sem = sem(E_E)';
    E_U_sem = sem(E_U)';
    U_E_sem = sem(U_E)';
    U_U_sem = sem(U_U)';
    
    xData = [E_E_mean,E_U_mean,U_E_mean,U_U_mean];
    stdData = [E_E_sem,E_U_sem,U_E_sem,U_U_sem];


    colors = [purple(); green(); blue(); red()];

    figure(1); clf; hold on;
    for i = 1:1:4
        errorbar(tData,xData(:,i)*100,stdData(:,i)*100,'.','LineWidth',2,'Color',colors(i,:),'MarkerSize',40); hold on;
        plot(tData,xData(:,i)*100,'-','LineWidth',2,'Color',colors(i,:));
    end

    clean();
    set(gca,'YScale','log');
    xlim([0,14]);
    ylim([1,1000]);
%     set(gcf,'Position',[100,10000,1200,600]);




    figure(2); clf; hold on;
    for i = 1:1:4

        xData = [];
        if (i == 1)
            xData = E_E';
        elseif (i == 2)
            xData = E_U';
        elseif (i == 3)
            xData = U_E';
        else
            xData = U_U';
        end

        for j = 1:1:8
            row = xData(:,j)*100;
            plot(tData,row','.','LineWidth',2,'Color',colors(i,:),'MarkerSize',10); hold on;
            plot(tData,row','-','LineWidth',2,'Color',colors(i,:));
        end
    end

    clean();
    set(gca,'YScale','log');
    xlim([0,14]);
    ylim([1,1000]);
%     set(gcf,'Position',[100,10000,1200,600]);










%     





% 
% 
%     if (~isempty(x))
%         % get correct slice based on D:
%         index = 1;
%         if ((x(1)==25) && (x(2)==25))
%             index = 1; % even high
%         elseif ((x(1)==50) && (x(2)==0))
%             index = 2;
%         elseif ((x(1)==12.5) && (x(2)==12.5))
%             index = 3;
%         else
%             index = 4;
%         end
%            
%         xData = xData(:,index);
%         stdData = stdData(:,index);
%         
%         save("save/x.mat","x");
%     end

% end