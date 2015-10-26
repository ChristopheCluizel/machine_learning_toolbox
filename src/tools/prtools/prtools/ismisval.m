%ISMISVAL Check dataset on missing values
%
% 	N = ISMISVAL(A);
%
% INPUT
%		A	 Dataset
%
% OUTPUT
%		N  1/0 if dataset A has / has not missing values
%
% DESCRIPTION
% The function ISMISVAL tests whether A has any missing value. In case of
% no output arguments an error is generated in case of missing values.
%
% SEE ALSO (<a href="http://37steps.com/prtools">PRTools Guide</a>)
% DATASET, MISVAL

function n = ismisval(a)

  n = any(any(isnan(+a)));
	if (nargout == 0) & (n == 1)
		error([newline 'Missing values found.'])
	end
return;

