%% DIP = (log(nF) - log(n0))/log(2)
function [mkg,DIP_mean,DIP_std,DIP_all] = DIP0_data()

    [~,EH,UH,EL,UL] = getFirstCycleData();

    EH = log(EH)'; % rows are timepoints, cols are replicates
    UH = log(UH)';
    EL = log(EL)';
    UL = log(UL)';

    DIP_EH = (EH(2,:)-EH(1,:)) / log(2); % 25 mkg
    DIP_50 = (UH(2,:)-UH(1,:)) / log(2); % 50 mkg
    DIP_12 = (EL(2,:)-EL(1,:)) / log(2); % 12.5 mkg
    DIP_UL = (UL(2,:)-UL(1,:)) / log(2); % 25 mkg

    DIP_25 = [DIP_EH,DIP_UL];
  
    mkg = [0,12.5,25,50];
    DIPu=DIP_untreated();

    DIP_mean = [mean(DIPu),mean(DIP_12),mean(DIP_25),mean(DIP_50)];
    DIP_std = [std(DIPu),std(DIP_12),std(DIP_25),std(DIP_50)];


    DIP_all=zeros(16,length(mkg))*NaN;
    DIP_all(1:length(DIPu),1) = DIPu'; % 0 dose
    DIP_all(1:length(DIP_12),2) = DIP_12'; % 12.5 dose
    DIP_all(1:length(DIP_25),3) = DIP_25'; % 25 dose
    DIP_all(1:length(DIP_50),4) = DIP_50'; % 25 dose



end

%% get untreated data from excel sheet(i just copy/pasted here bc i'm lazy)
function [DIPu,tU,xU] = DIP_untreated()

    %% untreated data: (control):
    tU = [0,4,7,11,14,18,21]/7; % weeks
    
    xU = [100	100;
          143.60323	162.8332994;
          346.2280214	216.7311215;
          250.9769214	258.5732486;
          280.4750586	247.6490942;
          484.6609012	446.8145736;
          711.1970869	446.8145736];
    [~,a1]=getExpFit(tU,xU(:,1)');
    [~,a2]=getExpFit(tU,xU(:,2)');

    DIPu = [a1,a2]/log(2);
end

%% from BD31, because we don't have the full range of dose values in BD33:
function [tData,EH,UH,EL,UL] = getFirstCycleData()
    tData = 0:1:14; % only first 7 cycles    
    data = xlsread('/Users/4467383/Documents/DynamicDoseResponse/Xenographs/BD31/In-vivo study_2.xlsx','Tumor measurement','B103:AE119');

    data(7,:)=[];
    
    EH = (1/100)*data(:,1:8)';      EH = EH(:,1:length(tData));
    UH = (1/100)*data(:,9:16)';     UH = UH(:,1:length(tData));
    EL = (1/100)*data(:,17:22)';    EL = EL(:,1:length(tData));
    UL = (1/100)*data(:,23:30)';    UL = UL(:,1:length(tData));
end




