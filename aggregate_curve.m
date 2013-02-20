function [curve] = aggregate_curve(x, y, varargin)

defaults.xlim = [];
defaults.nbins = 10;
opts = propval(varargin, defaults);

if isempty(opts.xlim)
    xlim = [min(cellfun(@min,x)) max(cellfun(@max,x))];
end
bins = linspace(xlim(1), xlim(2), opts.nbins);
binpts = bins(1:end-1) + diff(bins)./2;

binvals_y = cell(opts.nbins-1,1); %, numel(bins));
binvals_x = cell(opts.nbins-1,1); %, numel(bins));

for i = 1:numel(x)
    binidx = sum(bsxfun(@lt, bins(2:end), vec(x{i})),2) + 1;
    for k = 1:numel(binidx)
        binvals_y{binidx(k)}(end+1) = y{i}(k);
        binvals_x{binidx(k)}(end+1) = x{i}(k);
    end
end
idx = find(cellfun(@isempty, binvals_y));
binpts(idx) = [];
binvals_x(idx) = [];
binvals_y(idx) = [];

curve= bundle(bins,binpts);
curve.x = cellfun(@mean, binvals_x);
curve.x_e = cellfun(@std, binvals_x)./sqrt(cellfun(@numel, binvals_x));
curve.y = cellfun(@mean, binvals_y);
curve.y_e = cellfun(@std, binvals_y)./sqrt(cellfun(@numel, binvals_y));