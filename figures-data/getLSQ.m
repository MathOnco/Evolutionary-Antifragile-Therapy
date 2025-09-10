%% individual fit:
function [yOut,tD]=getLSQ(p,nonsense)
    load("save/x.mat");
    load("save/cycles.mat");
    p
    [tD,yOut] = getDiscreteModelData(p,x,cycles); % replace with tData
end