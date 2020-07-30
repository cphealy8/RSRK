clc; clear; close all;

%% Generate a point process to test
n = 100; % No. of points
m = 50; % No. of other points

win = [0 1 0 1]; % window
winW = win(2)-win(1); % window width
winH = win(4)-win(3); % window height

for k = 1:1000
npts = rand(n,2).*[winW winH]; % A random point process
mpts = rand(m,2).*[winW winH]; % Another random point process

%% Compute Ripley's K
% Impose a set scale vector (r), to match the output of kest in R.

[K(k,:),r,L,KP,LP] = Kmulti(npts,mpts,win);
end


%% Compute the variance
close all;
kvarA = var(K,0,1); % Actual variance from a bunch of random distributions

kvarT = kestVar([n m],win,r);


figure
plot(r,kvarA,':k',r,kvarT,'-r','LineWidth',2)
xlabel('scale (r)')
ylabel('Bivariate Lotwick Silverman Variance')
legend('Actual','Theoretical')
SDT = abs(sqrt(kvarT)); % standard deviation
SDA = abs(sqrt(kvarA));
xlim([0 0.25])

% Plot
figure
hold on


plot(r,sqrt((KP+SDT)/pi)-r,'-r','LineWidth',2)
plot(r,sqrt((KP+SDA)/pi)-r,':k','LineWidth',2)
plot(r,-(sqrt((KP+SDT)/pi)-r),'-r','LineWidth',2)
plot(r,-(sqrt((KP+SDA)/pi)-r),':k','LineWidth',2)
hold off
legend('Theoretical','Actual')

xlabel('scale (r)')
ylabel('L(r)-r')

xlim([0 0.25])