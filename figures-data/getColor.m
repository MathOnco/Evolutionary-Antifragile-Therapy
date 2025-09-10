function [c]=getColor()
    load("save/x.mat");
    load("save/BD.mat"); % loads BD

    if (BD == 31)
        if ((x(1) == 25) && (x(2) == 0) )
            c=green();
        elseif ((x(1) == 25) && (x(2) == 25) )
            c=purple();
        elseif ((x(1) == 12.5) && (x(2) == 12.5) )
            c=purple();
        elseif ((x(1) == 50) && (x(2) == 0) )
            c=green();
        end
        
    else
        if ( (x(1) == 25) && (x(2) == 25) && (x(3) == 25) && (x(4) == 25) )
            c=purple();
        elseif ( (x(1) == 25) && (x(2) == 25) && (x(3) == 50) && (x(4) == 0) )
            c=red();
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 25) && (x(4) == 25) )
            c=blue();
        elseif ( (x(1) == 50) && (x(2) == 0) && (x(3) == 50) && (x(4) == 0) )
            c=green();
        end
    end

end