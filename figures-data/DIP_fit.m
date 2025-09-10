function [pFit] = DIP_fit(mkg,vals)

    %% model 1: full model, except h
    h=1;
    model1 = @(p,x) (1/log(2)) .* (p(3)*p(1) + (x.^h).*p(2)) ./ (p(3)+(x.^h));
    
    %% find best fit:
    guess = rand(3,1);
    [pFit, resnorm1, RESIDUAL] = lsqcurvefit(model1,guess,mkg,vals);

end