function blocks = createBlocks(info,sz)
blocks = cell(sz(1),sz(2));
nc = size(info,2);
for i = 1:nc
    radius = 10;
    center = [info(i).center(1),info(i).center(2)];
    for k = max(center(1)-radius,1):min(center(1)+radius,sz(1))
        for p = max(center(2)-radius,1):min(center(2)+radius,sz(2))
            if((k-center(1))^2+(p-center(2))^2 < radius^2)
                loc = size(blocks{round(k),round(p)},1);
                blocks{round(k),round(p)}(loc+1) = i;
            end
        end
    end
end
end

