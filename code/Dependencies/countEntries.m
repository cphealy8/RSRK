function [counts] = countEntries(A)
%COUNTENTRIES Count number of times each entry in A appears in A
%   Detailed explanation goes here
    A = A(:);
   x = unique(A);
   N = numel(x);
   counts = zeros(N,1);
   for k = 1:N
      counts(k) = sum(A==x(k));
   end
%    disp([ x(:) count ]);
end

