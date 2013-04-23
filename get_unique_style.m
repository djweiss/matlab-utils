function [sty color unused] = get_unique_style(n, varargin)
% Get a unique LineSpec from a set of style combinations.

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

defaults.colors = lines(7);
defaults.styles = {'-','--','-'};
defaults.markers = {'o','x','s','d','^','v','+','*','>','<'};

[opts unused] = propval(varargin, defaults);

sty = '';
if ~isempty(opts.markers)
    sty = [sty opts.markers{mod(n-1, numel(opts.markers))+1}];
end
colors = opts.colors;
if isempty(colors) colors = [0 0 1]; end

color = colors(mod(n-1,rows(colors))+1,:);
if ~isempty(opts.styles)
    sty = [sty opts.styles{ mod(ceil(n./rows(colors))-1,numel(opts.styles))+1}];
else
    sty = [sty '-'];
end
