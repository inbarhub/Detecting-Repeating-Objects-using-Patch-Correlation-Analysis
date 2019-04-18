function [min_angle,s,save_h] = calcAngles(info,hits,edges,sx,sy,numOfBins)
complexAngle = 0;
portion = (2*pi/numOfBins);

dist_1 = zeros(size(info.clust,1));
angle = zeros(size(info.clust,1));
for j = 1:size(info.clust,1)      
        center = info.center(1:2);
        x_dir = hits(info.clust(j),1) + (sx(info.clust(j,3)))-center(1);
        y_dir = hits(info.clust(j),2) + (sy(info.clust(j,3)))-center(2);
        dist_1(j) = sqrt((center(2) - hits(info.clust(j),2)).^2+(center(1)-hits(info.clust(j),1)).^2);
        angle(j) = atan2(-x_dir,y_dir);
end
h = histc(angle,edges);
h = h(1:numOfBins);
save_h = h;
h(h~=0) = 1;
s = sum(h);

zerosIntervals = getZerosIntervals(h);
if(~isempty(zerosIntervals) && zerosIntervals(1,1) == 1 && zerosIntervals(end,1)+zerosIntervals(end,2)-1 == numOfBins && zerosIntervals(1,2) + zerosIntervals(end,2) >= 5)
    complexAngle = true;
    lala = h;
    lala(numOfBins:numOfBins+zerosIntervals(1,2)) = 0;
    lala(1:zerosIntervals(1,2)) = [];
    lala_edges = [edges pi+2*pi/numOfBins*(1:zerosIntervals(1,2))];
    lala_edges(1:zerosIntervals(1,2)) = [];
    zerosIntervals_complex = getZerosIntervals(lala);    
end

if(isempty(zerosIntervals))
    min_angle = 0;
elseif(complexAngle)
    [~,loc] = max(zerosIntervals_complex(:,2));
    min_angle = zerosIntervals_complex(loc,2)*portion;
else
    [~,loc] = max(zerosIntervals(:,2));
    min_angle = zerosIntervals(loc,2)*portion;
end
min_angle = 2*pi - min_angle;
if(size(info.clust,1) <= 1 )
       min_angle = 0;
end

min_angle = min_angle';
s = s';
end
