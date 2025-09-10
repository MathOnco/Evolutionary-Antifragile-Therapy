% get discrete model data
function [tD,yD,tF,xF,yS,koffvec] = getDiscreteSwitchingData(p1,p2,D1,D2,cycles1,cycles2)

    load("save/doseFit.mat");
    %load("save/tData.mat");

    %D = getDosingSchedule();

    % fixed parameters:
    % this comes from fitting dose response in time point 0:
    b1 = doseFit(1);
    b2 = doseFit(2);
    koff_kon = doseFit(3);

    %% now we set kon, fit koff(t)
    kon = 5/koff_kon; % set koff \approx 0.5
    k0 = koff_kon *kon; %koff(t=0)    

    % initial condition:
    x0 = [1,0,k0];

    % tracking vectors etc:
    T=2;
    
    tspanPRIME = 0:(T/100):(T/2);
    tspan = tspanPRIME;%[0 T/2];
    tD=[0];xD=[x0];
    tF=[];xF=[];
    

    %% first round of cycles:

    % free parameters: p=[a0,ai]
    a0 = p1(1);
    ai = p1(2);

    for cycle = 1:1:cycles1
        % treated
        [tp,y] = ode45(@(t,y) UA_evolve(t,y,D1(1),b1,b2,ai,a0,kon),tspan,x0);

        x0 = y(end,:); 
        tspan = tp(end) + tspanPRIME;
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];
    
        % untreated
        [tp,y] = ode45(@(t,y) UA_evolve(t,y,D1(2),b1,b2,ai,a0,kon),tspan,x0);
        x0 = y(end,:);
        tspan = tp(end) + tspanPRIME;


        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];
    end

    %% second round of cycles:

    k1 = xF(end,3);


    % free parameters: p=[a0,ai]
    a0 = p2(1);
    ai = p2(2);

    % initial condition, from previous
%     x0 = [1,0,k0];

    for cycle = 1:1:cycles2
        % treated
        [tp,y] = ode45(@(t,y) UA_evolve(t,y,D2(1),b1,b2,ai,a0,kon),tspan,x0);
        x0 = y(end,:); 
        tspan = tp(end) + tspanPRIME;
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];
    
        % untreated
        [tp,y] = ode45(@(t,y) UA_evolve(t,y,D2(2),b1,b2,ai,a0,kon),tspan,x0);
        x0 = y(end,:);
        tspan = tp(end) + tspanPRIME;
        tD=[tD;tp(end)]; xD = [xD;x0];
        tF=[tF;tp]; xF = [xF;y];
    end

    k2 = xF(end,3);
    koffvec = [k0,k1,k2];



    %% export data:
    yS = xF(:,1)+xF(:,2);
    yD = xD(:,1)+xD(:,2); % sum c1 + c2

end



% function [ydot] = UA_evolve2(t,y,x,b1,b2,ai,a0,koff)
%     cU = y(1);
%     cA = y(2);
%     kon = y(3);
% 
%     % (doesn't include h)
%     ydot(1,1) = (b1 - kon*(x))*cU + (koff*cA); %(unaffected)
%     ydot(2,1) = (b2 - koff)*cA + (kon*(x)*cU); %(affected)
%     ydot(3,1) = -ai*kon; % kon
% 
%     % re-sensitization if no drug:
%     if (x == 0)
%         ydot(3,1) = a0*kon; % kon;
%     end
% end

