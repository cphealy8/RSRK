clc; clear; close all;
addpath('Dependencies');

[FileName,LoadPath] = uigetfile('../data/Phantoms/*.mat','Select RK Data File');
load(strcat(LoadPath,FileName))

NormRK = NormalizeRK(RK{1});

lwd = 2;
plot(NormRK.r,NormRK.Obs,'-k','LineWidth',lwd);
hold on 
plot(NormRK.r,NormRK.Env(1,:),'--y','LineWidth',lwd);
plot(NormRK.r,NormRK.Env(2,:),':r','LineWidth',lwd);
plot(NormRK.r,NormRK.Env(3,:),':b','LineWidth',lwd);
plot(NormRK.r,NormRK.Env(4,:),'--g','LineWidth',lwd);
hold off
xlabel('Scale (r)');
ylabel('G(r)');
