function A = get_frame_silent(f, sz, tmpdir)
if nargin<3
    tmpdir = '/scratch/';
end
filename = [tmpdir '/tmpsave/' uid '.png'];
mkdir2(filename);
print_image_tight(f, sz, '-dpng', filename, 'dpi', 50);
A = imread(filename);
delete(filename);