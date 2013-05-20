function [f fb] = fastdiscretize(x, nbins, minval, maxval, method)
% [fbin 

if nargin < 3
    minval = 0;
    maxval = 1;
end
if nargin < 4
    method = 1;
end

%scale to [0,1], truncating if overspills:
x = (x-minval)/(maxval-minval);
if (maxval-minval)==0
    x = zeros(size(x),class(x));
end
x(x<0) = 0;
x(x>1) = 1;


f = floor(x*nbins)+1;
f(f>nbins) = nbins;

if nargout == 2
    fb = [];
    for j = 1:cols(f)
        fb= [fb ind2vecpad(f(:,j), nbins, rows(f))'];
    end
end

return

%% comparison to hisc

x = rand(10000, 1);
tic
f = fastdiscretize(x, 10);
e1 = toc;
edges = 0:0.1:1;
tic
[n f2] = histc(x, edges);
e2 = toc;
dispf('fast: %g - histc: %g = %.0f%% ratio\n', e1, e2, e2/e1*100);

