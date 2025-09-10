clc;clear;close all;
green = [0,133,66]/255; purple = [112,48,160]/255;



% EH,UH,EL,UL
DOSE = [25,25; 
        50,0; 
        12.5,12.5; 
        25,0];

D1=DOSE(4,:);
D2=DOSE(3,:);

c = 0:1:7;
tvec = c*2;


cvec=0:1:7;

figure(1); clean();

colors = categoricalColors();
for c1 = cvec
    subplot(length(cvec),1,c1+1);
    c2 = cvec(end)-c1;

    T=2; % cycle time length
    [t,d]=constructDoseVec(c1,c2,D1,D2,T);
    
    dT0=T/2;
    s=dT0/100;
    for t0 = 1:length(t)
        x = t0:(dT0/10):(t0+dT0-s);
        y = zeros(1,length(x))+d(t0);
        
        h=area(x,y);hold on;
        h.FaceColor=colors(c1+1,:);
        h.EdgeColor='none';
    end
    xlim([0.25*T,t(end)+T*1.25])
    ylim([0,max(max([D1,D2]*1.2))]);
    
%     clean();

end

xlabel('time (weeks)');

if (D1(1)>D2(1))
    printPNG(figure(1),'plot/even_uneven.png');
else
    printPNG(figure(1),'plot/uneven_even.png');
end


function [t,d]=constructDoseVec(c1,c2,D1,D2,T)
    d=[];
    
    t=0:(T/2):((c1+c2)*2-1);
    for c = 1:1:c1
        d=[d,D1];
    end
    
    for c = 1:1:c2
        d=[d,D2];
    end
end


