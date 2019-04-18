function I = prepareImage(I)
[w,h,c] = size(I);
if(c > 1)
    I = rgb2gray(I);
end
I = double(I) / 255 ;
I = real(ifft2(fft2(I).*lap_fft(I)));
I(1,:) = 0;
I(end,:) = 0;
I(:,1) = 0;
I(:,end) = 0;
I = conv2(I,1/4.*[1 2 1],'same') ;
I = conv2(I,1/4.*[1 2 1]','same') ;
I = conv2(I,1/4.*[1 2 1],'same') ;
I = conv2(I,1/4.*[1 2 1]','same') ;
I = conv2(I,1/4.*[1 2 1],'same') ;
I = conv2(I,1/4.*[1 2 1]','same') ;
I = conv2(I,1/4.*[1 2 1],'same') ;
I = conv2(I,1/4.*[1 2 1]','same') ;
end