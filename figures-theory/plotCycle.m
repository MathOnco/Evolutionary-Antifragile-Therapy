function [] = plotCycle(xBar,sigma, color, yT)
green = [0,133,66]/255; purple = [112,48,160]/255;

NCYCLES = 7;
dT0 = 1;
s=dT0/100;
L = 0.5;

x1=xBar+sigma;
x2=xBar-sigma;


plot([-0.5,NCYCLES+1.5],[xBar,xBar],':k','LineWidth',3); hold on;
for cycle = 0:NCYCLES
dose = x2;
dT=L*dT0*2;
if (mod(cycle,2)==0)
    dose = x1;
    dT=(1-L)*dT0*2;
end
    
t0 = cycle;
x = t0:(dT/10):(t0+dT-s);
y = zeros(1,length(x))+dose;

h=area(x,y);hold on;
h.FaceColor=color;
h.EdgeColor=[0,0,0];
h.LineWidth=2;

end

ylim([0,yT]);
xlim([-0.5,cycle+1.5]);
set(gca,'XTickLabel',[]);
clean(); hold on;

end

