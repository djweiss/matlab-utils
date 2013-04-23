function [subimage] = extract(img, bbox)

n = rows(img); m = cols(img);

if bbox(1) >= 1 && bbox(2) >= 1 && bbox(3) <= m && bbox(4) <= n
    subimage = img(bbox(2):bbox(4), bbox(1):bbox(3),:);
else
    bn = bbox(4)-bbox(2)+1;
    bm = bbox(3)-bbox(1)+1;

    subimage = zeros(bn, bm, size(img,3), class(img));

    % get starting/end points
    bboxi = bbox;
    
    bbox = max(bbox, [1 1 -inf -inf]);
    bbox = min(bbox, [inf inf m n]);
    
    subimage(...
        [1 + bbox(2) - bboxi(2)]:[bn + bbox(4)-bboxi(4)], ...
        [1 + bbox(1) - bboxi(1)]:[bm + bbox(3)-bboxi(3)], :) = ...
        img(bbox(2):bbox(4), bbox(1):bbox(3),:);    
end

