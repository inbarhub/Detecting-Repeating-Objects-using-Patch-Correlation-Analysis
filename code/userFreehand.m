function [I,origImage,angle,xFactor,yFactor] = userFreehand(path)
optX = 5;
optY = 5;
I = imread(path) ;

if ~isempty(strfind(path,'cell'))
    for i =1:3
        I(:,:,i) = I(:,:,3);
    end
end
origImage = I;
figure; imshow(I)
ROI = imfreehand();
[row,col] = find(ROI.createMask==1);

tmp = [row,col];
[COEFF,~,latent] = princomp(tmp);
gamma_1 = sqrt(latent(1));
gamma_2 = sqrt(latent(2));

% if(gamma_1/gamma_2 < 2)
%     angle = 0;
%     rot = 0;
% else
%     
%     I = imrotate(I,angle);
%     rot = 1;
% end
angle = atan2(COEFF(1,1),COEFF(2,1))*180/pi;

% if abs(angle) < 45 and 
if abs(angle) < 45
    rad_y = gamma_1;
    rad_x = gamma_2;
else
    rad_y = gamma_2;
    rad_x = gamma_1;
end

sz = size(I);
xFactor = optX/rad_x;
yFactor = optY/rad_y;
if(gamma_1/gamma_2 < 2)
    xFactor = 1;
    yFactor = 1;
    if gamma_1 > 8 || gamma_2 > 8
        xFactor = 7/rad_x; %10
        yFactor = 7/rad_y;
    end
end
angle = 0;
I = imresize(I,round(sz(1:2).*[xFactor,yFactor]));
I = imresize(I,round(sz(1:2).*[0.7,0.7]));

end