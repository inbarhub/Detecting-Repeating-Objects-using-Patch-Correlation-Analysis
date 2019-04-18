function loc = findCloseClust(x,y,info,ind,params)
loc = 0;
if(isempty(x) || isempty(y))
    return;
end

for i = 1:size(ind,1)
    dist(i) = sqrt((info(ind(i)).center(1)-x).^2+(info(ind(i)).center(2)-y).^2);
end
[val,loc] = sort(dist);
loc = loc(1);
end