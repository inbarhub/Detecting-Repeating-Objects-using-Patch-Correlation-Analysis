function newPoint = rotatePoint(point,xFactor,yFactor,angle,I,origImage)  
if(size(point,1) == 1)
     newPoint = point(1:2).*[xFactor,yFactor];
else
    newPoint = point(1:2).*[xFactor;yFactor];
end
end
