function [x] = rget(s,varargin)

x = [s.(varargin{1})];
if nargin > 2
    x = rget(x, varargin{2:end});
end
    