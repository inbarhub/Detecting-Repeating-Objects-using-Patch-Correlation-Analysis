function applyParameters(str_for_save,str_to_save)
close all
params = loadMatLP(str_for_save);
fact = 4;
fact = 2;
x = paramsLP();
totPosHits = [];
totNegHits = [];
step_number = 0;

a_1 = zeros(size(params.I));
tmp = x*params.data;
recSize = 12;
click_count = 0;
parts = [7;3];
numOfCellsPos = 4;
numOfCellsNeg = 4;
constToAskMax = 1/(min(tmp));
constToAskMin = 1/(max(tmp)); 
indicesToAsk = getInitialIndicesToAsk(x*params.data,2*sum(parts));

tmp = constToAskMin.*x*params.data;
[a_1,newI] = askUser(tmp,indicesToAsk,params,recSize);
newImage = a_1.*newI;
figure(1); imshow(imresize(newImage,fact)); title(num2str(constToAskMin))

figure('Position', [0 99 100 100])
h = uibuttongroup('visible','off','Position',[0 0 1 1]);
max_slider = constToAskMax;
min_slider = constToAskMin;
step = 0.1;
newConst = min_slider;

valueConstEdit = uicontrol('Style','slider','SliderStep',[step step],'Min',min_slider,'Max',max_slider,'Value',min_slider,'pos',[0 0 85 40],'parent',h,'HandleVisibility','on','Callback',@constChanged_CB);
set(valueConstEdit,'FontWeight','bold');
set(valueConstEdit,'FontSize',10);
set(h,'Visible','on');
constText = uicontrol('Style','text','String',num2str(newConst),'pos',[0 45 50 15],'parent',h,'HandleVisibility','on');
startButton = uicontrol('Style','pushbutton','String','Start', 'pos',[0 60 50 25],'parent',h,'HandleVisibility','off');
set(startButton,'ForegroundColor',[0 0 0]);
set(startButton,'FontWeight','bold');
set(startButton,'Callback',@startPushButton_CB);

tic
    function constChanged_CB(hObject,eventdata)
        newConst = get(valueConstEdit,'Value');
        set(constText,'String',get(valueConstEdit,'Value'));
        tmp = newConst.*x*params.data;
        
        [a_1,new_I] = askUser(tmp,indicesToAsk,params,recSize);
        newImage = a_1.*new_I;
        figure(1); imshow(imresize(newImage,fact)); title(num2str(constToAskMin))
        constText = uicontrol('Style','text','String',num2str(newConst),'pos',[0 45 50 15],'parent',h,'HandleVisibility','on');   
    end
    
    function startPushButton_CB(hObject,eventdata) 
        for i = 1:50
            if(numOfCellsPos==0.5)
                numOfCellsPos = numOfCellsPos*2;
            end
            if(numOfCellsNeg==0.5)
                numOfCellsNeg = numOfCellsNeg*2;
            end
            [indicesPos,indicesNeg] = getIndices(tmp,numOfCellsPos,numOfCellsNeg);
            if(size(indicesPos{1},2) < parts(1) && size(indicesNeg{1},2) < parts(1) || step_number == 5)
                showFinalImage(a_1,params,str_to_save,step_number);
                saveTimeAndClicks(click_count,toc,str_to_save,counter,0)
                break;
            elseif(size(indicesPos{1},2) < parts(1))
                numOfCellsPos = numOfCellsPos/2;
            elseif(size(indicesNeg{1},2) < parts(1))
                numOfCellsNeg = numOfCellsNeg/2;
            end
            step_number = step_number+1;
            [indicesPos,indicesNeg] = getIndices(tmp,numOfCellsPos,numOfCellsNeg);
            [indicesToAskPos,indicesPos] = getIndicesToAsk(indicesPos,parts);
            [indicesToAskNeg,indicesNeg] = getIndicesToAsk(indicesNeg,parts);
            indicesToAsk = getAllIndicesToAsk(indicesToAskPos,indicesToAskNeg)';

            [a_1,new_I] = askUser(tmp,indicesToAsk,params,recSize);
            newImage = a_1.*new_I;
            figure(1);imshow(imresize(newImage,fact));
            locX_union = [];
            locY_union = [];
            valPositive = find(tmp>1);
            valNegative = find(tmp<1);
            extremePos = 0;
            extremeNeg = 0;
            for j = 1:2*sum(parts,1)
                figure(1)
                [locY,locX] = ginput(1);
                locX = round(locX/fact);
                locY = round(locY/fact);
                if(isempty(locY))
                    break;
                end
                point = round(rotatePoint([locX;locY],params.xFactor,params.yFactor,params.angle,params.origImage));
                locX = point(1);
                locY = point(2);
                loc = findCloseClust(locX,locY,params.info,indicesToAsk,params);
                
                [currExtremePos,currEextremeNeg] = checkIfUserChoseExtreme(indicesPos,indicesNeg,indicesToAsk(loc));
                extremePos = extremePos | currExtremePos;
                extremeNeg = extremeNeg | currEextremeNeg;
                
                locX_union = [locX_union,locX];
                locY_union = [locY_union,locY];

                newCenterPoint = round(rotatePoint(params.info(indicesToAsk(loc)).center,1/params.xFactor,1/params.yFactor,-params.angle,params.I));
                x_start = max(newCenterPoint(1)-recSize,1);
                x_end = min(newCenterPoint(1)+recSize,size(params.origImage,1));
                y_start = max(newCenterPoint(2)-recSize,1);
                y_end = min(newCenterPoint(2)+recSize,size(params.origImage,2));
                new_I = drawRectangle(new_I,x_start,x_end,y_start,y_end,0,0,params.origImage);
                click_count = click_count+1;
                newImage = a_1.*new_I;
                figure(1);imshow(imresize(newImage,fact))
            end
            
            if(extremePos)
                    numOfCellsPos = numOfCellsPos/2;
            else
                numOfCellsPos = numOfCellsPos*2;
            end
            if(extremeNeg)
                numOfCellsNeg = numOfCellsNeg/2;
            else
                numOfCellsNeg = numOfCellsNeg*2;
            end
                
            [ind_curr_pos,ind_curr_neg] = updateAskedIndices(tmp,locX_union,locY_union,params.info,indicesToAsk);
            contInd = getContIndices(tmp,ind_curr_pos,ind_curr_neg);
            [minEps,maxEps] = getEps(tmp,contInd);
            totPosHits = union(totPosHits,ind_curr_pos);    
            totNegHits = union(totNegHits,ind_curr_neg);           
            
            valPositive(tmp(valPositive) <= maxEps) = [];
            valNegative(tmp(valNegative) >= minEps) = [];
            
            valNegative(find((ismember(valNegative,totPosHits))==1)) = [];
            valPositive(find((ismember(valPositive,totNegHits))==1)) = [];

            valNegative = union(valNegative,totNegHits);
            valPositive = union(valPositive,totPosHits);
            
            [x,tmp] = loopUI(params,valPositive,valNegative);
            a_1 = zeros(size(params.I));
            [val,loc] = find(tmp>=1);
            counter = 0;
            for k = 1:size(loc,2)
                counter = counter+1;
                a_1(max(params.info(loc(k)).center(1)-1,1):min(params.info(loc(k)).center(1)+1,size(params.I,1)),max(params.info(loc(k)).center(2)-1,1):min(params.info(loc(k)).center(2)+1,size(params.I,2))) = 1;
            end
            counter
            params.I = params.I-min(params.I(:));
            params.I = params.I/max(params.I(:));
            figure(5); 
            imshow(showFinalImage(a_1,params,str_to_save,step_number));
            points_to_save = zeros(size(loc,2),2);
            for k = 1:size(loc,2)
                points_to_save(k,:) = [params.info(loc(k)).center(1),params.info(loc(k)).center(2)];
            end
            saveTimeAndClicks(click_count,toc,str_to_save,counter,points_to_save);
            
            pause(1.5)
        end
    end
end

function [indicesPos,indicesNeg] = getIndices(tmp,numOfCellsPos,numOfCellsNeg)
    [~,ind] = sort(tmp,'descend');
    pos = tmp(tmp > 1);
    neg = tmp(tmp <= 1);
     
    intervalPos_ce = ceil(size(pos,2)./numOfCellsPos);
    intervalNeg_ce = ceil(size(neg,2)./numOfCellsNeg);
    intervalPos_fl = floor(size(pos,2)./numOfCellsPos);
    intervalNeg_fl = floor(size(neg,2)./numOfCellsNeg);
    
    if(size(pos,2) - intervalPos_ce*(numOfCellsPos-1) < intervalPos_ce)
        intervalPos = intervalPos_fl;
    else
        intervalPos = intervalPos_ce;
    end
    if(size(neg,2) - intervalNeg_ce*(numOfCellsNeg-1) < intervalNeg_ce)
        intervalNeg = intervalNeg_fl;
    else
        intervalNeg = intervalNeg_ce;
    end
    numOfCellsPos = floor(size(pos,2)/intervalPos);
    numOfCellsNeg = floor(size(neg,2)/intervalNeg);

    for i = 1:numOfCellsPos
        indicesPos{floor(numOfCellsPos)-i+1} = ind((i-1)*intervalPos+1:i*intervalPos);
    end
    for j = 1:numOfCellsNeg
        indicesNeg{j} = ind(size(pos,2)+(j-1)*intervalNeg+1:size(pos,2)+j*intervalNeg);
    end
    
    leftPos = size(pos,2) - i*intervalPos;
    indicesPos{i} = union(indicesPos{i},ind(i*intervalPos+1:i*intervalPos+leftPos));
    leftNeg = size(neg,2) - j*intervalNeg;
    indicesNeg{j} = union(indicesNeg{j},ind(size(pos,2)+j*intervalNeg+1:size(pos,2)+j*intervalNeg+leftNeg));
end

function indicesToAsk = getInitialIndicesToAsk(tmp,num)
    [val,ind] = sort(tmp,'descend');
    intervals = floor(size(tmp,2)/num);
    indicesToAsk = ind(1:intervals:size(tmp,2))';
end

function contInd = getContIndices(tmp,ind_pos,ind_neg)
    [~,loc] = find(tmp(ind_pos) <= 1);
    contInd(1:size(loc,2),1) = ind_pos(loc);
    [~,loc_1] = find(tmp(ind_neg) >= 1);
    contInd(size(loc,2)+1:size(loc,2)+size(loc_1,2),1) = ind_neg(loc_1);
end

function [minEps,maxEps] = getEps(tmp,contInd)
    if(size(contInd,1) == 0)
        minEps = 1;
        maxEps = 1;
        return;
    end
    b = tmp(contInd);
    b_sorted = sort(b);
    minEps = min(1,b_sorted(1));
    maxEps = max(1,b_sorted(end));
end

function [indicesToAsk,indices] = getIndicesToAsk(indices,parts)
    sz = size(parts,1);
    p = 1;
    if(size(indices,2) == 1)
        sz = 1;
        parts(1) = sum(parts);
    end
    for i = 1:sz
        randomVecPos = randperm(size(indices{i},2),parts(i));
        indicesToAsk(p:p+parts(i)-1) = indices{i}(randomVecPos);
        p = p+parts(i);
    end    
end

function indicesToAsk = getAllIndicesToAsk(indicesToAskPos,indicesToAskNeg)
    indicesToAsk = union(indicesToAskPos,indicesToAskNeg);
end