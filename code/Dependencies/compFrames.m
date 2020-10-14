function [nframes,aoverlap] = compFrames(FullWidth,Overlap,WinWidth)
%COMPFRAMES compute number of frames given full window width, overlap, and
%window width.
%   If the specified overlap and window width are not achievable, an
%   adjusted overlap is output. 
nframes = ((FullWidth/WinWidth)-Overlap)/(1-Overlap);

aoverlap = Overlap;
if rem(nframes,round(nframes))~=0
    nframes = round(nframes);
    aoverlap = (FullWidth/WinWidth - nframes)/(1-nframes);
    
    warning('Specified window width and overlap are incompatible. Overlap adjusted to meet specifications');
end

end

