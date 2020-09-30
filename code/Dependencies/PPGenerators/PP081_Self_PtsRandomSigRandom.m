% Bivariate PP
PP01_RandomHomogenous % load baseline PP

PPName = 'Self - Random Homogenous'; % metadata

% pts = PoissonPP(win,npts);
SelfSignalGenerator

PP01_RandomHomogenous % load baseline PP
pts = pts.*imRez;

% imagesc(Signal);
% hold on
% plot(pts(:,1),pts(:,2),'.r')