function scell = split(str,delim)

if nargin == 1
    delim = ' ';
end

scell =regexp(str,delim,'split');