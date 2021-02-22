function [counts,entries] = countEntries(A)
%COUNTENTRIES Count number of times each entry in A appears in A
%   [counts] = countEntries(A) finds the unique numerical entries in A and
%   outputs a vector that counts the number of times each unique entry
%   appears in A.
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
    A = A(:);
   entries = unique(A);
   N = numel(entries);
   counts = zeros(N,1);
   for k = 1:N
      counts(k) = sum(A==entries(k));
   end
%    disp([ x(:) count ]);


end

