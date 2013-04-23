function [varargout] = size2(x,idx)
% function [varargout] = size2(x,idx)
%if one output, returns the size of x, indexed by idx
%if [o1,o2,..,on] = size2(x,idx), behaves in the following way:
%   s = size(x); s = s(idx); [o1,o2,..,on] = deal(s(1),s(2),...,s(n))

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

s = size(x);
if nargin<2
    idx = 1:max(length(s),nargout);
end

extra = max(idx)-length(s);
if extra > 0
    s = [s ones(1,extra)];
end

s = s(idx);

if nargout <= 1
    varargout = {s};
else
    nout = max(nargout,1);
    for i=1:nout,
        varargout{i} = s(i);
    end
end