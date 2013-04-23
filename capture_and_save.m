function capture_and_save(savefile,imgdims)

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