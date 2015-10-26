%DSET2CELL Convert dataset into cell array, one cell per feature
%
%   C = DSET2CELL(A,N)
%   C = A*DSET2CELL(N)
%
% INPUT
%   A   Dataset with possibly categorical features
%   N   Desired features, default: all
%
% OUTPUT
%   C   Cell array with one cell per feature. Categorical features are
%       decoded and stored as character arrays. If N is a scalar the cell
%       content of C is returned.
%
% DESCRIPTION
% This routine is an alternative for +A or DOUBLE(A), solving the problem
% of categorical data. Categorical features stored in A by indices of lists
% of category names in the feature domain field (SETFEATDOM) are decoded
% and returned as strings in character arrays.
%
% Missing data, coded as a NaN in a dataset are returned as an empty string
% in case of a categorical feature.
%
% SEE ALSO< a href="http://37steps.com/prtools">PRTools Guide</a>
% DATASETS, SETFEATDOM, FEATTYPES, CELL2DSET, CAT2DSET

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com

function c = dset2cell(varargin)

  argin = shiftargin(varargin,'vector');
  argin = setdefaults(argin,[],[]);
  if mapping_task(argin,'definition')
    c = define_mapping(argin,'fixed');
  else
    [a,N] = deal(argin{:});
    N = setdefaults({N},1:size(a,2));
    a = a(:,N);
    if ~isdataset(a)
      c = {a};
    else
      c = cell(1,size(a,2));
      L = feattypes(a,'C');
      for j=1:numel(c)
        c{j} = +a(:,j);
      end
      for j = L
        s = getfeatdom(a,j);
        s = char('',s{1});
        N = find(isnan(c{j}));
        c{j}(N) = zeros(numel(N),1);
        c{j} = s(c{j}+1,:);
      end
    end
    if numel(c) == 1
      c = c{1};
    end
  end

return
