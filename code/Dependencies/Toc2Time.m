function [TimeOut] = Toc2Time(TimeIn)
%TOC2TIME Convert a time (in seconds) to a string of hr, min, sec. 
%   [TimeOut] = TOC2TIME(TimeIn)
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 

%%
if TimeIn>=3600 % Hours
    hours = floor(TimeIn/3600);
    minutes = floor((TimeIn-hours*3600)/60);
    seconds = floor(TimeIn-hours*3600-minutes*60);
    
    TimeOut = sprintf('%d hr %d min %d sec',hours,minutes,seconds);
elseif TimeIn<60 % Seconds
    seconds = floor(TimeIn);
    
    TimeOut = sprintf('%d sec',seconds);
else % Minutes
    minutes = floor(TimeIn/60);
    seconds = floor(TimeIn-minutes*60);
    
    TimeOut = sprintf('%d min %d sec',minutes,seconds);
end
end

