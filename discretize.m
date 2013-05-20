function [fb f minval maxval] = discretize(x, nbins, minval, maxval)
% assumes x is in range [0 1] already
if isempty(x)
    [fb,f] = deal(x);
    return
end

if nargin < 3
    minval = min(x);
    maxval = max(x);
end
if numel(nbins)==1
    nbins = repmat(nbins, 1, cols(x));
end
%scale to [0,1], truncating if overspills:
x = bsxfun(@rdivide,bsxfun(@minus, x, minval),(maxval-minval));
x(isnan(x)) = 0;
x(x<0) = 0;
x(x>1) = 1;

f = floor(bsxfun(@times,x, nbins))+1; 
for j = 1:cols(f)
    f(f(:,j)>nbins(j),j) = nbins(j);
end

offsets = [0 cumsum(nbins)];
ridx = zeros(numel(f),1); cidx = ridx; vals = ones(numel(f),1);
n = 1;
for i = 1:rows(f)
    for j = 1:cols(f)
        ridx(n) = i;
        cidx(n) = offsets(j) + f(i,j);
        n = n + 1;
    end
end
fb = sparse(ridx,cidx,vals,rows(f),sum(nbins));
%fb = zeros(rows(f), sum(nbins));
% for j = 1:size(f,2)
%     fb= [fb ind2vecpad(f(:,j)', nbins(j), size(f,1))'];
% end
% assert(cols(fb)==sum(nbins));

return

%% comparison to histc

x = rand(10000000,1);
tic
f = pose.discretize(x, 10);
e1 = toc;
edges = 0:0.1:1;
tic
[n f] = histc(x, edges);
e2 = toc;
dispf('%g - %g = %g\n', e1, e2, e2-e1);

