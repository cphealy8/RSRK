function [outstat] = MainStats(instat,varargin)
%MAINSTATS compute the mean, standard deviation, median, and MAD of an
%input vector or matrix. 
%   Default is row-wise average but can be specified by changing the  
%   variable argument 'dim'. Each stat is stored as separate field in the
%   output structure.
%
%   [outstat] = MAINSTATS(instat) computes the row-wise mean, std, median,
%   and MAD of the input vector (or matrix) instat. outputs these as fields
%   in the structure outstat.
%
%   [outstat] = MAINSTATS(instat,'dim',2) computes the column-wise mean, 
%   std, median, and MAD of the input vector (or matrix) instat. outputs 
%   these as fields in the structure outstat.

p = inputParser;

addRequired(p,'instat',@isnumeric)
addOptional(p,'dim',1,@isnumeric)


parse(p,instat,varargin{:})
dim = p.Results.dim;

outstat.nsamps = size(instat,dim);
outstat.mean = mean(instat,dim,'omitnan');
outstat.sd = std(instat,[],dim,'omitnan');
outstat.var = outstat.sd.^2;
outstat.sem = outstat.sd/sqrt(outstat.nsamps);
outstat.median = median(instat,dim,'omitnan');
outstat.mad = mad(instat,1,dim);
end