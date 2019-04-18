function info = deleteMultPatchesInClust(info)
numOfPatches = unique(info.clust(:,3));
tmp = info.clust;
info.clust = [];
for j = 1:size(numOfPatches,1)
    [loc val] = find(tmp(:,3) == numOfPatches(j));
    [sort_val sort_loc] = sort(tmp(loc,4),'descend');
    info.clust(j,:) = tmp(loc(sort_loc(1)),:);
end
end