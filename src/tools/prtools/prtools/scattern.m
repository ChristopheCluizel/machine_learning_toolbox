%SCATTERN Simple 2D scatterplot of dataset without axis annotation
%
%   SCATTERN(A,LEGEND,CMAP)
%   A*SCATTERN([],LEGEND,CMAP)
%   A*SCATTERN(LEGEND,CMAP)
%
% INPUT
%   A       Dataset
%   LEGEND  Logical, true/false for including legend, default false
%   CMAP    Desired colormap, default standard
%           'labels' plots the object labels instead of dots
%           'idents' plots the object idents instead of dots
%
% DESCRIPTION
% A simple, unannotated 2D scatterplot is created, without any axes.
%
% SEE ALSO
% DATASETS, SCATTERD, GETLABELS, GETIDENT

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com

function varargout = scattern(varargin)

varargout = {};
argin = shiftargin(varargin,'logical');
argin = shiftargin(argin,'scalar');
argin = setdefaults(argin,[],false,[]);
if mapping_task(argin,'definition')
  % standard return, name = filename
  varargout = {define_mapping(argin,'fixed')};
elseif mapping_task(argin,'fixed execution')
  % a call like w = template(a,parsin)
  [a,plotlegend,cmap] = deal(argin{:});
  if isdataset(a)
    nlab = getnlab(a);
    if getsize(a,3) == 2 & isempty(cmap)
      cmap = char('b','r');
    end
  else
    nlab = []; 
  end
  if ~ischar(cmap)
    h = gscatter(+a(:,1),+a(:,2),nlab,cmap,'.',9,'off');
  elseif strcmpi(cmap,'labels') || strcmpi(cmap,'label')
    h = gscatter(+a(:,1),+a(:,2),nlab,[1 1 1],'.',1,'off');
    lablist = getlablist(a,'string');
    text(+a(:,1),+a(:,2),lablist(getnlab(a),:),'HorizontalAlignment','center');
  elseif strcmpi(cmap,'idents') || strcmpi(cmap,'ident')
    h = gscatter(+a(:,1),+a(:,2),nlab,[1 1 1],'.',1,'off');
    iden = getident(a);
    if ~isstr(iden)
      iden = num2str(iden);
    end
    text(+a(:,1),+a(:,2),iden,'HorizontalAlignment','center');
  else
    h = gscatter(+a(:,1),+a(:,2),nlab,cmap,'.',9,'off');
    %error('Illegal input')
  end
  fontsize(16)
  axis equal
  axis tight
  axis off
  if plotlegend
    legend(h,getlablist(a,'string'))
  end
  if nargout > 0
    varargout = {h};
  end
end
  