function capture_and_save(savefile,imgdims)

% ======================================================================
% Copyright (c) 2012 David Weiss
% 
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to
% the following conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
% LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
% OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
% WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% ======================================================================

%step 1: save whatever we've got to tmp, high-res, greenscreened
tmpfile = ['/scratch/',uid,'.jpg'];
set(gcf,'color',[0 1 0]);
set(gcf,'InvertHardcopy','off')
set(gca,'position',[0 0 1 1]);
print(gcf, '-r200', '-dbmp16m', tmpfile);
img = im2double(imread(tmpfile));
delete(tmpfile);

%step 2: crop out green
tol = 1/255;
mask = ~(img(:,:,1)<tol & abs(img(:,:,2)-1)<tol & img(:,:,3)<tol);
minx = find(any(mask),1,'first');
maxx = find(any(mask),1,'last');
miny = find(any(mask,2),1,'first');
maxy = find(any(mask,2),1,'last');
cropbox = [minx miny maxx maxy];
imgc = bb.extract(img,cropbox); 

imgcr = imresize(imgc,imgdims(1:2),'bilinear');

mkdir2(savefile);
f = [savefile '.jpg']; %[savefile(1:end-4) 'crop.jpg'];
disp(f);
imwrite(imgcr, f);