function [im xtick ytick] = scatterim(x, y, nbins)

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

if nargin<3
    nbins = 10;
end

xtick = linspace(min(x(:)), max(x(:)), nbins);
ytick = linspace(max(y(:)), min(y(:)), nbins);

[~,x] = fastdiscretize(scale01(x(:)), nbins);
[~,y] = fastdiscretize(1-scale01(y(:)), nbins);

idx = sub2ind([nbins nbins], y, x);
im = zeros([nbins nbins]);
for i = 1:numel(idx)
    im(idx(i)) = im(idx(i)) + 1;
end

if nargout==0
    imagesc(im); colormap jet;
    t = xtick(get(gca,'XTick'));
    set(gca,'XTickLabel',arrayfun(@(x)sprintf('%.2g',x), t, 'uniformoutput', false));
    t = ytick(get(gca,'YTick'));
    set(gca,'YTickLabel',arrayfun(@(x)sprintf('%.2g',x), t, 'uniformoutput', false));
end