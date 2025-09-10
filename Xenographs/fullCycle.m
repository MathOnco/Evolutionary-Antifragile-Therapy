%% function to get full cycle
% full t, x
% discrete tD, xD
function [t,x,tD,xD] = fullCycle(cycles,T,r,D,alpha,K,x0)
    t=[];x=[];tSpan = [0 T/2];
    tD=[0];xD=[x0];

    for cycle = 1:1:cycles
    
        % treated
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r,D(1),alpha,K),tSpan,x0);%,optionsRECIST);
        x0 = y(end,:); 
        t=[t;tp];x=[x;y];
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;t(end)]; xD = [xD;x0];
    
        % untreated (both D and alpha = 0)
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r,D(2),alpha,K),tSpan,x0);%,optionsRECIST);
        x0 = y(end,:);
        t=[t;tp];x=[x;y];
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;t(end)]; xD = [xD;x0];

    end

end