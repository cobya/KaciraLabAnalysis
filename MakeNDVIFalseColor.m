function [ ndviFalseColorImage ] = MakeNDVIFalseColor ( ndviImageRed )
%GetColormap Returns the custom ndviFalseColormap
%   Returns the custom ndviFalseColormap used to create the NDVI False
%   Color image

colorList = cat(1, [0,0,0], [0,0,0], [0,0,0], [0,0,1], [0,0,1], [1,0,0], [1,.5,0], [1,1,0], [0,.6,0], [0,1,0]);
ndviFalseColorMap = myColorMap(colorList, 256);

ndviFalseColorImage = imagesc(ndviImageRed, [-1 1]);
colormap(ndviFalseColorMap);
colorbar;
freezeColors;

ndviFalseColorImage = ndviFalseColorImage.CData;
close all;
end

