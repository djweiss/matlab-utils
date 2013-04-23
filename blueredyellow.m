function [colors] = blueredyellow(K)
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
