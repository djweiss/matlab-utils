function [im xtick ytick] = scatterim(x, y, nbins)

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