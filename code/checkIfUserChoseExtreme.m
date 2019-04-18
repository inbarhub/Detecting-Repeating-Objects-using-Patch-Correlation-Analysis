function [extremePos,extremeNeg] = checkIfUserChoseExtreme(indicesPos,indicesNeg,currIndex)
if(size(indicesPos,2) == 1)
    currIndicesPos = indicesPos{1};
else
    currIndicesPos = indicesPos{2};
end
if(size(indicesNeg,2) == 1)
    currIndicesNeg = indicesNeg{1};
else
    currIndicesNeg = indicesNeg{2};
end

extremePos = 0;
extremeNeg = 0;
if(ismember(currIndex,currIndicesPos))
    extremePos = 1;
end
if(ismember(currIndex,currIndicesNeg))
    extremeNeg = 1;
end
end