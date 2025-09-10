% identical to getDiscreteModelData, but using the "true" dosing schedule
% (does NOT add the sensitivity testing breaks, and completes the full
% cycle of tData

% must save desired tData first
function [tD,yD,tF,xF,yS,k_off,kD] = getDiscreteTrueModelData(alpha,x,cycles)

    load("save/doseFit.mat");
    load("save/tData.mat");

    %% if actual:
%     load("save/x.mat");
%     [tData,xData] = getMouse(x,1);
%     D = getDosingSchedule();


    D = getTrueDosingSchedule();
    

    % fixed parameters:
    % this comes from fitting dose response in time point 0:
    b1 = doseFit(1);
    b2 = doseFit(2);
    koff_kon = doseFit(3);

    %% now we set kon, fit koff(t)
    kon = 5/koff_kon; % set koff \approx 0.5
    k0 = koff_kon *kon; %koff(t=0)    

    a0 = alpha(1);

    % initial condition:
    x0 = [1,0,k0];

    % tracking vectors etc:
    T=2;
    tspan = [0 T/2];
    tD=[0];xD=[x0];
    tF=[];xF=[];

    mkg = [0,12.5,25,50];

    d_i = 1;

    for cycle = 1:1:cycles

        if (length(tData)>d_i)
            % treated (was x(1))
            alpha_index = find(D(d_i)==mkg,1);
            [tp,y] = ode45(@(t,y) UA_evolve(t,y,D(d_i),b1,b2,alpha(alpha_index),a0,kon),tspan,x0);
            x0 = y(end,:); 
            tspan = [tp(end),tp(end)+T/2];
            tD=[tD;tp(end)]; xD = [xD;x0];
            tF=[tF;tp]; xF = [xF;y];
            d_i = d_i + 1;
        end

        % check twice in case animal was sac'd on an odd week
        if (length(tData)>d_i)
            % untreated  (was x(2))
            alpha_index = find(D(d_i)==mkg,1); % alpha(alpha_index) won't be used if D(d_i) == 0, anyway.
            [tp,y] = ode45(@(t,y) UA_evolve(t,y,D(d_i),b1,b2,alpha(alpha_index),a0,kon),tspan,x0);
            x0 = y(end,:);
            tspan = [tp(end),tp(end)+T/2];
            tD=[tD;tp(end)]; xD = [xD;x0];
            tF=[tF;tp]; xF = [xF;y];
            d_i = d_i + 1;
        end

        
    end

    yS = xF(:,1)+xF(:,2);
    yD = xD(:,1)+xD(:,2); % sum c1 + c2
    kD = xD(:,3);
    k_off = xF(:,3);

    if (length(yS)>1000)
        ind=round(length(yS)/1000);
        yS = yS(1:ind:end);
        tF = tF(1:ind:end);
        xF = xF(1:ind:end,:);
        k_off = k_off(1:ind:end);
    end

end