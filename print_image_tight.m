function print_image_tight(f, sz, varargin)

defaults.dpi = 72;
[opts unused] = propval(varargin, defaults);

H = sz(1); W = sz(2);
set(f, 'paperposition', [0 0 W/opts.dpi H/opts.dpi]);
set(f, 'papersize', [W/opts.dpi H/opts.dpi]);

print(f, sprintf('-r%d', opts.dpi), unused{:}); 