%FILENAMES Get filenames of datafile
%
%		[NAMES,DIRS,ROOT] = FILENAMES(A)
%   FULLNAMES = FILENAMES(A,'full')
%
% INPUT
%   A         DATAFILE
%
% OUTPUT
%   NAMES     Names of the files in which the objects of A are stored.
%   DIRS      Names of the directories in which the objects of A are
%             stored.   
%   ROOT      Rootdirectory of the datafile
%   FULLNAMES Full names, including path.
%
% DESCRIPTION
% This routine facilitates the retrieval of the files where the objects of
% A are stored. Note that this is mainly usefull for datafiles of the type
% 'raw', as otherwise multiple objects may be stored in the same file.
%
% SEE ALSO (<a href="http://37steps.com/prtools">PRTools Guide</a>)
% DATAFILES
