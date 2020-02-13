function [ID] = TimeID()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[timevec] = fix(clock);
year = sprintf('%04d',timevec(1));
month = sprintf('%02d',timevec(2));
day = sprintf('%02d',timevec(3));
hour = sprintf('%02d',timevec(4));
minute = sprintf('%02d',timevec(5));

ID = strjoin({year,month,day,'-',hour,minute},'');
end

