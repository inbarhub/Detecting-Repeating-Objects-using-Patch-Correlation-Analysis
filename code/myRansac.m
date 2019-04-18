function new_info = myRansac(hits,K)
h = fspecial('gaussian', 15, 3);
K = conv2(K,h,'same');
clust = double(imregionalmax(K));
[row,col] = find(clust==1);
k = 1;
centers = [0 0];

%find the centers
centers(1:size(row,1),1:2) = [row,col];
for i = 1:size(row,1)
   info(i).center = [row(i),col(i)];
end

info(1).clust = [];
Mdl = KDTreeSearcher(centers);
for i = 1:size(hits,1)
    curr = [hits(i,1),hits(i,2)];
    Idx = knnsearch(Mdl,curr,'K',k);
    tmp = centers(Idx,1:2);
    dist = sqrt((hits(i,1)-tmp(1)).^2 + (hits(i,2)-tmp(2)).^2);
    info(Idx).clust(end+1,:) = [i,dist,hits(i,3),hits(i,4)];
end

p = 1;
for i = 1:size(info,2)
    if(~isempty(info(i).clust))
        new_info(p) = info(i);
        p = p+1;
    end
end
end