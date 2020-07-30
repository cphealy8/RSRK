clc; clear; close all;

%% Generate a point process to test
npts = 100; % No. of points
win = [0 1 0 1]; % window
winW = win(2)-win(1); % window width
winH = win(4)-win(3); % window height

%% Compute Ripley's K
% Impose a set scale vector (r), to match the output of kest in R.
rlen = 513;
rmin = 0;
rmax = 0.25;
r = linspace(rmin,rmax,rlen);
for n = 1:999
     [K(n,:),~,~,KP] = KPois(npts,win,r);
end

%% Compute the variance
close all
kvarMC = var(K,0,1); % Actual variance from a bunch of random distributions
kvarLS = kestVar(npts,win,r); % Theoretical variance

L = sqrt(K/pi); % L transform of K
LvarMC = var(L,0,1); % Variance after L - transform

LmR = L-r;

% Sorted Variance
Ksort = sort(K);         % Sorted version of K.
KMC5low = Ksort(25,:);    % 5th lowest value of K.
KMC5up = Ksort(end-24,:); % 5th highest value of K.

Lsort = sort(L);
LMC5low = Lsort(25,:);
LMC5up = Lsort(end-24,:);

LmRsort = sort(LmR);
LmR5low = LmRsort(25,:);
LmR5up = LmRsort(end-24,:);


% load the theoretical variance as computed in R. Note this will only match
% for a 1x1 window and 100 points.
load('kvarTR.mat')
lwd = 3;
csr = pi*r.^2;

% Just plot showing variance. 
figure
hold on
plot(r,kvarMC,'-k',r,kvarLS,'--r',r,kvarTR,':b','LineWidth',lwd)

hold off

xlabel('scale (r)')
ylabel('Lotwick Silverman Variance')
legend('Monte Carlo','My Lotwick-Silverman','R Lotwick-Silverman')
SDLS = 2*sqrt(kvarLS); % standard deviation.
SDMC = 2*sqrt(kvarMC); % Actual Standard Deviation
LSDMC = 2*sqrt(LvarMC); % Actual Standard deviation of L-transform

% SD at K
figure

hold on
plot(r,csr,'-k','LineWidth',lwd);
plot(r,csr+SDLS,'--r',r,csr-SDLS,'--r','LineWidth',lwd-1);
plot(r,csr+SDMC,':b',r,csr-SDMC,':b','LineWidth',lwd-1);
plot(r,KMC5up,'-.c',r,KMC5low,'-.c','LineWidth',lwd-1);
hold off
xlabel('Scale (r)')
ylabel('K(r)')
xlim([0 0.05])
legend('CSR','LS: K+','LS: K-','MC: K+','MC: K-','MCI: K+','MCI: K-')
grid on

% SD at L-transform
figure

hold on
plot(r,sqrt(csr/pi),'-k','LineWidth',lwd);
plot(r,sqrt((csr+SDLS)/pi),'--r',r,abs(sqrt((csr-SDLS)/pi)),'--r','LineWidth',lwd);
plot(r,sqrt((csr+SDMC)/pi),':b',r,abs(sqrt((csr-SDMC)/pi)),':b','LineWidth',lwd);
plot(r,r+LSDMC,':g',r,r-LSDMC,':g','LineWidth',lwd-1);
plot(r,sqrt(KMC5up/pi),'-.c',r,sqrt(KMC5low/pi),'-.c','LineWidth',lwd)
plot(r,LMC5up,'-.m',r,LMC5low,'-.m','LineWidth',lwd-1)
grid on
legend('CSR','LS: K+','LS: K-','MC: K+','MC: K-','MC: L+','MC: L-','MCI: K+','MCI: K-','MCI: L+','MCI: L-')
hold off
xlim([0 0.05])
xlabel('Scale (r)')
ylabel('L(r)')

% SD at L-r transform
figure
hold on
LrvarMC = var(sqrt(K/pi)-r,0,1); % Variance after L-r - transform
LrSDMC = 2*sqrt(LrvarMC);

plot(r,sqrt(csr/pi)-r,'-k','LineWidth',lwd)
plot(r,sqrt((csr+SDLS)/pi)-r,'--r',r,sqrt((csr-SDLS)/pi)-r,'--r','LineWidth',lwd)
plot(r,sqrt((csr+SDMC)/pi)-r,':b',r,sqrt((csr-SDMC)/pi)-r,':b','LineWidth',lwd)
plot(r,LrSDMC,'-.g',r,-LrSDMC,'-.g','LineWidth',lwd);
plot(r,sqrt(KMC5up/pi)-r,'-.c',r,sqrt(KMC5low/pi)-r,'-.c','LineWidth',lwd)
plot(r,LmR5up,'-.m',r,LmR5low,'-.m','LineWidth',lwd-1)
grid on
legend('CSR','LS: K+','LS: K-','MC: K+','MC: K-','MC: L-r +','MC: L-r -','MCI: K+','MCI: K-','MCI: L-r +','MCI: L-r -','Location','BestOutside')

xlim([0 0.05])

xlabel('Scale (r)')
ylabel('L(r)-r')
hold off  
%% Plot
figure
hold on

plot(r,sqrt(K(1,:)/pi)-r,'-r')
plot(r,sqrt(KP/pi)-r,'-k')
plot(r,sqrt((KP+SDLS)/pi)-r,'-g')
plot(r,-(sqrt((KP+SDLS)/pi)-r),'-g')

xlabel('scale (r)')
ylabel('L(r)-r')
