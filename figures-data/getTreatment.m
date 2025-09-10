function [tData,T] = getTreatment(index)    
    tData = 0:1:19;
    tData = tData';
    
    T = xlsread('/Users/4467383/Documents/GitHub/DynamicDoseResponse/Xenographs/BD33/In-vivo_switching.xlsx','Treatment','B5:E24');
       

    if (index == 4)
        ti = 15; 
    else
        ti = length(tData);
    end

    tData = tData(1:ti);
    T = T(1:ti,index);

    labels = {'Even-Even','Even-Uneven','Uneven-Even','Uneven-Uneven'};
    experiment = labels{index}

end