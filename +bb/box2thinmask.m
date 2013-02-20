function [A] = box2thinmask(A, box)

A(box(2):box(4), box(1)) = 1;
A(box(2):box(4), box(3)) = 1;
A(box(2), box(1):box(3)) = 1;
A(box(4), box(1):box(3)) = 1;