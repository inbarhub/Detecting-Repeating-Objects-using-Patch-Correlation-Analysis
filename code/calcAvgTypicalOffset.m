function [meanX,meanY] = calcAvgTypicalOffset(sx,sy,numOfBins)
angles = atan2(-sx,sy);
meanX = zeros(numOfBins,1);
meanY = zeros(numOfBins,1);
edges = -pi:(2*pi/numOfBins):pi;

h = histc(angles,edges);
h_cum = ones(1,numOfBins+1);
h_cum(2:numOfBins+1) = cumsum(h(1:numOfBins));

[~,locAngle] = sort(angles);

for i = 1:numOfBins
    if(h_cum(i) == 0 || h_cum(i+1) == 0)
        continue;
    end
    tmp = locAngle(h_cum(i):h_cum(i+1));
    t = size(tmp,1);
    meanX(i) = sum(sx(tmp))/t;
    meanY(i) = sum(sy(tmp))/t;
end
end