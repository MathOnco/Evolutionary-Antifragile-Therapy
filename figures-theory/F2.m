function [F] = F2(y,h,p) 
    F=0.5.* ( H2(p,y+h)+H2(p,y-h)-2.*H2(p,y) ) ;
end