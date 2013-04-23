function varargout = plotbox(b,varargin)
% function varargout = plotbox(b,varargin)

% ======================================================================
% Copyright (c) 2012 David Weiss
% 
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to
% the following conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
% LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
% OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
% WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% ======================================================================

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