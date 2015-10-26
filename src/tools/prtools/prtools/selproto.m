%SELPROTO Select prototypes from dataset, generator mapping
% 
%  [P,I,J] = SELPROTO(A,N,TYPE,PAR,SEED)
%  [P,I,J] = A*SELPROTO(N,TYPE,PAR,SEED)
% 
% INPUT
%   A      PRTools dataset or double matrix
%   N      Scalar, number of prototypes to be selected. 
%          If N is a row vector with as many elements as A has classes,
%          the selection is done clas wise.
%          If 0 < N < 1, the corresponding fraction of A is selected.
%          Default is N = 1.
%   TYPE   Character string naming the algorithm (lower case supported):
%          'F' or 'FFT', the Farthest First Traversal. 
%          'K' or 'KMEANS', the k-means algorithm. The nearest objects in A
%          are returned. (default)
%          'M' or 'MMEANS', the traditional k-means returning the cluster
%          means instead of their nearest objects. In I a NaN is returned.
%          'C' or 'KCENTRES', the k-centres algorithm.
%          'R' or 'RANDOM', random selection.
%   PAR    Initialisation: an index for an object in A or a character:
%          'R', random selection.
%          'D', deterministic selection (default). The object in A nearest
%          to the mean of A (default). 
%          The FFT algorithm starts for PAR = 'D' with the object most
%          remote from this object. For TYPE = 'R' this option is neglected.
%   SEED   A desired state of random number generation applied to RANDRESET.
%
% OUTPUT
%   P      PRTools dataset, or double matrix in case A is double,
%          containing the selected prototypes. If TYPE is 'M' these are not
%          objects from  A and P is a double array.
%   I      The indices of the selected objects in A, P = A(I,:). I = NaN in
%          case TYPE is 'M'. 
%   J      Indices of the not-selected objects. I = NaN in case TYPE is 'M'. 
%
% DESCRIPTION
% This routine selects some possibly interesting objects, e.g. for building
% a representation set from a feature representation. With an exception for
% TYPE = 'M', objects from A are returned. In case PAR = 'D', the
% procedures are deterministic (except for TYPE = 'R'): FFT starts with the
% most remote object from the dataset mean. The KMEANS algorithms start
% with the N objects selected by the FFT algorithm. KCENTRES has a greedy,
% deterministic solution.
% 
% If A is a cell array of datasets the command is executed for each
% dataset separately. Results are stored in cell arrays. For each dataset
% the random seed is reset, resulting in aligned sets for the generated
% datasets P if the sets in A were aligned.
%
% EXAMPLE
% % compute a dissimilarity based classifier for a representation set of
% % 10 objects using a Minkowski-1 distance.
% a = gendatb;
% u = selproto(10)*proxm('m',1)*fisherc;
% w = a*u;
% scatterd(a)
% plotc(w)
%
% SEE ALSO (<a href="http://37steps.com/prtools">PRTools Guide</a>)
% DATASETS, MAPPINGS, GENDAT, RANDRESET, PRKMEANS, KCENTRES

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com
%%

function [p,I,J] = selproto(varargin)

%% mapping definition
  argin = shiftargin(varargin,{'scalar','vector'});
	argin = setdefaults(argin,[],1,'k','d',[]);
  if mapping_task(argin,'definition')
    p = define_mapping(argin,'generator','Prototype selection');
    return
  end
  
%% start mappping execution

  % get and check parameters
  [a,n,type,par,seed] = deal(argin{:});
  if isempty(seed)
    seed = randreset;
  end
  randsel = strcmpi(par,'r');
  if ~randsel && ~strcmpi(par,'d')
    error('Wrong value for PAR, it should be either ''R'' or ''D''');
  end
  randreset(seed);
  m = size(a,1);
  
	% if the input is a cell array of datasets, apply this procedure
  % to the individual datasets.
	if (iscell(a))
    [p,I,J] = feval(mfilename,a,n,type,par,seed);
    return
  end
  
  % if n is a vector, apply this procedure to classes separately
  if numel(n) > 1
    if numel(n) ~= getsize(a,3)
      error('Vector with number of desired prototypes has wrong length')
    end
    isdataset(a);
    L = classsizes(a);
    if any(n>L)
      error('Some classes have insufficient objects');
    end
    aa = selclass(a);
    p = prdataset; I = []; J = [];
    for j=1:numel(L)
      [pp,II,JJ] = feval(mfilename,aa{j},n(j),type,par);
      p = [p; pp]; I = [I; II]; J = [J; JJ];
    end
    return
  end
  
%% the real work
  x = +a;
  switch lower(type)
    
    case {'f','fft'}                             % FFT  
      argmax = mapm('max')*out2;       % just to make code more readable
      if ~randsel
        y = feval(mfilename,x,1,'kmeans');
      else
        y = x(randi(m),:);
      end
      I = zeros(n,1);
      d = zeros(m,n);
      for i=1:n
        d(:,i) = distm(x,y);
        dmin   = min(d(:,1:i),[],2);
        I(i)   = dmin*argmax;
        y      = x(I(i),:);
      end
      p = a(I,:);
      J = setxor(I,(1:m)');
      
    case {'m','mmeans'}                          % MMEANS
      if n == 1
        % special case, dataset mean is requested
        p = mean(x,1); I = NaN; J = NaN(m-1,1);
        return
      end
      if randsel
        % kmeans with random initialisation
        lab = prkmeans(x,n,100,'rand');
      else
        % run deterministic fft for initialisation
        [y,I] = feval(mfilename,x,n,'fft');
        % classify all objects with nmc based on fft prototypes
        labin = x*nmc(prdataset(y,I))*labeld;
        % use these for kmeans
        lab   = prkmeans(x,n,100,labin);
      end
      % create dataset with result labels of kmeans
      y = prdataset(x,lab);
      % find class means, they are the prototypes
      p = +meancov(y);
      I = NaN(n,1);
      J = NaN(m-n,1);

    case {'k','kmeans'}                          % KMEANS  
      argmin2 = mapm('min',[],2)*out2; % just to make code more readable
      % find prototypes of mmeans
      y = feval(mfilename,x,n,'mmeans',par);
      % compute distances to all dataset points
      d = distm(y,x);
      % find nearest object for every prototype
      I = d*argmin2;
      % and the prototypes themselves
      p = a(I,:);
      J = setxor(I,(1:m)');
      
    case {'c','kcentres','kcenters'}             % KCENTRES
      % for the time being only feasible 
      % if we can compute a full distance matrix
      d = distm(x);
      if randsel
        [dummy,I] = kcentres(d,n);
      else
        [dummy,I] = kcentres(d,n,0);
      end
      I = I(:);
      p = a(I,:);
      J = setxor(I,(1:m)');
      
    case {'r','random'}                          % RANDOM
      [p,dummy,I,J] = gendat(a,n);
      
    otherwise
      error('Illegal value of TYPE')
      
  end
end
        
