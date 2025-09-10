function [FEH,FUH,FEL,FUL] = F(p,x,k,tvec)
% p = [d_EH, d_UH, dEL, dUL, r, aOn, aOff]
even = [1,1];
uneven = [1,0];

% x: rows are time points, cols are exp's
d_EH=p(1);
d_UH=p(2);
d_EL=p(3);
d_UL=p(4);
r=p(5);
aOn = p(6);
aOff = p(7);

% xdot = dose_ode(t,x,r,D,aOn,aOff)

% initial conditions:
i=1;





% but p inputs: [D1,D2,D3,D4,r,aOn,aOff];
p1 = [p(1),p(5:end)]; % even, high
p2 = [p(2),p(5:end)]; % uneven, high
p3 = [p(3),p(5:end)]; % even, low
p4 = [p(4),p(5:end)]; % uneven, low

i = 1;

FEH=[0];
FUH=[0];
FEL=[0];
FUL=[0];

t = 2:2:12;
i=1;
for c = 1:1:6

    j = (c-1)*2 + 1;

%     xHE = x(i,2); 
%     xHU = x(i,1); % first col (uneven, high dose)
%     kEH = k(i,2); % second col (even, high dose)
%     kUH = k(i,1); % first col (uneven, high dose)
%     
%     xLE = x(i,4); % second col (even, high dose)
%     xLU = x(i,3); % first col (uneven, high dose)
%     kEL = k(i,4); % second col (even, high dose)
%     kUL = k(i,3); % first col (uneven, high dose)

    % high dose only:
    x0_E = [x(j,2),k(j,2)]; % second col (even, high dose)
    x0_U = [x(j,1),k(j,1)]; % second col (even, high dose)
    
    % FEH:
    [~,xD1] = discreteCycle2(p1,even,x0_E);
    [~,xD2] = discreteCycle2(p2,uneven,x0_E);
    FEH(i+1)=xD2(end,1)-xD1(end,1);

    % FUH:
    [~,xD1] = discreteCycle2(p1,even,x0_U);
    [~,xD2] = discreteCycle2(p2,uneven,x0_U);
    FUH(i+1)=xD2(end,1)-xD1(end,1);

    % low dose:
    x0_E = [x(j,4),k(j,4)]; % second col (even, high dose)
    x0_U = [x(j,3),k(j,3)]; % second col (even, high dose)
    
    % FEL:
    [~,xD1] = discreteCycle2(p3,even,x0_E);
    [~,xD2] = discreteCycle2(p4,uneven,x0_E);
    FEL(i+1)=xD2(end,1)-xD1(end,1);

    % FUL:
    [~,xD1] = discreteCycle2(p3,even,x0_U);
    [~,xD2] = discreteCycle2(p4,uneven,x0_U);
    FUL(i+1)=xD2(end,1)-xD1(end,1);

    i=i+1;

end


% FE = [];
% FU = [];
% 

%     %% high dose case:
%     xHE = x(i,2); % second col (even, high dose)
%     xHU = x(i,1); % first col (uneven, high dose)
%     kE = k(i,2); % second col (even, high dose)
%     kU = k(i,1); % first col (uneven, high dose)
% 
%     %for uneven, use the same x(t), k(t), but different dosing.
%     evenXDot = dose_ode(0, [xHE,kE], r, d_EH  ,aOn, aOff);
%     highXdot = dose_ode(0, [xHE,kE], r, d_UH  ,aOn, aOff);
%     lowXdot = dose_ode(0,  [xHE,kE], r, 0     ,aOn, aOff);
% 
%     FEH(i) = (highXdot(1)+lowXdot(1))./2 - evenXDot(1);
% 
%     
%     %for uneven, use the same x(t), k(t), but different dosing.
%     evenXDot = dose_ode(0, [xHU,kU], r, d_EH  ,aOn, aOff);
%     highXdot = dose_ode(0, [xHU,kU], r, d_UH  ,aOn, aOff);
%     lowXdot = dose_ode(0,  [xHU,kU], r, 0     ,aOn, aOff);
% 
%     FUH(i) = (highXdot(1)+lowXdot(1))./2 - evenXDot(1);
% 
% 
%     %% low dose case:
%     xLE = x(i,4); % second col (even, high dose)
%     xLU = x(i,3); % first col (uneven, high dose)
%     kE = k(i,4); % second col (even, high dose)
%     kU = k(i,3); % first col (uneven, high dose)
% 
%     %for uneven, use the same x(t), k(t), but different dosing.
%     evenXDot = dose_ode(0, [xLE,kE], r, d_EL  ,aOn, aOff);
%     highXdot = dose_ode(0, [xLE,kE], r, d_UL  ,aOn, aOff);
%     lowXdot = dose_ode(0,  [xLE,kE], r, 0     ,aOn, aOff);
% 
%     FEL(i) = (highXdot(1)+lowXdot(1))./2 - evenXDot(1);
% 
%     
%     %for uneven, use the same x(t), k(t), but different dosing.
%     evenXDot = dose_ode(0, [xLU,kU], r, d_EL  ,aOn, aOff);
%     highXdot = dose_ode(0, [xLU,kU], r, d_UL  ,aOn, aOff);
%     lowXdot = dose_ode(0,  [xLU,kU], r, 0     ,aOn, aOff);
% 
%     FUL(i) = (highXdot(1)+lowXdot(1))./2 - evenXDot(1);
% 
% 
%     i = i+1;
% 
% end



end



%% function to get full cycle
% full t, x
% discrete tD, xD
function [tD,xD] = discreteCycle2(p,dose,x0) % dose is either [1,0] (uneven) or [1,1] (even)

    D=p(1);
    r=p(2);
    aOn=p(3);
    aOff = p(4);


    T=2;
    tSpan = [0 T/2];
    tD=[0];xD=[x0];
    tF=[];xF=[];

    % treated
    d1 = dose(1)*D;
    [tp,y] = ode45(@(t,y) dose_ode(t,y,r,d1,aOn,aOff),tSpan,x0);
    x0 = y(end,:); 
    tSpan = [tp(end),tp(end)+T/2];
    tD=[tD;tp(end)]; xD = [xD;x0];

    % untreated (both D and alpha = 0)
    d2 = dose(2)*D;
    [tp,y] = ode45(@(t,y) dose_ode(t,y,r,d2,aOn,aOff),tSpan,x0);
    x0 = y(end,:);
    tD=[tD;tp(end)]; xD = [xD;x0];

end


