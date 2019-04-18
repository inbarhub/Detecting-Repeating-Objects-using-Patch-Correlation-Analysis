function dist = calcCenterOfMass(save_h,meanX,meanY,sigma)
x = mean(meanX(save_h~=0));
y = mean(meanY(save_h~=0));
dist = (x.^2)+(y.^2);  
if(isnan(dist))
    dist = Inf;
    return;
end
dist = exp(-dist./(sigma^2));
