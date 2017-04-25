function [ ndviFCLegended ] = legendNDVIFC( ndviFalseColorImage )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

ndviLegend = imread('NDVILegend.png');

ndviFCSize = size(ndviFalseColorImage);
ndviLegendSize = size(ndviLegend);
cropRect = [0 0 ndviFCSize(2)+ndviLegendSize(2) ndviFCSize(1)];

ndviFCLegended = imshowpair(ndviFalseColorImage, ndviLegend, 'montage');
ndviFCLegended = imcrop(ndviFCLegended.CData, cropRect);

end

