function hittedClust = calcDirToCheck(info,save_h,blocks,features,sz)
numOfBins = size(save_h,2);
edges = -pi:(2*pi/numOfBins):pi;
hittedClust = zeros(size(info,2),10);
for i = 1:size(info,2)
    complexAngle = false;
    curr_h = save_h(i,:);
    zerosIntervals = getZerosIntervals(curr_h);
    zerosIntervals_complex = getZerosIntervals(curr_h);
    curr_h(curr_h~=0) = 1;
    if(isempty(zerosIntervals))
        continue;
    end
    if(zerosIntervals(1,1) == 1 && zerosIntervals(end,1)+zerosIntervals(end,2)-1 == numOfBins && zerosIntervals(1,2) + zerosIntervals(end,2) >= 5)
        complexAngle = true;
        lala = curr_h;
        lala(numOfBins:numOfBins+zerosIntervals(1,2)) = 0;
        lala(1:zerosIntervals(1,2)) = [];
        lala_edges = [edges pi+2*pi/numOfBins*(1:zerosIntervals(1,2))];
        lala_edges(1:zerosIntervals(1,2)) = [];
        zerosIntervals_complex = getZerosIntervals(lala);
    end
    
    if(complexAngle)
        curr_edges = lala_edges;
        curr_zerosIntervals = zerosIntervals_complex;
    else
        curr_edges = edges;
        curr_zerosIntervals = zerosIntervals;
    end
    for j = 1:size(curr_zerosIntervals,1)
        for k = 0:curr_zerosIntervals(j,2)-1
            dir = (curr_edges(curr_zerosIntervals(j,1)+k) + curr_edges(curr_zerosIntervals(j,1)+k+1))/2;
            curr_hittedClust = addingHit(dir,blocks,info(i),features.A,sz);
            if(curr_hittedClust ~= 0)
               hittedClust(i,:) = hittedClust(i,:) + [features.A(curr_hittedClust),features.B(curr_hittedClust),features.C(curr_hittedClust),features.D(curr_hittedClust,:),features.dist(curr_hittedClust),features.angles(curr_hittedClust),features.sum_h(curr_hittedClust),features.comp(curr_hittedClust)];
            end
        end
    end
end
end

