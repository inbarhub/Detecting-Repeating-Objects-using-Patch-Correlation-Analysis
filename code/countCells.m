
function [features,hits,info] = countCells(image_name,participant_name,active)
image_path = ['../images/' image_name '.png'];
if ~exist(image_path)
    image_path = ['../images/' image_name '.jpg'];
end
if ~exist(image_path)
    image_path = ['../images/' image_name '.bmp'];
end

close all;

if ~active
    run_num = 0;
    save_params = ['res/' image_name '/' participant_name int2str(run_num)];
    new_str = save_params;
    while exist(new_str)
        run_num = run_num+1;
        new_str = ['res/' image_name '/' participant_name int2str(run_num)];
    end
else
    run_num = 0;
    new_str = ['res/' image_name '/' participant_name int2str(run_num)];
end
save_params_str = new_str;
display(['running from ' save_params_str])

run_num = 0;
run_params = ['res_params/' image_name '/' participant_name int2str(run_num)];
new_str = run_params;
while exist(new_str)
    run_num = run_num+1;
    new_str = ['res_params/' image_name '/' participant_name int2str(run_num)];
end
run_params_str = new_str;

display(['save in ' run_params_str])

mkdir(run_params_str)
mkdir(save_params_str)

if ~active
    str_for_save = new_str;
    %%
    [I,origImage,angle,xFactor,yFactor] = userFreehand(image_path);
    %%%%%%%%%%%%%%%prepare image%%%%%%%%%%%%%%%
    %%
    I = prepareImage(I);
    gt = [];
    % if(exist([str 'dots.png'], 'file'))
    %     gt = im2double(imread([str 'dots.png']));
    % end
    %%
    %%%%%%%%%%%%%%%parameters%%%%%%%%%%%%%%%%%
    sz = size(I);
    ps = 4 ;
    thr = 0.75;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ms.x = 35 ;
    ms.y = 35 ;
    numOfBins = 16;
    stopCond = 0.4;%0.8;
    tic
    % %%
    % %%%%%%%%%%%%%%%create\match filters%%%%%%%%%%%%%
    [M,M_WithCorrVal,filters] = createFilters(I,ms,ps,thr,stopCond);
    %%
    %%%%%%%%%%%%%%%best filters for each filter%%%%%%%%%%%%%
    [best_corr_map,M,corr_cell,ind] = findBestCorrMap(I,M,ms,ps);
    M_WithCorrVal([ind]) = {[]};
    M_WithCorrVal = M_WithCorrVal(~cellfun('isempty',M_WithCorrVal));
    %%
    %%%%%%%%%%%%%%%create and solve Eq%%%%%%%%%%%%%%%%%%
    [D,bx,by] = createEq(corr_cell,best_corr_map,ms);
    [sx,sy] = solveEq(D,bx,by);
    %%%%%%%%%%%%%%%locate hits%%%%%%%%%%%%%%%%%%
    [hits,K] = locateHits(I,M,M_WithCorrVal,sx,sy,ms);
    %%%%%%%%%%%%%%%RANSAC%%%%%%%%%%%%%%%%%%
    cellSize = 8;
    [info] = myRansac(hits,K);
    %%
    %%%%%%%%%%%%%%%calculate features%%%%%%%%%%%%%%%%%%
    [meanX,meanY] = calcAvgTypicalOffset(sx,sy,numOfBins);
    features = createFeatures(info,hits,best_corr_map,sx,sy,bx,by,numOfBins,meanX,meanY,cellSize,sz);
    features.centers = getCenters(info);
    if(~isempty(gt))
        features.gt = gt;
    end

    %%
    %%%%%%%%%%%%%%%Saving data%%%%%%%%%%%%%%%%%%
    saveData(save_params_str,features,I,info,hits,origImage,angle,xFactor,yFactor,toc)
    % %%
else
    %%%%%%%%%%%%%%%Interactive%%%%%%%%%%%%%%%%%%
    applyParameters(save_params_str,run_params_str)
end