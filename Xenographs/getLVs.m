%% this needs to match data outputs:
function [yOut,tD,rOut,tF,yF,rF]=getLVs(p,nonsense)
    even = [1,1];
    uneven = [1,0];

%     p = [d_EH, d_UH, dEL, dUL, r, aOn, aOff]

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

    % even, high dose: [25,25]
    [tD,xD1,tF,xF1] = discreteCycle(p1,even);

    % uneven, high dose: [50,0]
    [~,xD2,~,xF2] = discreteCycle(p2,uneven);

    % even, low dose: [12.5,12.5]
    [~,xD3,~,xF3] = discreteCycle(p3,even);

    % uneven, low dose: [25,0]
    [~,xD4,~,xF4] = discreteCycle(p4,uneven);

    % match only size, not resistance:
    yOut = [xD1(:,1),xD2(:,1),xD3(:,1),xD4(:,1)];
    rOut = [xD1(:,2),xD2(:,2),xD3(:,2),xD4(:,2)];

    % full time series (not just data points):
    yF = [xF1(:,1),xF2(:,1),xF3(:,1),xF4(:,1)];
    rF = [xF1(:,2),xF2(:,2),xF3(:,2),xF4(:,2)];


end