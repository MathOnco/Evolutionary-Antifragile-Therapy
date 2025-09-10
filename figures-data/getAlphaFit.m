% upside-down Hill function
function [xfit,Hfit,pFit,model,resnorm, RESIDUAL] = getAlphaFit(x,A)
%   Takes as input:
%       c - vector of dose (linear scale data)
%       y - vector of % survival (data)


%% model 1: full model, except h
h=1;
model = @(p,x) (1/log(2)) .* (p(3)*p(1) + (x.^h).*p(2)) ./ (p(3)+(x.^h));

xfit = x(1):((x(end)-x(1))/1000):x(end);

guess = [0;1;1]; % initial guess

%% find best fit:
guess = rand(3,1);
[pFit, resnorm, RESIDUAL] = lsqcurvefit(model,guess,x,A);    
% pFit=[pFit',1-resnorm1];

Hfit = model(pFit,xfit);

end