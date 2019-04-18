function [new_best_corr_map,new_M,new_corr_cell,indEmpty] = findBestCorrMap(I,M,ms,ps)

nf = size(M,2);
%find best correlation for each map
best_corr_map = cell(1,1);

[score,corr_cell] = createCorrMap(I,M,ms,ps);
for i = 1:nf
    [val,~] = sort(score{i},'descend');
    if(val(1) == -Inf || val(2) == -Inf || val(3) == -Inf || val(4) == -Inf || val(5) == -Inf || val(6) == -Inf)
        M{i} = [];
        score{i} = -Inf.*ones(1,nf);
    end
end
emptyCells = cellfun(@isempty,M);

for i = 1:nf
    best_corr_map{i} = ([]);
    score{i}(emptyCells) = -Inf;
    [val,loc_1] = sort(score{i},'descend');
    [~,loc_notInf] = find(val~=-Inf);
    if(size(loc_notInf,2) < 7)
        M{i} = [];
        continue;
    end
    best_corr_map{i}(1:size(loc_notInf,2)) = loc_1(loc_notInf);
end

p = 1;
map(1:size(M,2)) = 0;
for i = 1:size(M,2)
    if(~isempty(M{i}))
        map(i) = p;
        p = p+1;
    end
end

emptyCells = cellfun(@isempty,M);
new_M = M(~cellfun('isempty',M));
indEmpty = find(emptyCells);

p = 1;
for i = 1:size(M,2)
    k = 1;
    if(isempty(best_corr_map{i}))
        continue;
    end
    for j = 1:size(best_corr_map{i},2)
        if(~ismember(best_corr_map{i}(j),indEmpty))
            if(map(best_corr_map{i}(j)) ~= 0)
                new_best_corr_map{p}(k) = map(best_corr_map{i}(j));
                new_corr_cell{p}{k} = corr_cell{i}{best_corr_map{i}(j)};
                k = k+1;
            end
        end
    end
    p = p+1;
end
end
