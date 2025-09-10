function [r2]=getRsquared(yMeasured, yFit) % yMeasured, yFit (expected column vectors)
%     num=(yMeasured-yFit).^2;
%     den=(yMeasured-mean(yMeasured)).^2;
%     r2=1-sum(num)/sum(den);
% 
% 
%     ss_res = sum((yMeasured-yFit).^2)
%     ss_tot = sum((yMeasured-mean(yMeasured)).^2)
%     r2 = 1 - ss_res / ss_tot;

    R = corrcoef(yMeasured,yFit);
    r2= R(2,1)*R(2,1);
end