%FEAT2LAB  Label dataset by one of its features and remove this feature
%
%   B = FEAT2LAB(A,N,LABLISTNAME)
%
% INPUT
%   A   Dataset
%   N   Integer, pointing to feature to be used as label
%
% OUTPUT
%   B   Dataset, feature N is removed and used for labeling
%
% SEE ALSO (<a href="http://37steps.com/prtools">PRTools Guide</a>)
% DATASETS, SETFEATDOM, GETFEATDOM

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = feat2lab(a,n,lablistname)

isdataset(a);
k = size(a,2);

if (n<1) || (n>k)
  error('Desired feature not in range')
end

lablist = getfeatdom(a,n);
lablist = lablist{1};
nlab = +a(:,n);
a(:,n) = [];
if isempty(lablist) || ~ischar(lablist)
  [nlab,lablist] = renumlab(nlab);
end

if nargin > 2
  curn = curlablist(a);
  a = addlablist(a,lablist,lablistname);
  a = setnlab(a,nlab);
  a = changelablist(a,curn);
else
  a = setlablist(a,lablist);
  a = setnlab(a,nlab);
end