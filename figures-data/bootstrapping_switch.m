clc;clear;close all;

DOSE_VEC = [25,25; 12.5,12.5; 50,0; 25,0]; % EH, EL, UH, UL
cycles = 7;
save("save/cycles.mat","cycles");

%% carefully fit just the initial dose response:
[doseFit,mkg,DIP_x,DIP_std,DIP_all] = DIP0();

%% plot best fit:
% must load this first, to save "doseFit.mat" 
figure(5); hold on;
plotDIPErrorBars(DIP_all);



%% model fit: a0, ai
guess = [0,  0.2];
LB =    [0, 0];
UB =    [1, 1]*10;

alpha = zeros(16,length(mkg)).*NaN;

Rnorms = [];

% loop over all experiments:
for di = [1,2,3,4]

    x=DOSE_VEC(di,:);

    a0=zeros(8,1).*NaN;
    ai=zeros(8,1).*NaN;

    if ((di == 1) || (di == 2))
        lb=LB;
        ub=UB;
        ub(1) = lb(1);
    else
        lb=LB;
        ub=UB;
    end
    
    for i = 1:1:8        
        if ~((x(1) == 12.5) && (i>6))

            figure(di);
            subplot(4,2,i);hold on;

            % grab data:
            [tData,xData] = getMouse(x,i);
            plotMouse(tData,xData,x);
            
            % perform fit:
            [chi, resnorm, RESIDUAL] = lsqcurvefit(@getLSQ,guess,tData,xData',lb,ub,'');

            %resnorm is  the value of the squared 2-norm of the residual at X: sum {(FUN(X,XDATA)-YDATA).^2}.

            Rnorms = [Rnorms,resnorm];
            
            % plot fit:
            plotIndividualFit(chi);

            % store best parameters:
            a0(i)=chi(1);
            ai(i)=chi(2);
        end
    end

    clean();
    resize(1,2);
    printPNG(figure(di),strcat('plot/individual_',num2str(x(1)),'_',num2str(x(2)),'.png'));


    %% for violin plot:
    [alpha]=addToAlpha(alpha,ai,a0,x);
    
end

%% save alpha:
save('save/alpha.mat',"alpha");

%% error bars:
figure(6); hold on;
plotAlphaErrorBars(alpha);

printPNG(figure(6),'plot/alpha.png');

%% Violins:
% figure(6);
% plotAlphaViolin(alpha);
% figure(8);
% plotDIPViolin(DIP_all);


%% construct alpha matrix:
function [alpha]=addToAlpha(alpha,ai,a0,x)
    mkg = [0,12.5,25,50];
    if (x(2) == 0)
        % add alpha_0:
        ind=find(isnan(alpha(:,1)),1);
        alpha(ind:ind+length(a0)-1,1)=-a0;
    end

    %% otherwise, add ai:
    col_ind=find(mkg>=x(1),1); % this is the col of alpha
    row_ind=find(isnan(alpha(:,col_ind)),1);
    alpha(row_ind:row_ind+length(ai)-1,col_ind)=ai;
end











