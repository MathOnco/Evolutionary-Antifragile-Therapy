clc;clear;close all;

%% fit just the initial dose response:
% must load this first, to save "doseFit.mat" 
[doseFit,mkg,DIP_x,DIP_std,DIP_all] = DIP0();
% figure(5); hold on; plotDIPErrorBars(DIP_all);
xfit = 0:0.1:50;

%% set which experiment: 31 (high/low even/uneven) or 33 (switching, high dose)
BD = 33;
[cycles,DOSE_VEC,N,mkg,experiment_names] = getParametersBD(BD);

% alpha = zeros(16,length(mkg)).*NaN;
alpha = [];
Rnorms = [];

EC50vec = [];

% loop over all experiments:
for di = [1,2,3,4]
    

    x=DOSE_VEC(di,:);
    
    ECs = [];

    for i = 1:1:N

        % might add back in the broken ones from BD33 later:
        %if (~((di == 3) && (i<3)) && (BD == 33)) || ( ~((x(1) == 12.5) && (i>6)) && (BD == 31) )
        if ( ~((x(1) == 12.5) && (i>6)) && (BD == 31) ) || (BD == 33)

            figure(di);box off;
            subplot(N,1,i);hold on;

            %% grab data:
            [tData,xData] = getMouse(x,i);
            plotMouse(tData,xData,x,false); % bars = false

            % you must do this after getMouse:
            [LB, UB,guess,ignore] = getParameterBounds(BD);
            ignore_indices = isnan(ignore);
            
            %% perform fit:
            [chi, resnorm, RESIDUAL] = lsqcurvefit(@getLSQ,guess,tData,xData',LB,UB,'');

            %% resnorm is  the value of the squared 2-norm of the residual at X: sum {(FUN(X,XDATA)-YDATA).^2}.
            Rnorms = [Rnorms,resnorm];
            
            %% plot fit:
            % yyaxis left;
            % plotEC50fit(chi);

            % yyaxis right;
            R2=plotIndividualFit(chi,xData);
            text(3, 2.5, strcat('R^2=',num2str(R2,2)),'FontSize',14); hold on;            

            % xlim([0,(cycles-1)*2]);

            %% plot and save EC50(t)
            figure(di+10);
            subplot(N,1,i);hold on;
            [EC50_final] = plotEC50fit(chi);


            %% save alphas
            these_alphas = chi;
            these_alphas(ignore_indices) = ignore(ignore_indices);
            alpha = [alpha;these_alphas];


            % xlim([0,(cycles-1)*2]);

            ECs = [ECs;EC50_final];
        else
            ECs = [ECs;NaN];
        end

        figure(20);  hold on;
        

        color = getColor();
        myFit = DIP(EC50_final,doseFit(1),doseFit(2),xfit);
        plot(xfit,myFit,'-','LineWidth',2,'Color',color); hold on;

    end
    
    figure(di);clean();xlabel('time');box off;
    resize(0.4,2);setfontsize(12);
    % resize(1,2);
    printPNG(figure(di),strcat('plot/',num2str(BD),'-',char(experiment_names{di}),'.png'));
    
    figure(di+10);clean();xlabel('time');box off;
    resize(0.4,2);setfontsize(12);
    printPNG(figure(di+10),strcat('plot/',num2str(BD),'-EC-',char(experiment_names{di}),'.png'));

    EC50vec = [EC50vec,ECs];
end

% plot original DR on top.
figure(20); hold on; plotDIPErrorBars(DIP_all);
printPNG(figure(20),strcat('plot/',num2str(BD),'-DR-all.png'));

alpha(:,1) = -alpha(:,1); % this is encoded in UA_evolve, so need to switch.
if (BD == 33)
    alpha(:,2) = []; % remove this unecessary point
end


figure(50);
plotEC50Violin(EC50vec);
printPNG(figure(50),strcat('plot/',num2str(BD),'-EC50violin.png'));


%% save alpha:
save(strcat('save/alpha_BD',num2str(BD),'.mat'),"alpha");

%% error bars:
figure(6); hold on;
alpha_hill_fit_parameters = plotAlphaErrorBars(alpha,mkg);
ylim([-2.5, 2]);

save(strcat('save/alpha_fit_BD',num2str(BD),'.mat'),"alpha_hill_fit_parameters");
printPNG(figure(6),strcat('plot/',num2str(BD),'-alpha.png'));

function [cycles,DOSE_VEC,N,mkg,experiment_names] = getParametersBD(BD)
    % BD 33 parameters:
    cycles = 9; N = 10; 
    mkg = [0,25,50];
    DOSE_VEC = [25,25,25,25;
                25,25,50,0;
                50,0,25,25;
                50,0,50,0]; % EE, EU, UE, UU

    experiment_names = {'Even','Even-Uneven','Uneven-Even','Uneven'};
    
    if (BD == 31)
        mkg = [0,12.5,25,50];
        N = 8; 
        cycles = 7;
        DOSE_VEC = [25,25;
                    12.5,12.5;
                    50,0;
                    25,0]; % EH, EL, UH, UL
        experiment_names = {'Even (High Dose)','Even (Low Dose)','Uneven (High Dose)','Uneven (Low Dose)'};
    end
    save("save/cycles.mat","cycles");
    save("save/BD.mat","BD");
end

function [LB, UB,guess,ignore] = getParameterBounds(BD)
    load("save/x.mat");
    

    % always 0 lower bound, since sign is taken care of in UA_evolve:
    LB = [0,0,0,0]; 

    % maximum upper bound (absolute value)
    MAX = 10;
    g=0.2;
    g0=2;
    
    if (BD == 31)
        % mkg = [0, 12.5, 25, 50];

        if ((x(1) == 25) && (x(2) == 0) )
            % UL
            UB = [MAX, 0, MAX, 0]; % zeros for irrelevant doses
            guess = [0,0,g,0];
            ignore = [0,NaN,0,NaN];
        elseif ((x(1) == 25) && (x(2) == 25) )
            % EH
            UB = [0, 0, MAX, 0]; % zeros for irrelevant doses
            guess = [0,0,g,0];
            ignore = [NaN,NaN,0,NaN];
        elseif ((x(1) == 12.5) && (x(2) == 12.5) )
            % EL
            UB = [0, MAX, 0, 0]; % zeros for irrelevant doses
            guess = [0,g,0,0];
            ignore = [NaN,0,NaN,NaN];
        elseif ((x(1) == 50) && (x(2) == 0) )
            % UH
            UB = [MAX, 0, 0, MAX]; % zeros for irrelevant doses
            guess = [0,0,0,g];
            ignore = [0,NaN,NaN,0];
        end
    else
        % mkg = [0, 12.5, 25, 50];

        if ( (x(1) == 25) && (x(2) == 25) && (x(3) == 25) && (x(4) == 25) )
            % EE (25 dose) - but this also has a 50 in here.

%% might want to look into this?
            UB = [MAX, 0, MAX, MAX]; % zeros for irrelevant doses
            guess = [0,0,g,0];
            ignore = [0,NaN,0,0];
        elseif ( (x(1) == 25) && (x(2) == 25) && (x(3) == 50) && (x(4) == 0) )
            % EU (0, 25, 50 dose)
            UB = [MAX, 0, MAX, MAX]; % zeros for irrelevant doses
            guess = [0,0,g,g];
            ignore = [0,NaN,0,0];
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 25) && (x(4) == 25) )
            % UE (0, 25, 50 dose)
            UB = [MAX, 0, MAX, MAX]; % zeros for irrelevant doses
            guess = [0,0,g,g];
            ignore = [0,NaN,0,0];
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 50) && (x(4) == 0) )
            % UU (0, 25, 50 dose)
            UB = [MAX, 0, 0, MAX]; % zeros for irrelevant doses
            guess = [0,0,0,g];
            ignore = [0,NaN,NaN,0];
        end

    end

end




function []=plotEC50Violin(EC50vec)
    mkg = [0,12.5,25,37.5,50];


    % EE, EU, UE, UU
    EC50vecT = [EC50vec(:,4),EC50vec(:,1),EC50vec(:,3),EC50vec(:,2)];


    myMax=max(max(EC50vecT));
    myMin=min(min(EC50vecT));
    diff = myMax - myMin;


    

    colors = [green();purple();blue();red()];

    violinplot(EC50vecT,mkg,'ViolinColor',colors);
    clean();

    ylim([myMin-diff*.1, myMax+diff*.1]);

    xticklabels({'UU','EE','UE','EU'});

    ylim([0 600])
    addSignificance(EC50vecT,[0,600])


end





