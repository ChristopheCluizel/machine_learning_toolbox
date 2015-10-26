%CAT2FEAT Fixed_cell mapping converting categorical data to numeric features
%
%   [F,L] = CAT2FEAT(C)
%   [F,L] = C*CAT2FEAT
%
% INPUT
%   C    Categorical array or cell array of categorial data
%
% OUTPUT
%   F    Numeric feature set, indices to L
%   L    Cell array of table of categories
%
% DESCRIPTION
% Categorical data is usual a set of character strings. It can, however,
% also be a set of numbers (real or integers) that should be interpreted
% qualitatively instead of quantitatively. This routine usies the PRTools
% routine RENUMLAB to transform categories feature by feature (columns of
% C) into sets of tables and indices, such that L{j}F(:,j) equals C{j} with
% an exception of missing data in C.
%
% Missing feature values in C should be coded in character categories by
% empty strings ('') and by a NaN in numeric categories. They don't have an
% entry in the tables L and are coded by a NaN in the numeric features F.
% Use MISVAL to transform them into 0, wherever needed.
%
% Use CAT2DSET to convert categorial data into a dataset.
% Use CAT2REAL to convert (partially) categorical PRTools datasets into
% reals by splitting categories.
%
% SEE ALSO <a href="http://37steps.com/prtools">PRTools Guide</a>
% DATASETS, MAPPINGS, SETFEATDOM, GETFEATDOM, RENUMLAB, MISVAL, CAT2DSET, 
% CAT2REAL

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com

function [f,t] = cat2feat(c)

if nargin < 1 || isempty(c)
  f = prmapping(mfilename,'fixed_cell');
  return
end

if ~iscell(c), c = {c}; end
m = size(c{1},1);
f = zeros(m,numel(c));
t = cell(1,numel(c));
for j=1:numel(c)
  if size(c{j},1) ~= m
    error('Character arrays should contain the same number of elements')
  end
  [f(:,j),t{j}] = renumlab(c{j});
  R = find(f(:,j) == 0);
  f(R,j) = NaN(numel(R),1);
end
    
    

