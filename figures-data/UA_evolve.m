function [ydot] = UA_evolve(t,y,x,b1,b2,ai,a0,kon)
    cU = y(1);
    cA = y(2);
    koff = y(3);

    % (doesn't include h)
    ydot(1,1) = (b1 - kon*(x))*cU + (koff*cA); %(unaffected)
    ydot(2,1) = (b2 - koff)*cA + (kon*(x)*cU); %(affected)
    ydot(3,1) = ai*koff;

    v=cU+cA;
    if (v>15)
        ydot(1,1) = 0;
        ydot(2,1) = 0;
    end
    
    % re-sensitization (koff decays) if no drug:
    if (x == 0)
        ydot(3,1) = -a0*koff;
    end
end