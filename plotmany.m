function h = plotmany(n, x, y, varargin)

defaults.colors = lines(7);
[opts unused] = propval(varargin, defaults);

[sty color unused] = get_unique_style(n, 'colors', opts.colors, unused{:});

if n > 1
    hold on;
end

h = plot(x,y,sty, 'color', color, unused{:});
hold off;

