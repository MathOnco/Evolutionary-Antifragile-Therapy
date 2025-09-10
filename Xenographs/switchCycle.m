%% function to get full cycle
% full t, x
% discrete tD, xD
% dose is either [1,0] (uneven) or [1,1] (even)
function [tD,xD,tF,xF] = switchCycle(p1,p2,dose1,dose2,cycle_to_switch) 

    D1=p1(1);
    r1=p1(2);
    aOn1=p1(3);
    aOff1=p1(4)

    D2=p2(1);
    r2=p2(2);
    aOn2=p2(3);
    aOff2=p2(4)

    x0 = [1,1]; % set k0=1;

    T=2;
    cycles = 7;
    tSpan = [0 T/2];
    tD=[0];xD=[x0];
    tF=[];xF=[];

    % first half

    for cycle = 1:1:cycle_to_switch
    
        % treated
        d1 = dose1(1)*D1;
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r1,d1,aOn1,aOff1),tSpan,x0);
        x0 = y(end,:); 
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];

        % untreated (both D and alpha = 0)
        d2 = dose1(2)*D1;
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r1,d2,aOn1,aOff1),tSpan,x0);
        x0 = y(end,:);
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];

    end

    %% THIS IS A HACK< CHANGE THIS LATER.
    

    if (dose1 == dose2)

    else
            even = [1,1];

        if (dose2 == even)
            x0 = [x0(1),0.5]; % set k0=1;
        else 
            x0 = [x0(1),1]; % set k0=1;
        end
    end


    % second half
    for cycle = (cycle_to_switch+1):1:cycles
    
        % treated
        d1 = dose2(1)*D2;
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r2,d1,aOn2,aOff2),tSpan,x0);
        x0 = y(end,:); 
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];

        % untreated (both D and alpha = 0)
        d2 = dose2(2)*D2;
        [tp,y] = ode45(@(t,y) dose_ode(t,y,r2,d2,aOn2,aOff2),tSpan,x0);
        x0 = y(end,:);
        tSpan = [tp(end),tp(end)+T/2];
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];

    end

end