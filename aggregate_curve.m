function [curve] = aggregate_curve(x, y, varargin)

defaults.xlim = [];
defaults.nbins = 10;
defaults.scale = 'equal';
defaults.interp = false;
opts = propval(varargin, defaults);

if isempty(opts.xlim)
    xlim = [min(cellfun(@min,x)) max(cellfun(@max,x))];
end
if isequal(opts.scale, 'equal')
    bins = linspace(xlim(1), xlim(2), opts.nbins);
elseif isequal(opts.scale, 'quantile')
    xall = cellfun(@vec,x,'uniformoutput',false);
    xall = vertcat(xall{:});
    %for j = 1:(opts.nbins)
    bins = quantile(xall, linspace(0,1,opts.nbins)); %(j-1)./opts.nbins);
    %end
    bins(1) = xlim(1); bins(end) = xlim(2);
    bins = unique(bins);
else
    error('improper scale ''%s''', opts.scale)
end
opts.nbins = numel(bins);

if opts.interp
    binvals_x = cell(opts.nbins,1);
    binvals_y = cell(opts.nbins,1);
    for i = 1:numel(x)
        xx = x{i};
        binrange = bins >= min(xx) & bins <= max(xx);
        idx = 1:numel(binrange); %find(binrange);
        y{i} = interp1(xx, y{i}, bins(idx), 'linear', 'extrap');
        x{i} = bins(idx);        
        for k = 1:numel(idx)
            binvals_x{idx(k)}(end+1) = x{i}(k);
            binvals_y{idx(k)}(end+1) = y{i}(k);
        end
    end
else

    %binpts = bins(1:end-1) + diff(bins)./2;
    binvals_y = cell(opts.nbins-1,1); %, numel(bins));
    binvals_x = cell(opts.nbins-1,1); %, numel(bins));
    %binvals_y = cell(opts.nbins,1); %, numel(bins));
    %binvals_x = cell(opts.nbins,1); %, numel(bins));
    
    for i = 1:numel(x)
        binidx = sum(bsxfun(@lt, bins(2:end), vec(x{i})),2) + 1;
        %[~,binidx] = histc(vec(x{i}), bins); %sum(bsxfun(@lt, bins(2:end), vec(x{i})),2) + 1;
        for k = 1:numel(binidx)
            binvals_y{binidx(k)}(end+1) = y{i}(k);
            binvals_x{binidx(k)}(end+1) = x{i}(k);
        end
    end
end

idx = find(cellfun(@isempty, binvals_y));
binvals_x(idx) = [];
binvals_y(idx) = [];
bins(idx) = [];
curve= bundle(bins, binvals_x, binvals_y);
curve.x = cellfun(@mean, binvals_x);
curve.x_e = cellfun(@std, binvals_x)./sqrt(cellfun(@numel, binvals_x));
curve.y = cellfun(@mean, binvals_y);
curve.y_e = cellfun(@std, binvals_y)./sqrt(cellfun(@numel, binvals_y));