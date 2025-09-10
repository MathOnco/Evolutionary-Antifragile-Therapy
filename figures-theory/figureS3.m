clc;clear; close all;



y=-5:0.01:4;
x=10.^(y);

% parameters:
p = [100,20,10,2];

% %% linear (H1):
% figure(1); clf;
% H = H1(p,x);
% plot(x,H,'-k','LineWidth',3);
% set(gca,'XScale','log');
% clean();
% ylim([0 105]);
% xlim([10^(-5),1e4]);
% 
% % add the inflection point(p(3)):
% EC50_lin = p(3);
% [~,i]=find(x>=EC50_lin,1);
% plot(EC50_lin,H(i),'.r','MarkerSize',40);



%% log investigations:
figure(1); clf;
H = H2(p,y);

subplot(211);
plot(x,H,'-k','LineWidth',3);
set(gca,'XScale','log');
clean();

EC50=p(3);
[k,i]=find(x>=EC50,1);
plot(EC50,H(i),'.r','MarkerSize',40);

ylim([0 105]);
xlim([10^(-5),10^(4)]);

subplot(212);
plot(y,H,'-k','LineWidth',3); hold on;
clean();
EC50_log=log10(p(3));
[k,i]=find(y>=EC50_log,1);
plot(EC50_log,H(i),'.r','MarkerSize',40);
xlim([-5,4]);

subplot(211);xlabel('x');
subplot(212);xlabel('y');
% printPNG(figure(1),'./plots/supp_lin_log.png');

