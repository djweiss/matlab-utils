function savemkdir(filename, varargin)

fprintf('Saving to file: ''%s''\n', filename);
trymkdir(fileparts(filename));

for i = 1:numel(varargin)
    varnames{i} = ['''' inputname(i+1) ''''];
end

callstr = sprintf('save(''%s'', %s)', ...
    filename, strjoin(',',varnames));
evalin('caller', callstr);

