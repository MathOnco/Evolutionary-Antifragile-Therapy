function [F] = F1(x,h,p)
    HIGH_DOSE = x+h;
    LOW_DOSE = x-h;
    
    % ensure we aren't considering negative doses:
    [~,i]=find(LOW_DOSE<0);    
    LOW_DOSE(i) = NaN;
    HIGH_DOSE(i) = NaN;
    x(i) = NaN;
    
    % calculate fragility:
    F=0.5.*( H1(p,HIGH_DOSE)+H1(p,LOW_DOSE)-2.*H1(p,x) ) ;
end