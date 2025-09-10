function [xdot] = dose_ode(t,x,r,D,aOn,aOff)
    n=x(1);
    k=x(2);

    % exponential model, N-S
    xdot(1,1) = r*n*(1-(k*D));

    if (D>0)
        xdot(2,1) = -aOn*(k*D);
    else
        xdot(2,1) = aOff*(k);
    end    
end


% another option: force all the D's to be accurate, let each experiment
% have its own aOn / aOff