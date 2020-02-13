function [map] = myDivergingMap(colorVec,nBetween)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

map = colorVec(1,:);

for k = 1:length(colorVec)-1
    rrng = linspace(colorVec(k,1),colorVec(k+1,1),nBetween);
    grng = linspace(colorVec(k,2),colorVec(k+1,2),nBetween);
    brng = linspace(colorVec(k,3),colorVec(k+1,3),nBetween);
    
    % delete first element to prevent duplicates
    rrng(1) = [];
    grng(1) = [];
    brng(1) = [];
    
    newmap = [rrng; grng; brng]';
    
    map = [map; newmap];
end

map = map/255;

end

