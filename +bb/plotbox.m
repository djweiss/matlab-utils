function varargout = plotbox(b,varargin)
% function varargout = plotbox(b,varargin)
nbox = size(b,1);

strs = {};
if nargin > 1
    if iscell(varargin{1})
        strs = varargin{1};
        varargin = varargin(2:end);
    end
end
hs = [];
for i=1:nbox
    c = boxcenter(b);
    h = plot([b(i,1) b(i,3) b(i,3) b(i,1) b(i,1)],[b(i,2) b(i,2) b(i,4) b(i,4) b(i,2)],varargin{:});
    if ~isempty(strs)
        text(b(i,1),b(i,2), strs{i}, 'BackgroundColor', [1 1 0.7]);
    end
    hs = [hs; h];
    hold on
%     plot(c(1),c(2),'x',varargin{:})
end


if nargout == 1
    varargout{:} = hs;
end