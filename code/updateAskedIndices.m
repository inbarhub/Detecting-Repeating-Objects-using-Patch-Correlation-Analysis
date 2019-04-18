function [ind_pos,ind_neg] = updateAskedIndices(tmp,x,y,info,ind)
ind_pos = ind(tmp(ind)>=1);
ind_neg = ind(tmp(ind)<=1);

deletePos = [];
deleteNeg = [];
addedPos = [];
addedNeg = [];
for j = 1:size(x,2)
    for i = 1:size(ind,1)
        dist(i) = sqrt((info(ind(i)).center(1)-x(j)).^2+(info(ind(i)).center(2)-y(j)).^2);
    end
    [val,loc] = sort(dist);
    locInPos = find(ind_pos == ind(loc(1)));
    if(size(locInPos) ~= 0)
         deletePos = union(deletePos,locInPos);
         addedNeg = union(addedNeg,ind(loc(1)));
    else
        locInNeg = find(ind_neg == ind(loc(1)));
        deleteNeg = union(deleteNeg,locInNeg);
        addedPos = union(addedPos,ind(loc(1)));
    end
end
ind_pos(deletePos) = [];
ind_neg(deleteNeg) = [];

ind_pos = union(ind_pos,addedPos);
ind_neg = union(ind_neg,addedNeg);
end