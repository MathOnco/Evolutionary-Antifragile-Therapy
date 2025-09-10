function [tData,xData,stdData] = getData()
    % EVEN_HIGH,UNEVEN_HIGH,EVEN_LOW,UNEVEN_LOW
    
    %% 6 cycles only:
    tData = 0:1:12;
    tData = tData';
    
    data = xlsread('BD31/In-vivo study_1.xlsx','Tumor measurement','B97:AE111');
    data(7,:)=[];
    
    EH = (1/100)*data(:,1:8)';
    UH = (1/100)*data(:,9:16)';
    EL = (1/100)*data(:,17:22)';
    UL = (1/100)*data(:,23:30)';
    
    
    %% find average (for now:)
    EVEN_HIGH = mean(EH);
    UNEVEN_HIGH = mean(UH);
    EVEN_LOW = mean(EL);
    UNEVEN_LOW = mean(UL);

    % find std:
    EVEN_HIGH_SD = sem(EH);
    UNEVEN_HIGH_SD = sem(UH);
    EVEN_LOW_SD = sem(EL);
    UNEVEN_LOW_SD = sem(UL);
    
    %% resize to fit 6 cycles:
    EVEN_HIGH = EVEN_HIGH(1:length(tData))';
    UNEVEN_HIGH = UNEVEN_HIGH(1:length(tData))';
    EVEN_LOW = EVEN_LOW(1:length(tData))';
    UNEVEN_LOW = UNEVEN_LOW(1:length(tData))';


    EVEN_HIGH_SD = EVEN_HIGH_SD(1:length(tData))';
    UNEVEN_HIGH_SD = UNEVEN_HIGH_SD(1:length(tData))';
    EVEN_LOW_SD = EVEN_LOW_SD(1:length(tData))';
    UNEVEN_LOW_SD = UNEVEN_LOW_SD(1:length(tData))';
    
    

    
    xData = [EVEN_HIGH,UNEVEN_HIGH,EVEN_LOW,UNEVEN_LOW];
    stdData = [EVEN_HIGH_SD,UNEVEN_HIGH_SD,EVEN_LOW_SD,UNEVEN_LOW_SD];

end