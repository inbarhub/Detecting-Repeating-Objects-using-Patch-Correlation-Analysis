function [a_1,new_I] = askUser(tmp,indicesToAsk,params,recSize)
a_1 = ones(size(params.origImage,1),size(params.origImage,2));

for i = 1:size(indicesToAsk,1)
    newCenterPoint = round(rotatePoint(params.info(indicesToAsk(i)).center,1/params.xFactor,1/params.yFactor,-params.angle,params.I,params.origImage));
    a_1(max(newCenterPoint(1)-1,1):min(newCenterPoint(1)+1,size(params.origImage,1)),max(newCenterPoint(2)-1,1):min(newCenterPoint(2)+1,size(params.origImage,2))) = 0;
end
params.origImage = params.origImage-min(params.origImage(:));
params.origImage = params.origImage/max(params.origImage(:));
new_I = zeros(size(params.origImage));
new_I(:,:,1) = params.origImage(:,:,1);
new_I(:,:,2) = params.origImage(:,:,2);
new_I(:,:,3) = params.origImage(:,:,3);

for i = 1:size(indicesToAsk,1)
    r = (tmp(indicesToAsk(i)) <= 1);
    g = (tmp(indicesToAsk(i)) > 1);
    newCenterPoint = round(rotatePoint(params.info(indicesToAsk(i)).center,1/params.xFactor,1/params.yFactor,-params.angle,params.I));
    
    x_start = max(newCenterPoint(1)-recSize,1);
    x_end = min(newCenterPoint(1)+recSize,size(params.origImage,1));
    y_start = max(newCenterPoint(2)-recSize,1);
    y_end = min(newCenterPoint(2)+recSize,size(params.origImage,2));
    new_I = drawRectangle(new_I,x_start,x_end,y_start,y_end,r,g,params.origImage);
end
a_1 = repmat(a_1,[1 1 3]);

end

