function [A] = paintbox(A, box, color) 

for k = 1:size(A,3)
    A(box(2):box(4), box(1), k) = color(k);
    A(box(2):box(4), box(3), k) = color(k);
    A(box(2), box(1):box(3), k) = color(k);
    A(box(4), box(1):box(3), k) = color(k);
end