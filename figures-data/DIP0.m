
function [pFit,mkg,DIP_mean,DIP_std,DIP_all] = DIP0() 

    [mkg,DIP_mean,DIP_std,DIP_all] = DIP0_data();
    
    %% model 1: full model, except h
    h=1;
    model1 = @(p,x) (1/log(2)) .* (p(3)*p(1) + (x.^h).*p(2)) ./ (p(3)+(x.^h));
    
    %% find best fit:
    guess = rand(3,1);
    [pFit, resnorm1, RESIDUAL] = lsqcurvefit(model1,guess,mkg,DIP_mean);    
    pFit=[pFit',1-resnorm1];

end