%% get full time course of dosing schedule, based on "x" which is length 2 or 4
function [D] = getTrueDosingSchedule()
    load("save/x.mat");
    load("save/cycles.mat");
    load("save/BD.mat"); % loads BD
    load("save/tData.mat");

    %% BD 31 is the same as actual
    if (BD == 31)
        data = xlsread('/Users/4467383/Documents/DynamicDoseResponse/Xenographs/BD31/In-vivo study_2.xlsx','Tumor measurement','AG103:AJ119');

        if ((x(1) == 25) && (x(2) == 0) )
            D=data(:,4)';
        elseif ((x(1) == 25) && (x(2) == 25) )
            D=data(:,1)';
        elseif ((x(1) == 12.5) && (x(2) == 12.5) )
            D=data(:,3)';
        elseif ((x(1) == 50) && (x(2) == 0) )
            D=data(:,2)';
        end
        
    else
        data = xlsread('/Users/4467383/Documents/DynamicDoseResponse/Xenographs/BD33/In-vivo_switching.xlsx','Treatment','AU5:AX44');

        if ( (x(1) == 25) && (x(2) == 25) && (x(3) == 25) && (x(4) == 25) )
            D=data(:,1)';
        elseif ( (x(1) == 25) && (x(2) == 25) && (x(3) == 50) && (x(4) == 0) )
            D=data(:,2)';
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 25) && (x(4) == 25) )
            D=data(:,3)';
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 50) && (x(4) == 0) )
            D=data(:,4)';
        end
    end

    D = D(1:length(tData)-1);
end