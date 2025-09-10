function [cfit,yfit,chi,model,resnorm, RESIDUAL] = GetHillFit(c,y)
%   Takes as input:
%       c - vector of dose (linear scale data)
%       y - vector of % survival (data)
%       % plotbool - would you like to plot on gcf?

if (c(1)==0)
    c=c(2:end);
    y=y(2:end);
end

opts = optimset('Display','off');

%% ORIGINAL SCHEME:
% lb_LOG = [0,   0,   -10,  -30];
% ub_LOG = [150, 150, 10, 0];
% model = @(c,x) c(2) - ((c(2) - c(1))./(1 + (10.^(x)/10.^(c(3))).^(-c(4))));
% guess = [100;0;1;0]; % initial guess

%% H2 SCHEME:
lb_LOG = [0,   0,   10^(-2),  0];
ub_LOG = [100, 100, 10^(6), 30];
model = @H2;
% H = ( (c(2) - c(1) ).* (10.^y).^c(4) ) ./ ( (10.^y).^c(4) + c(3).^c(4) ) + c(1);

guess = [100;0;1;0]; % initial guess


cfit = log10(c(1)):((log10(c(end))-log10(c(1)))/1000):log10(c(end));
c = log10(c);

R = 1e9;
chi = [];
yfit = [];



[chi, resnorm, RESIDUAL] = lsqcurvefit(model,guess,c,y,lb_LOG,ub_LOG,opts);
yfit = model(chi,cfit);
cfit = 10.^cfit;





end