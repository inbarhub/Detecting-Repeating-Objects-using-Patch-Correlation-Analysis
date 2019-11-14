function saveData(folder,features,I,info,hits,origImage,angle,xFactor,yFactor,learning_time)
saveTimeAndClicks(0,learning_time,folder,0,0)
save([folder '\I_forCheck'],'I');
save([folder '\origImage_forCheck'],'origImage');
save([folder '\info_forCheck'],'info');
save([folder '\hits_forCheck'],'hits');
save([folder '\xFactor_forCheck'],'xFactor');
save([folder '\yFactor_forCheck'],'yFactor');
save([folder '\rotationAngle_forCheck'],'angle');

A = features.A;
save([folder '\A_forCheck'],'A');

numOfClusters = features.numOfClusters;
save([folder '\numOfClusters_forCheck'],'numOfClusters');

B = features.B;
save([folder '\B_forCheck'],'B');

C = features.C;
save([folder '\C_forCheck'],'C');

D = features.D;
save([folder '\D_forCheck'],'D');

angles = features.angles;
save([folder '\angles_forCheck'],'angles');

dist = features.dist;
save([folder '\dist_forCheck'],'dist');

h = features.sum_h;
save([folder '\h_forCheck'],'h');

comp = features.comp;
save([folder '\comp_forCheck'],'comp');

hittedClustInfo = features.hittedClustInfo;
save([folder '\hittedClustInfo_forCheck'],'hittedClustInfo');