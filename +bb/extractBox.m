function subimg = extractBox(img,box0,do_mirror)
if nargin < 3, do_mirror = true; end

box0 = box0 + [0 0 1 1];
tl = box0(1:2)';
br = box0(3:4)';
tr = box0([3 2])';
bl = box0([1 4])';

pts = [tl tr br bl];

subimg = extractRotatedBox(pts,double(img),do_mirror);

return
%%
figure(1)
imsc(img)
hold on
plotbox(box0)
myplot(pts,'.','markersize',30)

figure(2)
imsc(subimg)

0;