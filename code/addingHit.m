function [hittedClust] = addingHit(dir,blocks,info,A,sz)
x = max(round(info.center(1) - 13*sin(dir)),1);
x = min(x,sz(1));
y = max(round(info.center(2) + 13*cos(dir)),1);
y = min(y,sz(2));
tmp = [x,y];
hittedClust = 0;
if(size(blocks{tmp(1),tmp(2)},2) ~= 0)
    numOfPatches = A(blocks{tmp(1),tmp(2)});
    [val,loc] = sort(numOfPatches,'descend');
    hittedClust = blocks{tmp(1),tmp(2)}(loc(1));
end
