function [tData,xData,stdData] = getData(index)    
    tData = 0:1:20;
    tData = tData';
    
    data = xlsread('/Users/4467383/Documents/DynamicDoseResponse/Xenographs/BD33/In-vivo_switching.xlsx','Treatment','F5:AS25');
    
    EE = (1/100)*data(:,1:10)';
    EU = (1/100)*data(:,11:20)';
    UE = (1/100)*data(:,23:30)'; % ignore 2 broken ones
    UU = (1/100)*data(:,31:40)';
    
    %% find average (for now:)
    EEm = mean(EE)';
    EUm = mean(EU)';
    UEm = mean(UE)';
    UUm = mean(UU)';

    % find std:
    EEs = sem(EE)';
    EUs = sem(EU)';
    UEs = sem(UE)';
    UUs = sem(UU)';
    
    xData = [EEm,EUm,UEm,UUm];
    stdData = [EEs,EUs,UEs,UUs];


    if (index == 4)
        ti = 16; 
    else
        ti = length(tData);
    end

    tData = tData(1:ti);
    xData = xData(1:ti,index);
    stdData = stdData(1:ti,index);

    labels = {'Even-Even','Even-Uneven','Uneven-Even','Uneven-Uneven'};
    experiment = labels{index}

end