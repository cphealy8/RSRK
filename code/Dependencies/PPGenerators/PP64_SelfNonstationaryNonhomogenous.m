% Bivariate PP
PP19_NonStationaryParallelNonhomogenousParallel% load baseline PP

PPName = 'Self Nonstationary - Nonhomogenous'; % metadata

SelfSignalGenerator

imagesc(Signal)
hold on
plot(pts(:,1),pts(:,2),'.r')