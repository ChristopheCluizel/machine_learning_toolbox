%CAT2REAL Convert categorical features to real features by one-hot coding
%
%   B = CAT2REAL(A)
%   B = A*CAT2REAL
%
% INPUT
%   A    Dataset
%
% OUTPUT
%   B    Dataset
%
% DESCRIPTION
% Categorical features with N > 2 categories are split in N real features,
% one for each category. If the category is set for an object, the real
% feature value gets a value sqrt(2)/2. The distance contribution for two
% objects with different category values is thereby 1. Features with two
% categories are transformed in binary (0/1) features, also contributing 
% with 1 to object distances for objects with a different feature value.
%
% Missing values in categorical features of A will result in a NaN for all
% corresponding features of B. They may be set by MISVAL.
%
% SEE ALSO <a href="http://37steps.com/prtools">PRTools Guide</a>
% DATASETS, MAPPINGS, SETFEATDOM, CAT2DSET, CAT2FEAT, MISVAL

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com

function out = cat2real(a)

if nargin < 1 || isempty(a)
  out = prmapping(mfilename,'fixed');
  return
end

f = getfeatdom(a);
N = zeros(1,numel(f));
for j=1:numel(f)
   N(j) = size(f{j},1); % number of categories in feature j
   % will be zeros for non-categorical features
end

% take only the features with > 2 categorical values
L = N>2; 
N(~L) = zeros(1,sum(~L));

b = zeros(size(a,1),sum(N(L)));     % space for new features
k = 1;                              % feature counter in b
for j=1:numel(f)                    % run over all features in a
  if L(j)                           % check for categorical features
    M = find(isnan(+a(:,j)));       % get missing values
    for i=1:N(j)                    % run over all possible values
      b(:,k) = double(a(:,j) == i); % create new feature, 
      b(M,k) = NaN(numel(M),1);     % set missing values
      k = k+1;                      % update feature counter
    end
  end
end

% take non-categorical features only. Concatenate with new features
out = setdata(a,[a(:,~L) b*sqrt(2)/2]);

    

