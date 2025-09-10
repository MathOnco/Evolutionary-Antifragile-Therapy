clc;clear;close all;

DOSE_VEC = [25,25; 
            12.5,12.5; 
            50,0; 
            25,0]; % EH, EL, UH, UL
EH=1; EL=2; UH=3; UL=4;

%% trajectories plot
lw = 2.5;
cycles1=3; 
cycles2=4; % sum to 14/2

E=EH; U=UH;

%% uneven
figure(1);
[tF,yS_U,koff_U] = getAllMice(U,U,cycles1,cycles2,green(),'-.',lw);

%% even
figure(2);
[~,yS_E,koff_E] = getAllMice(E,E,cycles1,cycles2,purple(),'-.',lw);

%% even -> uneven
figure(3);
[~,yS_E_U,koff_E_U] = getAllMice(E,U,cycles1,cycles2,red(),'-.',lw);

%% uneven -> even
figure(4);
[~,yS_U_E,koff_U_E] = getAllMice(U,E,cycles1,cycles2,blue(),'-.',lw);


%% plot variance:
% figure(5);clf; hold on;
% eplot(mean(tF),mean(yS_E_U),std(yS_E_U),'LineWidth',7,'Color',red()); hold on;
% eplot(mean(tF),mean(yS_U_E),std(yS_U_E),'LineWidth',7,'Color',blue()); hold on;
% eplot(mean(tF),mean(yS_U),std(yS_U),'LineWidth',7,'Color',green()); hold on;
% eplot(mean(tF),mean(yS_E),std(yS_E),'LineWidth',7,'Color',purple()); hold on;

%% figure 3: initial dose response
% figure(6); hold on;
% plotDoseResponse(koff_U(:,1),black(),':',5);
% 
% [mkg,DIP_mean,DIP_std] = DIP0_data();
% errorbar(mkg,DIP_mean,DIP_std,'.k','MarkerSize',60,'LineWidth',3);
% clean();


% %% figure 4: middle dose response (6 weeks)
% figure(7); hold on; lw = 2;
% plotDoseResponse(koff_U(:,1),black(),':',5);
% plotDoseResponse(koff_U(:,2),green(),':',lw);
% plotDoseResponse(koff_E(:,2),purple(),':',lw);

%% figure 4: final dose response (e,u weeks)
% figure(7); hold on; lw = 2;
% plotDoseResponse(koff_U(:,1),black(),':',5);
% plotDoseResponse(koff_U(:,3),green(),':',lw);
% plotDoseResponse(koff_E(:,3),purple(),':',lw);
% 
% [mkg,DIP_mean,DIP_std] = DIP0_data();
% errorbar(mkg,DIP_mean,DIP_std,'.k','MarkerSize',60,'LineWidth',3);
% clean();

%% figure 5: final dose response (14 weeks)
% figure(8); hold on;
% plotDoseResponse(koff_U(:,1),black(),':',5);
% plotDoseResponse(koff_E_U(:,3),red(),'-',lw);
% plotDoseResponse(koff_U_E(:,3),blue(),'-',lw);
% plotDoseResponse(koff_U(:,3),green(),':',lw);
% plotDoseResponse(koff_E(:,3),purple(),':',lw);


% [mkg,DIP_mean,DIP_std] = DIP0_data();
% errorbar(mkg,DIP_mean,DIP_std,'.k','MarkerSize',60,'LineWidth',3);
% clean();




%% violin plot of final vals:
cmap = [purple();green();red();blue()];



figure(9);
final_values = constructViolinDataBase(yS_E(:,end),yS_U(:,end),yS_E_U(:,end),yS_U_E(:,end));
cats = {'Even','Uneven','Ev-Un','Un-Ev'};
violinplot(final_values,cats,'ViolinColor',cmap);
clean();

%% violin plot of final EC50's
kon = 0.5607; % = 5/doseFit(3)



figure(10);
final_values = constructViolinDataBase(koff_E(:,end)./kon,koff_U(:,end)./kon,koff_E_U(:,end)./kon,koff_U_E(:,end)./kon);
cats = {'Even','Uneven','Ev-Un','Un-Ev'};
violinplot(final_values,cats,'ViolinColor',cmap);
clean();
% ylim([0 900])

% addSignificance(final_values, [0 900])


figure(1);resize(1,0.5);
figure(2);resize(1,0.5);
figure(3);resize(1,0.5);
figure(4);resize(1,0.5);

printPNG(figure(1),'plot/figure5a.png');
printPNG(figure(2),'plot/figure5b.png');
printPNG(figure(3),'plot/figure5d.png');
printPNG(figure(4),'plot/figure5c.png');

% printPNG(figure(7),'plot/figure5-dr-6.png');
% printPNG(figure(8),'plot/figure5-dr-14.png');
printPNG(figure(9),'plot/figure5-vol-14.png');
printPNG(figure(10),'plot/figure5-ec-14.png');


% printPNG(figure(1),'plot/switching_trajectories_all.png');
% printPNG(figure(2),'plot/switching_trajectories_mean.png');
% printPNG(figure(3),'plot/switching_dose_response_initial.png');
% printPNG(figure(4),'plot/switching_dose_response_wk6.png');
% printPNG(figure(5),'plot/switching_dose_response_wk14.png');
% printPNG(figure(6),'plot/switching_final_tumor_size.png');
% printPNG(figure(7),'plot/switching_final_ec50.png');




function [database] = constructViolinDataBase(y1,y2,y3,y4)

    m1 = max([length(y1),length(y2),length(y3),length(y4)]);
    
    database = zeros(m1,4)*NaN;
    database(1:length(y1),1) = y1;
    database(1:length(y2),2) = y2;
    database(1:length(y3),3) = y3;
    database(1:length(y4),4) = y4;
end



function [tF,yS,koff] = getAllMice(di,dj,cycles1,cycles2,color,ls,lw)
    DOSE_VEC = [25,25; 12.5,12.5; 50,0; 25,0]; % EH, EL, UH, UL
    koff = []; tF = []; yS = [];
    
    if (di ~= dj) % switching strategies

        %% from individual data:
        [a1,a2,x1,x2]=getAlpha_1and2(di,dj,DOSE_VEC);
        [n1,~]=size(a1); [n2,~]=size(a2);
        
        % loop over all a2 vals:
        for j = 1:1:n2
            if ~isnan(a2(j,2))
                chi2 = a2(j,:);
    
                % loop over all a1 vals:
                for i = 1:n1
                    if ~isnan(a1(i,2))
                        chi1=a1(i,:);
                        
                        [~,~,tFthis,xF,ySthis,koff_vec] = getDiscreteSwitchingData(chi1,chi2,x1,x2,cycles1,cycles2);
        
                        koff = [koff;koff_vec];
                        tF = [tF;tFthis']; yS = [yS;ySthis'];
    
                        plot(tFthis,ySthis,'-','LineWidth',lw,'Color',color,'LineStyle',ls); hold on;
                    end
                end
            end
        end
    else
        % single strategy (no switching, no need to do double for-loop):
        
        [a1,a2,x1,x2]=getAlpha_1and2(di,dj,DOSE_VEC)
        [n1,~]=size(a1); [n2,~]=size(a2);

        % loop over all a1 vals:
        for i = 1:n1
            if ~isnan(a1(i,2))
                chi1=a1(i,:);
                chi2 = chi1; % no switching, stays the same

%                 cycles1
%                 cycles2
            
                [~,~,tFthis,xF,ySthis,koff_vec] = getDiscreteSwitchingData(chi1,chi2,x1,x2,cycles1,cycles2);

                koff = [koff;koff_vec];
                tF = [tF;tFthis']; yS = [yS;ySthis'];

                plot(tFthis,ySthis,'-','LineWidth',lw,'Color',color,'LineStyle',ls); hold on;

            end
        end
    end

    YLIM = 2;
    clean();
    xlim([0,2*(cycles1+cycles2)]);
    ylim([0 YLIM]);
    
end


function [a1,a2,x1,x2] = getAlpha_1and2(di,dj,DOSE_VEC)
    a = load('save/alpha_BD31.mat');
    alpha = a.alpha;

    x1=DOSE_VEC(di,:); x2=DOSE_VEC(dj,:);
    a1 = getAlpha(x1,alpha); 
    a2 = getAlpha(x2,alpha);

end

% function [a1,a2,x1,x2] = getAlpha_1and2(di,dj,DOSE_VEC)
%     a = load('save/alpha.mat');
%     alpha = a.alpha;
% 
%     x1=DOSE_VEC(di,:); x2=DOSE_VEC(dj,:);
%     a1 = getAlpha(x1,alpha); a2 = getAlpha(x2,alpha);
% 
% end



% function [a] = getAlpha(x,alpha)
% 
%     % returns cols of [a0,ai], where rows are individual mice
%     % remember, alpha constructed in this order: EH, EL, UH, UL
% 
%     % cols in alpha: [0, 12.5, 25, x, 50]
%     first_indices = 1:8;
%     second_indices = 9:16;
% 
%     z=zeros(8,1);
%     % get correct slice based on D:
%     if ((x(1)==25) && (x(2)==25))
%         % even, high
%         a= [z, -alpha(first_indices,3)];
%     elseif ((x(1)==50) && (x(2)==0))
%         % uneven, high
%         a= [alpha(first_indices,1), -alpha(first_indices,5)]; % was 5
%     elseif ((x(1)==12.5) && (x(2)==12.5))
%         % even, low
%         a= [z, -alpha(first_indices,2)];
%     else
%         % uneven, low
%         a= [alpha(second_indices,1), -alpha(second_indices,3)];
%     end
% end


function [a] = getAlpha(x,alpha)
    
    % returns cols of [a0,ai], where rows are individual mice
    % remember, alpha constructed in this order: EH, EL, UH, UL

    alpha(:,1) = -alpha(:,1);

    % cols in alpha: [0, 12.5, 25, x, 50]
    EH_indices = 1:8;
    EL_indices = 9:14;
    UH_indices = 15:22;
    UL_indices = 23:30;

    z=zeros(8,1);
    % get correct slice based on D:
    if ((x(1)==25) && (x(2)==25))
        % even, high
        a= [z, alpha(EH_indices,3)];
    elseif ((x(1)==50) && (x(2)==0))
        % uneven, high
        a= [alpha(UH_indices,1), alpha(UH_indices,4)]; % was 5
    elseif ((x(1)==12.5) && (x(2)==12.5))
        % even, low
        a= [z, alpha(EL_indices,2)];
    elseif ((x(1)==25) && (x(2)==0))
        % uneven, low
        a= [alpha(UL_indices,1), alpha(UL_indices,3)];
    end
end



