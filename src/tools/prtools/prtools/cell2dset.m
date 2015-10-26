%CELL2DSET Construct dataset from a cell array having one feature per cell.
%
%   A = CELL2DSET(C,F,M,L)
%
% INPUT
%   C  Cell array with one cell per feature. Categorical features should
%      be given by strings in a character array or as cellstrings (one
%      object per cell) stored in the feature cell.
%      Numerical features may either be stored as character arrays, cell
%      strings or as a numeric vector.
%   F  Format field (e.g. 'ccncnn') for distinguishing cell character
%      arrays with categorical data ('c') from numeric data ('n').
%   M  Optional character array with symbols used for missing values. The 
%      empty string ('') will always be interpreted as a missing value.
%   L  Labels that may be used for labelling A (numbers or strings, see
%      PRDATASET). (optional)
%
% OUTPUT
%   A  Dataset with categorical features numerically coded as indices in 
%      the DATA field, pointing to the list on category names stored in the  
%      FEATDOM field, see SETFEATDOM.
%
% DESCRIPTION
% This routine is an alternative for PRDATASET in case data is given by
% strings or numeric characters. The parameter F is optional. If not given
% all character arrays and cell strings are interpreted as categorical.
%
% Missing data (empty strings), will be coded as a NaNs.
%
% SEE ALSO <a href="http://37steps.com/prtools">PRTools Guide</a>
% DATASETS, SETFEATDOM, FEATTYPES, DSET2CELL, CAT2DSET, DSET2CELL

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com

function a = cell2dset(c,varargin)

[f,misval,lab] = setdefaults(varargin,[],[],[]);

if ~iscell(c)
  error('Cell array expected')
end

m = size(c{1},1);         % number of objects
k = numel(c);             % number of features
a = zeros(m,k);           % numeric data will be stored here
if ~isempty(f)            % decode format statement
  if numel(f) ~= k
    error('format string has wrong size')
  end
else
  f = repmat('x',1,k);    % indicates: no format given
end

fdom = cell(1,numel(c));  % space for feature domains
for j=1:numel(c)          % run over all features
  if size(c{j},1) ~= m
    error('Not the same number of objects for all features')
  end
  if isstr(c{j}) || iscell(c{j})
    cc = cellstr(c{j});
    if ~isempty(misval)
      for i=1:numel(misval)
        L = find(strcmp(misval(i),cc));
        cc(L) = [repmat({''},numel(L),1)];
      end
    end
    L = find(strcmp('',cc));    % find missing values
    if (f(j) == 'x') || (f(j) == 'c')
      % interpret as category data, use renumlab for coding
      [a(:,j),fdom{j}] = renumlab(cc);
      a(L,j) = NaN(numel(L),1);
    elseif f(j) == 'n'
      cc(L) = [repmat({'NaN'},numel(L),1)]; % put a 'NaN' for missing
      a(:,j) = str2num(char(cc)); % convert
    else
      error('Wrong format found')
    end
  else
    a(:,j) = c{j};
  end
end
    
a = prdataset(a,lab);
a = setfeatdom(a,fdom);
