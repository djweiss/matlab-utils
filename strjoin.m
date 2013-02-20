function [s] = strjoin(sep, varargin)
% Joins several strings by a separator.

if nargin==1 & iscell(sep)
    varargin = sep;
    sep = ',';
end
if numel(varargin) == 1 & iscell(varargin{1})
    varargin = varargin{1};
end

s = varargin{1};
for i = 2:numel(varargin)
    s = [s sep varargin{i}];
end