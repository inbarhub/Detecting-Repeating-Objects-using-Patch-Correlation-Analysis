function features = createFeatures(info,hits,best_corr_map,sx,sy,bx,by,numOfBins,meanX,meanY,cellSize,sz)

edges = -pi:(2*pi/numOfBins):pi;
nc = size(info,2);
for i = 1:nc
    info(i) = deleteMultPatchesInClust(info(i));
    features.comp(i,1) = compensateBorders(info(i),1.3.*cellSize,sz);
    features.A(i,1) = size(info(i).clust(:,3),1);
    features.B(i,1) = sum(info(i).clust(:,4))/features.A(i);
    features.C(i,1) = calcC(hits,info(i),best_corr_map,sx,sy,bx,by,2);   
    D(i,info(i).clust(:,3)) = 1;
    [features.angles(i,1),features.sum_h(i,1),save_h(i,:)] = calcAngles(info(i),hits,edges,sx,sy,numOfBins);
    features.dist(i,1) = calcCenterOfMass(save_h(i,:),meanX,meanY,1);

end

[vec,val] = eig(cov(D));
val = max(val);
[~, ind] = sort(val,'descend');
vec = vec(:,ind);
tmp = D*vec; 
features.D = tmp(:,1:3);

features.numOfClusters = size(features.B,1);
blocks = createBlocks(info,sz);
features.hittedClustInfo = calcDirToCheck(info,save_h,blocks,features,sz);
end
