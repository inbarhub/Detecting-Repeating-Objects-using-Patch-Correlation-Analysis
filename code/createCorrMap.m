function [corrMapScore,corr] = createCorrMap(I,M,ms,ps)
nf = size(M,2);
corrMapScore = cell(size(M,1));
corr = cell(1,nf);
rot_M  = cell(1,nf);

for i = 1:nf
    rot_M{i} = rot90(M{i},2);
end
for i = 1:nf
    corrMapScore{i}(i) = (-Inf);
    corr{i}{i} = [];
    if(isempty(M{i}))
        corrMapScore{i}(1:nf) = (-Inf);
        continue;
    end
    MI_padded = padarray(M{i},[ms.x ms.y]);
    for j = (i+1):nf
        if(isempty(M{j}) || i==j)
            continue;
        end
        curr_corr = conv2(MI_padded, rot_M{j} ,'valid');
        corr{i}{j} = curr_corr;
        curr_corr = curr_corr/sum(curr_corr(:));
        
        corr{j}{i} = rot90(curr_corr,2);
        
        max_corr = (max(curr_corr(:)));
        [loc_x,loc_y] = find(curr_corr == max_corr);
        if(size(loc_x,1) == 1)
            curr_corr(max(loc_x(1)-2*ps,1):min(loc_x(1)+2*ps,size(I,1)),max(loc_y(1)-2*ps,1):min(loc_y(1)+2*ps,size(I,2))) = 0;
            max_corr_2 = max(curr_corr(:));
            if(max_corr_2*2 < max_corr)
                corrMapScore{i}(j) = max_corr;
                corrMapScore{j}(i) = max_corr;
            else
                corrMapScore{i}(j) = (-Inf);
                corrMapScore{j}(i) = (-Inf);       
            end   
        else
            corrMapScore{i}(j) = (-Inf);
            corrMapScore{j}(i) = (-Inf);
        end
    end
end
end