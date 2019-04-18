function C = calcC(hits,info,best_corr_map,sx,sy,bx,by,sigma)
num = size(info,2);
C = zeros(num,1);
n(1) = 1;
for i = 2:size(sx,1)
    n(i) = n(i-1) + size(best_corr_map{i-1},2);
end
for j = 1:size(info.clust,1)
    curr_loc_j = hits(info.clust(j,1),1:2);
    curr_patch_j = hits(info.clust(j,1),3);
    prev_loc_j = [curr_loc_j(1)+sx(curr_patch_j),curr_loc_j(2)+sy(curr_patch_j)];
    dist_tmp = 0;
    for k = 1:size(info.clust,1)
        curr_patch_k = hits(info.clust(k,1),3);
        [val,loc] = find(curr_patch_k == best_corr_map{curr_patch_j});
        if(~isempty(loc))
            curr_loc_k = hits(info.clust(k,1),1:2);
            prev_loc_k = [curr_loc_k(1)+sx(curr_patch_k),curr_loc_k(2)+sy(curr_patch_k)];
            tmp = (prev_loc_j(1)-prev_loc_k(1)-bx(n(curr_patch_j) + loc-1)).^2 + (prev_loc_j(2)-prev_loc_k(2)-by(n(curr_patch_j) + loc-1)).^2;
            dist_tmp = dist_tmp + exp(-tmp/(sigma.^2));
        end
    end
    C = C+dist_tmp;
end

end