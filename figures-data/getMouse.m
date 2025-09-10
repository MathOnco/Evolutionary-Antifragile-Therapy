%% get the ith mouse, for dosing scheme x, corresponding to experiment BD
% for BD31: x = [25, 25] or [50,0]
% for BD31: x = [25, 25, 25, 25] (EE) or [50, 0, 25, 25] (UE), etc.
function [tData,xData] = getMouse(x,i)
    load("save/cycles.mat");
    load("save/BD.mat"); % loads BD

    tData = 0:1:(cycles*2); % only first N cycles
    
    if (BD == 33)
        data = xlsread('/Users/4467383/Documents/DynamicDoseResponse/Xenographs/BD33/In-vivo_switching.xlsx','Treatment','F5:AS25');
    
        EE = (1/100)*data(:,1:10)';
        EU = (1/100)*data(:,11:20)';
        UE = (1/100)*data(:,21:30)'; % leave in 2 broken ones, ignore later?
        UU = (1/100)*data(:,31:40)';

        if ( (x(1) == 25) && (x(2) == 25) && (x(3) == 25) && (x(4) == 25) )
           xData = (EE(i,:));
        elseif ( (x(1) == 25) && (x(2) == 25) && (x(3) == 50) && (x(4) == 0) )
            xData = (EU(i,:));
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 25) && (x(4) == 25) )
            xData = (UE(i,:));
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 50) && (x(4) == 0) )
            xData = (UU(i,:));
        end


    else
        %% original experiment (BD31)
        data = xlsread('/Users/4467383/Documents/DynamicDoseResponse/Xenographs/BD31/In-vivo study_2.xlsx','Tumor measurement','B103:AE119');%'B97:AE111');

        data(7,:)=[];
        
        EH = (1/100)*data(:,1:8)';      EH = EH(:,1:length(tData));
        UH = (1/100)*data(:,9:16)';     UH = UH(:,1:length(tData));
        EL = (1/100)*data(:,17:22)';    EL = EL(:,1:length(tData));
        UL = (1/100)*data(:,23:30)';    UL = UL(:,1:length(tData));

        if ((x(1) == 25) && (x(2) == 0) )
            xData = (UL(i,:));
        elseif ((x(1) == 25) && (x(2) == 25) )
            xData = (EH(i,:));
        elseif ((x(1) == 12.5) && (x(2) == 12.5) )
            xData = (EL(i,:));
        elseif ((x(1) == 50) && (x(2) == 0) )
            xData = (UH(i,:));
        end
    end

    

    xData = xData(1:length(tData));

    % check for your nan's (where animal is sac'd)
    tData = tData(~isnan(xData));
    xData = xData(~isnan(xData));


    %% will likely update this later, to include full schedule:
    save("save/x.mat","x");
    save("save/tData.mat","tData");


end