function trymkdir(path)
% Try to create a directory on a given path.

[success, msg] = mkdir(path);
if ~success
    error(sprintf('unable to create directory ''%s'': %s', path, msg));
end
