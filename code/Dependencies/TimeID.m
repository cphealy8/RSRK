function [ID] = TimeID()
%TIMEID Generate a timecode ID for naming datasets. 
%   Calling TIMEID generates a string of the current time and date to be
%   used to name and distinguish datasets. 
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 

[timevec] = fix(clock);
year = sprintf('%04d',timevec(1));
month = sprintf('%02d',timevec(2));
day = sprintf('%02d',timevec(3));
hour = sprintf('%02d',timevec(4));
minute = sprintf('%02d',timevec(5));

ID = strjoin({year,month,day,'-',hour,minute},'');
end

