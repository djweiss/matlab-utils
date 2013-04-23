function varargout = loadvar(filename, varargin)

x = load(filename, varargin{:});

if nargin==1
    fs = fieldnames(x);
    if numel(fs) == 1
        x = x.(fs{1});
    end
    varargout{1} = x;
else
    if nargout == numel(varargin)
        for i = 1:numel(varargin)
            varargout{i} = x.(varargin{i});
        end
    else
        varargout{1} = x;
    end
end