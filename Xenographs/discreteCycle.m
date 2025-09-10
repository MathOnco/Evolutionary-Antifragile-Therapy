%% function to get full cycle
% full t, x
% discrete tD, xD
function [tD,xD,tF,xF] = discreteCycle(p,dose) % dose is either [1,0] (uneven) or [1,1] (even)

    D=p(1);
    r=p(2);
    aOn=p(3);
    aOff = p(4);

    x0 = [1,1]; % set k0=1;

    T=2;
    cycles = 6;
    tSpan = [0 T/2];
    tD=[0];xD=[x0];
    tF=[];xF=[];

    for cycle = 1:1:cycles
    
        % treated
        d1 = dose(1)*D;
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r,d1,aOn,aOff),tSpan,x0);
        x0 = y(end,:); 
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];
    
        % untreated
        d2 = dose(2)*D;
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r,d2,aOn,aOff),tSpan,x0);
        x0 = y(end,:);
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];
    end

end