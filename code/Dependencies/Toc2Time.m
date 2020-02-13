function [TimeOut] = Toc2Time(TimeIn)
%Toc2Time Convert a time (in seconds) to a string of hr, min, sec. 
%   Detailed explanation goes here

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

