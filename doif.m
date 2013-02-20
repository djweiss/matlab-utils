function [x] = doif(cond, xtrue, xfalse)

if cond
    x = evalin('caller',xtrue);
else
    x = evalin('caller',xfalse);
end