function out = showFinalImage(a_1,params,str_to_save,step_number)
I = imresize(params.origImage,[size(params.I,1),size(params.I,2)]);
out = zeros(size(I));
out(:,:,1) = rgb2gray(I);
out(:,:,2) = rgb2gray(I);
out(:,:,3) = rgb2gray(I);
out = out/max(out(:));
tmp = out(:,:,1);
tmp(find(a_1==1)) = 199/255;
out(:,:,1) = tmp;

tmp = out(:,:,2);
tmp(find(a_1==1)) = 31/255;
out(:,:,2) = tmp;

tmp = out(:,:,3);
tmp(find(a_1==1)) = 194/255;
out(:,:,3) = tmp;

out = enlargeDots(out);
imwrite(out,[str_to_save '/final_res' int2str(step_number) '.png']);

end