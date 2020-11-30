clc; clear; close all;
cnt = 0;
while 1
    cnt = cnt+1;
    
    [DatFile{cnt},DatPath]= uigetfile('../../data/*mat','Select RRK Data File');
    filepath{cnt} = fullfile(DatPath,DatFile{cnt});
    if DatFile{cnt}==0
        cnt = cnt-1;
        break
    end
    
    % Load and plot results of RRK analysis
    load(filepath{cnt});
    if isstruct(CortFrac)
        MarrowFrac.mpsd = MarrowFrac.mean+MarrowFrac.sem;
        TrabFrac.mpsd = TrabFrac.mean+TrabFrac.sem;
        CortFrac.mpsd = CortFrac.mean+CortFrac.sem;
        CellDensity.mpsd = CellDensity.mean+CellDensity.sem;

        MarrowFrac.mmsd = MarrowFrac.mean-MarrowFrac.sem;
        TrabFrac.mmsd = TrabFrac.mean-TrabFrac.sem;
        CortFrac.mmsd = CortFrac.mean-CortFrac.sem;
        CellDensity.mmsd = CellDensity.mean-CellDensity.sem;

        miny1(cnt)= min([MarrowFrac.mmsd TrabFrac.mmsd CortFrac.mmsd]);
        maxy1(cnt)= max([MarrowFrac.mpsd TrabFrac.mpsd CortFrac.mpsd]);
        miny2(cnt)= min(CellDensity.mmsd);
        maxy2(cnt)= max(CellDensity.mpsd);
    else
        miny1(cnt) = min([MarrowFrac TrabFrac CortFrac]);
        maxy1(cnt) = max([MarrowFrac TrabFrac CortFrac]);
        miny2(cnt) = min(CellDensity);
        maxy2(cnt) = max(CellDensity);
    end
end

% lim = max(abs([miny1 maxy1]));
% cLims = [-lim lim]
y1lims =[0 max(maxy1)];
y2lims = [0 max(maxy2)]*1e6;

for k = 1:cnt
fH = figure('Units','centimeters','Position',[1 1 9.5 6.5]);
lwd = 1.5;

load(filepath{k});

if isstruct(CortFrac)
    yyaxis left
    errorbar(Frame,MarrowFrac.mean,MarrowFrac.sem,'LineWidth',lwd,'CapSize',5)
    hold on
    errorbar(Frame,CortFrac.mean,CortFrac.sem,'LineWidth',lwd,'CapSize',5)
    errorbar(Frame,TrabFrac.mean,TrabFrac.sem,'LineWidth',lwd,'CapSize',5)
    xlabel('Frame Position (%)')
    ylabel('Area Fraction');
    ylim(y1lims)
    fdiff = Frame(2)-Frame(1);
    xlim([Frame(1)-fdiff/2 Frame(end)+fdiff/2])

    yyaxis right
    errorbar(Frame,CellDensity.mean*1e6,CellDensity.sem*1e6,'LineWidth',lwd,'CapSize',5)
    ylabel('Cells/{mm^2}')
    ylim(y2lims)
else
    yyaxis left
    plot(Frame,MarrowFrac,'LineWidth',lwd)
    hold on
    plot(Frame,CortFrac,'LineWidth',lwd)
    plot(Frame,TrabFrac,'LineWIdth',lwd)
    xlabel('Frame Position (%)')
    ylabel('Area Fraction')
    ylim(y1lims)
    fdiff = Frame(2)-Frame(1);
    xlim([Frame(1)-fdiff/2 Frame(end)+fdiff/2])
    yyaxis right
    plot(Frame,CellDensity*1e6,'LineWidth',lwd)
    ylabel('Cells/{mm^2}')
    ylim(y2lims)
end

legend('Marrow','Cortical Bone','Trabecular Bone','MK','Location','best')

fH.Units = 'Centimeters';
fH.Position = [1 1 9.5 4.0];

SaveDir = '..\..\results\Extras';
SaveFile = DatFile{k}(1:end-4);
SaveName = fullfile(SaveDir, SaveFile);
saveas(fH,SaveName,'pdf')
print(fH,SaveName,'-dpng');

close all
end