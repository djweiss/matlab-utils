function h = plotmany(n, x, y, varargin)
% Easy to use plot many lines with unique styles.
% 
% Usage:
%
% % Plot 2 lines in different styles, automatically turning on hold, etc.
% plotmany(1, x1, y1);
% plotmany(2, x2, y2); 

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
[opts unused] = propval(varargin, defaults);

[sty color unused] = get_unique_style(n, 'colors', opts.colors, unused{:});

if n > 1
    hold on;
end

h = plot(x,y,sty, 'color', color, unused{:});
hold off;

