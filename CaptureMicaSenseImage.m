function [ greenBandImage, blueBandImage, redBandImage, nearRedBandImage, nirBandImage, imagesFolder, blueBandName, imagesExt ] = CaptureMicaSenseImage( )
%CaptureMicaSenseImage captures a new image using the MicaSense HTTP API
%   CaptureMicaSenseImage captures a new image using the MicaSense HTTP API
%   and returns the path of the image set and the name of the blue band

	% Creating the image capture request
	captureURL = matlab.net.URI('http://192.168.10.254/capture?store_capture=true');
	captureRequest = matlab.net.http.RequestMessage;
	captureResponse = send(captureRequest, captureURL);
	
	% Checking capture status to get full path
	captureCheckURL = matlab.net.URI(strcat('http://192.168.10.254/capture/', captureResponse.Body.Data.id));
	captureCheckRequest = matlab.net.http.RequestMessage;
	captureCheckResponse = send(captureCheckRequest, captureCheckURL);
	
	% Check the status until the operation is complete
	while strcmp(captureCheckResponse.Body.Data.status,'pending')
		captureCheckResponse = send(captureRequest, captureCheckURL);
	end
	
	% Setting the image paths
	blueBandPath = captureCheckResponse.Body.Data.raw_storage_path.x1;
	greenBandPath = captureCheckResponse.Body.Data.raw_storage_path.x2;
	redBandPath = captureCheckResponse.Body.Data.raw_storage_path.x3;
	nearRedBandPath = captureCheckResponse.Body.Data.raw_storage_path.x4;
	nirBandPath = captureCheckResponse.Body.Data.raw_storage_path.x5;
	
	% Setting the retrieval URLs
	blueBandURL = matlab.net.URI(strcat('http://192.168.10.254', blueBandPath));
	greenBandURL = matlab.net.URI(strcat('http://192.168.10.254', greenBandPath));
	redBandURL = matlab.net.URI(strcat('http://192.168.10.254', redBandPath));
	nearRedBandURL = matlab.net.URI(strcat('http://192.168.10.254', nearRedBandPath));
	nirBandURL = matlab.net.URI(strcat('http://192.168.10.254', nirBandPath));
	
	% Request the new images
	retrieveRequest =  matlab.net.http.RequestMessage;
	blueRetrieveResponse = send(retrieveRequest, blueBandURL);
	greenRetrieveResponse = send(retrieveRequest, greenBandURL);
	redRetrieveResponse = send(retrieveRequest, redBandURL);
	nearRedRetrieveResponse = send(retrieveRequest, nearRedBandURL);
	nirRetrieveResponse = send(retrieveRequest, nirBandURL);
	
	% Create the new images from the data
	greenBandImage = greenRetrieveResponse.Body.Data;
	blueBandImage = blueRetrieveResponse.Body.Data;
	redBandImage = redRetrieveResponse.Body.Data;
	nearRedBandImage = nearRedRetrieveResponse.Body.Data;
	nirBandImage = nirRetrieveResponse.Body.Data;
	
	% Setting the image names used in saving
	blueBandName =  blueBandPath(end-13:end);
	blueBandNameNoExt = blueBandPath(end-13:end-4);
	imagesExt = blueBandPath(end-3:end);
	greenBandName =  strcat(strcat(blueBandNameNoExt(1:end-1),'2'), imagesExt);
	redBandName = strcat(strcat(blueBandNameNoExt(1:end-1),'3'), imagesExt);
	nearRedBandName = strcat(strcat(blueBandNameNoExt(1:end-1),'4'), imagesExt);
	nirBandName = strcat(strcat(blueBandNameNoExt(1:end-1),'5'), imagesExt);
	
	% Convert the images to uint8
	greenBandImageUINT8 = im2uint8(greenBandImage);
	blueBandImageUINT8 = im2uint8(blueBandImage);
	redBandImageUINT8 = im2uint8(redBandImage);
	nearRedBandImageUINT8 = im2uint8(nearRedBandImage);
	nirBandImageUINT8 = im2uint8(nirBandImage);
	
	% Save the new images
	imagesFolder = uigetdir('', 'Select Where To Save New Images');
	cd(imagesFolder);
	imwrite(blueBandImageUINT8, blueBandName, 'tif');
	imwrite(greenBandImageUINT8, greenBandName, 'tif');
	imwrite(redBandImageUINT8, redBandName, 'tif');
	imwrite(nearRedBandImageUINT8, nearRedBandName, 'tif');
	imwrite(nirBandImageUINT8, nirBandName, 'tif');
end

