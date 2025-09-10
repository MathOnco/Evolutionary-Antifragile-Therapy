function [xStar] = getX1(chi)
    EC50=chi(3);
    n=chi(4);
    xStar = EC50*((n-1)./(n+1)).^(1./n);
end