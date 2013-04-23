function [subimage] = extract(img, bbox)

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

