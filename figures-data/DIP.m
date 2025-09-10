%% this is only accurate for high values of kon, koff (i think)
% otherwise, you should simulate numerically
function [dip] = DIP(koff_kon,b1,b2,d)
    scalar = 1/log(2); % ln(2)
    dip = scalar .* (koff_kon*b1 + d.*b2) ./ (koff_kon+d);
end