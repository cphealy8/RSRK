function [CombinedRK,CombinedX] = CombineRKSamples(varargin)
%COMBINERKSAMPLES Combine individual RK sample structures into a single
%structure.
%   CombinedRK = COMBINERKSAMPLES prompts the user to select succesive RK
%   Sample files and returns a single structure.
%
%   CombinedRK = COMBINERKSAMPLES(TargetDirectory) prompts the user to
%   select successive RK sample files from the directory specified as
%   TargetDirectory.
%
%
%   SEE ALSO POOLRK.
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

if nargin==1
    tgtDir = fullfile(varargin{1},'*mat');
else
    tgtDir = fullfile(cd,'*mat');
end

n = 0;
state = true;
while state
    n = n+1;
    
    [FileName,PathName] = uigetfile(tgtDir,'Select RK Sample File');
    load(fullfile(PathName,FileName),'RK','x','FPosition','Units');
    CombinedRK{n} = RK;
    needCheck = 0;
    if ~exist('x','var')
        x=FPosition;
    elseif ~exist('Units','var')
        Units = 'pixels';
    end
%     windowWidth(n) = RK{1}.WindowWidth;
    xMax(n) = x(end)+RK{1}.WindowWidth;
    tempX(n,:) = x;
    
    
    tgtDir = PathName;
    
    choice2 = questdlg('Select another file?','',...
        'Yes','No','Cancel','Cancel');
    
    switch choice2
        case 'No'
            state = false;
        case 'Cancel'
            return
    end
end

% Combine x's
tempX = tempX./xMax';
tempX = tempX./max(tempX,[],2);

if max(abs(diff(tempX)))>0.01
    warning('Difference in window locations exceeds 1%');
end

CombinedX = mean(tempX);


end

% function [oldWin,newWin] = CheckWindow(oldWin,newWin,WindowWidth)
%     if length(oldWin)~=length(newWin)
%         error('All samples must have the same number of windows')
%     elseif oldWin(end)~=newWin(end)
%         warning(strcat('Absolute window locations (x) of all samples did not match.',...
%             ' Window locations were normalized to maximum distance.'));
%         
%         oldWin = oldWin./(oldWin(end)+WindowWidth);
%         newWin = newWin./(newWin(end)+WindowWidth);
%         
%         if ~prod(oldWin==newWin)
%             oldWin = round(oldWin,4);
%             newWin = round(newWin,4);
%             if ~prod(oldWin==newWin)
%                 error('Difference in spacing between windows exceeds tolerance.')
%             end
%         end
%     end
% end


