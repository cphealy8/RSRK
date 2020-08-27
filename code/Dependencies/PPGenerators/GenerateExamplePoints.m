clc; clear; close all;
ptfnames = dir;
SaveDir = '..\..\..\data\Verification Tests';
datfnames = dir(SaveDir);
datfiles = {datfnames.name};
addpath('..')

win = [0 5 0 1];
npts = 1000;
for n = 1:length(ptfnames)
    n
ptfilename = ptfnames(n).name;

if contains(ptfilename,'PP')
    run(ptfilename);
    
    ptID = ptfilename(1:4);
    
    datname = datfiles{contains(datfiles,ptID)};
    SaveName = fullfile(SaveDir,datname);
    
    save(SaveName,'pts','-append')
end

end
