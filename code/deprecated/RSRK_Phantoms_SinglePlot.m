clc; clear; close all;
addpath('Dependencies');

[FileName,LoadPath] = uigetfile('../data/Phantoms/*.mat','Select RK Data File');

load(strcat(LoadPath,FileName))

NormRK = NormalizeRK(RK{1});

upss = NormRK.Env(2,:);
ups = NormRK.Env(1,:);
lows = NormRK.Env(4,:);
lowss = NormRK.Env(3,:);
G = NormRK.Obs;

tRK = table(r',G',upss',ups',lows',lowss');
tRK.Properties.VariableNames ={'r','G','upss','ups','lows','lowss'};

lwd = 2;
f1=figure;
plot(NormRK.r,NormRK.Obs,'-k','LineWidth',lwd);
hold on 
plot(NormRK.r,NormRK.Env(1,:),'-y','LineWidth',lwd);
plot(NormRK.r,NormRK.Env(2,:),'-r','LineWidth',lwd);
plot(NormRK.r,NormRK.Env(3,:),'-b','LineWidth',lwd);
plot(NormRK.r,NormRK.Env(4,:),'-g','LineWidth',lwd);
hold off
xlabel('Scale (r)');
ylabel('G(r)');
axis tight
axis square


saveas(f1,strcat(LoadPath,FileName(1:end-4),'_Graph'),'epsc')
writetable(tRK,strcat(LoadPath,FileName(1:end-4),'_Table','.xlsx'))

combo = [G;upss;ups;lows;lowss];


floor(min(combo(:)))
ceil(max(combo(:)))
