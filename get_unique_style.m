function [sty color unused] = get_unique_style(n, varargin)

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
