function [] = addX1(chi,color)
%     n=chi(4);
%     EC50=chi(3);
%     xStar = EC50*((n-1)./(n+1)).^(1./n);
    xStar = getX1(chi);
    x=0:(xStar/100):(2*xStar);
    yfit = H1(chi,x);
    
    [~,j]=find(x>=xStar,1);
    plot(xStar,yfit(j),'.','MarkerSize',40,'Color',color);
end