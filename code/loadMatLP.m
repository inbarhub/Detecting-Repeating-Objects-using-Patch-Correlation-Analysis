function [params,info] = loadMatLP(str)
path = [];
if(~isempty('str'))
    path = [path str '\'];
end

I = load([path 'I_forCheck']);
params.I = I.I;
numOfClusters = load([path 'numOfClusters_forCheck']);
numOfClusters = numOfClusters.numOfClusters;
A = load([path 'A_forCheck']);
A = A.A;
B = load([path 'B_forCheck']);
B = B.B;
C = load([path 'C_forCheck']);
C = C.C;
D = load([path 'D_forCheck']);
D = D.D;
dist = load([path 'dist_forCheck']);
dist = dist.dist;
angles = load([path 'angles_forCheck']);
angles = angles.angles;
h = load([path 'h_forCheck']);
h = h.h;
hittedClustInfo = load([path 'hittedClustInfo_forCheck']);
hittedClustInfo = hittedClustInfo.hittedClustInfo;
comp = load([path 'comp_forCheck']);
comp = comp.comp;

info = load([path 'info_forCheck']);
params.info = info.info;
origImage = load([path 'origImage_forCheck']);
params.origImage = im2double(origImage.origImage);

xFactor = load([path 'xFactor_forCheck']);
params.xFactor = xFactor.xFactor; 
yFactor = load([path 'yFactor_forCheck']);
params.yFactor = yFactor.yFactor;
angle = load([path 'rotationAngle_forCheck']);
params.angle = angle.angle;

params.data = [A(1:numOfClusters)';B(1:numOfClusters)';C(1:numOfClusters)';D(1:numOfClusters,:)';dist(1:numOfClusters,:)';angles(1:numOfClusters)';h(1:numOfClusters)';comp(1:numOfClusters,:)';hittedClustInfo(1:numOfClusters,:)'];

