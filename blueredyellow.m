function [colors] = blueredyellow(K)
% High contrast colormap that prints to grayscale correctly

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

if nargin==0
    K = 64;
end

MR=[0,0;
    0.1,0; 
%    0.3,0.5;
    0.7,1;
%    0.8,0.8;
    1,1];
MG=[0,0; 
    0.3,0;
    0.8,0.7;
    1,1];
MB=[0,0.1; 
    0.3,0.6;
%    0.5,0.3;
    0.7,0.2;    
    1, 0.5];

colors = colormapRGB(K, MR,MG,MB);

return;


%%
 x = linspace(-20,20,500); 


%compose a grid
  [xx,yy] = meshgrid(x,x);


% calculate the radius r for xx and yy pairs
% as the airy disc has a  circular symmetry
  r = sqrt( xx.^2 + yy.^2 );


%calculate the electrical field
  AiryField = besselj(1,r)./r;
% intensity = abs( field ) ^2
  AiryIntensity = abs(AiryField).^2;



% plot them
  figure(1)
  imagesc(x,x,AiryField)
  colormap(blueredyellow);

  figure(2)
  imagesc(x,x,AiryField)
  colormap(jet);

  %%
  imagesc(rand(100,100)>0.5);
  %%
  
  
  
%  figure(2)
%  imagesc(x,x,AiryIntensity);
