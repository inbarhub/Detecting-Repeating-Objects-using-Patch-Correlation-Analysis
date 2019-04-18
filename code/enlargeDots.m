function out = enlargeDots(I)
out = zeros(size(I,1),size(I,2),3);
out(:,:,1) = I(:,:,1);
out(:,:,2) = I(:,:,1);
out(:,:,3) = I(:,:,1);
radius = 3;
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if(I(i,j,1) == 199/255 && I(i,j,2) == 31/255 && I(i,j,3) == 194/255)
            for k = max(i-radius,1):min(i+radius,size(I,1))
                for p = max(j-radius,1):min(j+radius,size(I,2))
                    if((k-i)^2+(p-j)^2 < radius^2)
                        out(round(k),round(p),1:3) = [199/255 31/255 194/255];
                    end
                end
            end
        end
    end
end