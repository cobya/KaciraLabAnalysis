function [ redBandRegistered, nearRedBandRegistered, greenBandRegistered, blueBandRegistered, nirBandImage, rgbCombinedImage] = RegisterImages( redBandImage, nearRedBandImage, greenBandImage, blueBandImage, nirBandImage )
%RegisterImages registers images from a MicaSense camera
%   RegisterImages registers images from a MicaSense camera, returning the
%   registered images and a composite RGB image.

	% Image combination parameter Configuration
	[optimizer, metric] = imregconfig('Multimodal');
    optimizer.MaximumIterations = 150;
    optimizer.InitialRadius = optimizer.InitialRadius / 5;
    metric.NumberOfHistogramBins = 75;
            	
    % Registering (aligning) the images with the infrared sensor's image
    greenBandRegistered = imregister(greenBandImage, nirBandImage, 'Rigid', optimizer, metric);
    blueBandRegistered = imregister(blueBandImage, nirBandImage, 'Rigid', optimizer, metric);
    redBandRegistered = imregister(redBandImage, nirBandImage, 'Rigid', optimizer, metric);
    nearRedBandRegistered = imregister(nearRedBandImage, nirBandImage, 'Rigid', optimizer, metric);
            
    % Removing areas which do not overlap after stitching
	for i = 1 : size(greenBandRegistered,1)
		for j = 1 : size(greenBandRegistered,2)
			if redBandRegistered(i, j) == 0
            	greenBandRegistered(i,j) = 0;
            	blueBandRegistered(i,j) = 0;
            	nearRedBandRegistered(i,j) = 0;
            	nirBandImage(i,j) = 0;
			end
			if greenBandRegistered(i, j) == 0
            	redBandRegistered(i,j) = 0;
            	blueBandRegistered(i,j) = 0;
            	nearRedBandRegistered(i,j) = 0;
            	nirBandImage(i,j) = 0;
			end
			if blueBandRegistered(i, j) == 0
                redBandRegistered(i,j) = 0;
            	greenBandRegistered(i,j) = 0;
            	nearRedBandRegistered(i,j) = 0;
            	nirBandImage(i,j) = 0;
			end
			if nearRedBandRegistered(i, j) == 0
                redBandRegistered(i,j) = 0;
            	greenBandRegistered(i,j) = 0;
            	blueBandRegistered(i,j) = 0;
            	nirBandImage(i,j) = 0;
			end
		end
	end
            	
	% Combine the seperated RGB into one image
	combinedImage = cat(3, redBandRegistered, greenBandRegistered, blueBandRegistered);
	rgbCombinedImage = im2uint8(combinedImage);
end

