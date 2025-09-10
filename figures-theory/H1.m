function [H] = H1(c,x)
%     x=max(x,0);
    H= ( (c(2) - c(1) )*x.^c(4) ) ./ ( x.^c(4) + c(3).^c(4) ) + c(1);
end