function [s] = fadd(s, f, x)

if ~isfield(s, f)
    s.(f) = x;
else
    s.(f) = s.(f) + x;
end