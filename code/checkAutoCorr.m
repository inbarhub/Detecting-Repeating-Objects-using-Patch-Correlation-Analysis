function new_M = checkAutoCorr(M,ms,sz)
a = 5;
b = 18;
D = zeros(2,2);
new_M = [];
R_padded = padarray(M,[ms.x ms.y]);
R = conv2(R_padded, rot90(M,2),'valid');
R = R./max(R(:));

[row,col] = find(R>1/10);
[COEFF,~,latent] = princomp([row,col]);
latent = gather(latent);
D(1,1) = (1.35*sqrt(latent(1))/2);
D(2,2) = (1.35*sqrt(latent(2))/2);
m = COEFF*D*COEFF';
[X,Y] = meshgrid(-floor(size(R,2)/2):floor(size(R,2)/2),-floor(size(R,1)/2):floor(size(R,1)/2));

kernel = exp((X./m(2,2)).^2+(Y./m(1,1)).^2).^(-1);
kernel = kernel/max(kernel(:));

R_1 = conv2(M, rot90(kernel,2));
R_1 = gather(R_1);
R_1 = R_1(round(size(R_1,1)/2)-sz(1)/2+1:round(size(R_1,1)/2)+sz(1)/2,round(size(R_1,2)/2)-sz(2)/2+1:round(size(R_1,2)/2)+sz(2)/2) ;  
if(isnan(sum(R_1(:))))
    return;
end
new_M = double(imregionalmax(gather(R_1)));
