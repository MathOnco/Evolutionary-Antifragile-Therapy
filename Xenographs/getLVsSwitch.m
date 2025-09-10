%% this needs to match data outputs:
function [yOut,tD,rOut,tF,yF,rF]=getLVsSwitch(p,nonsense,cycle_to_switch)
    even = [1,1];
    uneven = [1,0];

    % discrete cycle fnc expects:
    %     
    %     D=p(1);
    %     r=p(2);
    %     aOn=p(3);
    %     aOff = p(4);
    %
    % but p inputs: [D1,D2,D3,D4,r,aOn,aOff];
    p1 = [p(1),p(5:end)]; % even, high
    p2 = [p(2),p(5:end)]; % uneven, high
    p3 = [p(3),p(5:end)]; % even, low
    p4 = [p(4),p(5:end)]; % uneven, low

%     % even, high dose: [25,25]
%     [tD,xD1] = switchCycle(p1,p2,even,uneven,cycle_to_switch);
% 
%     % uneven, high dose: [50,0]
%     [~,xD2] = switchCycle(p2,p1,uneven,even,cycle_to_switch);
% 
%     % even, low dose: [12.5,12.5]
%     [~,xD3] = switchCycle(p3,p4,even,uneven,cycle_to_switch);
% 
%     % uneven, low dose: [25,0]
%     [~,xD4] = switchCycle(p4,p3,uneven,even,cycle_to_switch);



    %% compare even -> even to even -> uneven

%     % even, high dose: [25,25]
%     [tD,xD1,tF,xF1] = switchCycle(p1,p1,even,even,cycle_to_switch);
% 
%     % uneven, high dose: [50,0]
%     [~,xD2,~,xF2] = switchCycle(p1,p2,even,uneven,cycle_to_switch);


    % even, low dose: 
    [tD,xD1,tF,xF1] = switchCycle(p4,p3,uneven,even,cycle_to_switch);

    % uneven, low dose: 
    [~,xD2,~,xF2] = switchCycle(p4,p4,uneven,uneven,cycle_to_switch);

    % even, low dose: [12.5,12.5]
    [~,xD3,~,xF3] = switchCycle(p3,p3,even,even,cycle_to_switch);

    % uneven, low dose: [25,0]
    [~,xD4,~,xF4] = switchCycle(p3,p4,even,uneven,cycle_to_switch);





    % match only size, not resistance:
    yOut = [xD1(:,1),xD2(:,1),xD3(:,1),xD4(:,1)];
    rOut = [xD1(:,2),xD2(:,2),xD3(:,2),xD4(:,2)];

    % full time series (not just data points):
    yF = [xF1(:,1),xF2(:,1),xF3(:,1),xF4(:,1)];
    rF = [xF1(:,2),xF2(:,2),xF3(:,2),xF4(:,2)];


end